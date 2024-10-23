import 'package:hive_flutter/hive_flutter.dart';
import 'package:pap/datetime/date_time.dart';
import 'package:pap/models/exercise.dart';
import 'package:pap/models/workout.dart';

class HiveDatabase {
  final _myBox = Hive.box("workout_database1");

  bool previousDataExists() {
    if (_myBox.isEmpty) {
      print("Os dados anteriores NÃO existem");
      _myBox.put("START_DATE", todaysDateYYYYMMDD());
      return false;
    } else {
      print("Os dados anteriores existem");
      return true;
    }
  }

  String getStartDate() {
    return _myBox.get("START_DATE", defaultValue: "");
  }

  void saveToDatabase(List<Workout> workouts) {
    final workoutList = convertObjectToWorkoutList(workouts);
    final exerciseList = convertObjectToExerciseList(workouts);

    if (exerciseCompleted(workouts)) {
      _myBox.put("COMPLETION_STATUS_${todaysDateYYYYMMDD()}", 1);
    } else {
      _myBox.put("COMPLETION_STATUS_${todaysDateYYYYMMDD()}", 0);
    }

    _myBox.put("WORKOUTS", workoutList);
    _myBox.put("EXERCISES", exerciseList);
  }

  List<Workout> readFromDatabase() {
    List<Workout> mySavedWorkouts = [];

    // Retrieve the workout names and exercises
    List<String> workoutNames = List<String>.from(_myBox.get("WORKOUTS", defaultValue: []));
    
    // Retrieve and cast the exercise details safely
    List<dynamic> exerciseDetailsDynamic = _myBox.get("EXERCISES", defaultValue: []);
    
    // Ensure correct casting
    List<List<List<dynamic>>> exerciseDetails = exerciseDetailsDynamic.map((item) {
      return List<List<dynamic>>.from(item.map((innerItem) => List<dynamic>.from(innerItem)));
    }).toList();

    // Process each workout and its exercises
    for (int i = 0; i < workoutNames.length; i++) {
      List<Exercise> exercisesInWorkout = [];

      for (int j = 0; j < exerciseDetails[i].length; j++) {
        exercisesInWorkout.add(
          Exercise(
            name: exerciseDetails[i][j][0].toString(),
            weight: exerciseDetails[i][j][1].toString(),
            reps: exerciseDetails[i][j][2].toString(),
            sets: exerciseDetails[i][j][3].toString(),
            isCompleted: exerciseDetails[i][j][4] == "true",
          ),
        );
      }

      Workout workout = Workout(name: workoutNames[i], exercises: exercisesInWorkout);
      mySavedWorkouts.add(workout);
    }

    return mySavedWorkouts;
  }

  bool exerciseCompleted(List<Workout> workouts) {
    for (var workout in workouts) {
      for (var exercise in workout.exercises) {
        if (exercise.isCompleted) {
          return true;
        }
      }
    }
    return false;
  }

  int getCompletedStatus(String yyyymmdd) {
    int completionStatus = _myBox.get("COMPLETION_STATUS_$yyyymmdd", defaultValue: 0);
    return completionStatus;
  }
}

List<String> convertObjectToWorkoutList(List<Workout> workouts) {
  List<String> workoutList = [];

  for (int i = 0; i < workouts.length; i++) {
    workoutList.add(workouts[i].name);
  }

  return workoutList;
}

List<List<List<String>>> convertObjectToExerciseList(List<Workout> workouts) {
  List<List<List<String>>> exerciseList = [];

  for (int i = 0; i < workouts.length; i++) {
    List<Exercise> exercisesInWorkout = workouts[i].exercises;

    List<List<String>> individualWorkout = [];

    for (int j = 0; j < exercisesInWorkout.length; j++) {
      List<String> individualExercise = [];
      individualExercise.addAll([
        exercisesInWorkout[j].name,
        exercisesInWorkout[j].weight,
        exercisesInWorkout[j].reps,
        exercisesInWorkout[j].sets,
        exercisesInWorkout[j].isCompleted.toString(),
      ]);
      individualWorkout.add(individualExercise);
    }

    exerciseList.add(individualWorkout);
  }

  return exerciseList;
}
