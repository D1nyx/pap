import 'package:flutter/material.dart';
import 'package:pap/data/hive_database.dart';
import 'package:pap/datetime/date_time.dart';
import 'package:pap/models/exercise.dart';
import 'package:pap/models/workout.dart';

class WorkoutData extends ChangeNotifier {
  final HiveDatabase db = HiveDatabase();

  List<Workout> workoutList = [];
  Map<DateTime, int> heatMapDataSet = {};

  void initializeWorkoutList() {
    if (db.previousDataExists()) {
      workoutList = db.readFromDatabase();
    } else {
      db.saveToDatabase(workoutList);
    }
    loadHeatMap();
  }

  List<Workout> getWorkoutList() {
    return workoutList;
  }

  int numberOfExercisesInWorkout(String workoutName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    return relevantWorkout.exercises.length;
  }

  void addWorkout(String name) {
    workoutList.add(Workout(name: name, exercises: []));
    notifyListeners();
    db.saveToDatabase(workoutList);
  }

  void addExercise(String workoutName, String exerciseName, String weight, String reps, String sets) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    relevantWorkout.exercises.add(
      Exercise(
        name: exerciseName,
        weight: weight,
        reps: reps,
        sets: sets,
        isCompleted: false,
      ),
    );
    notifyListeners();
    db.saveToDatabase(workoutList);
  }

  void editWorkout(String oldName, String newName) {
    int index = workoutList.indexWhere((workout) => workout.name == oldName);
    if (index != -1) {
      workoutList[index] = Workout(
        name: newName,
        exercises: workoutList[index].exercises,
      );
      notifyListeners();
      db.saveToDatabase(workoutList);
    }
  }

  void removeWorkout(String workoutName) {
    Workout workoutToRemove = getRelevantWorkout(workoutName);
    for (var exercise in workoutToRemove.exercises) {
      exercise.isCompleted = false;
    }
    workoutList.removeWhere((workout) => workout.name == workoutName);
    notifyListeners();
    db.saveToDatabase(workoutList);
    loadHeatMap();
  }

  void checkOffExercise(String workoutName, String exerciseName) {
    Exercise relevantExercise = getRelevantExercise(workoutName, exerciseName);
    relevantExercise.isCompleted = !relevantExercise.isCompleted;
    notifyListeners();
    db.saveToDatabase(workoutList);
    loadHeatMap();
  }

  Workout getRelevantWorkout(String workoutName) {
    return workoutList.firstWhere((workout) => workout.name == workoutName, orElse: () {
      throw Exception("Workout '$workoutName' not found");
    });
  }

  Exercise getRelevantExercise(String workoutName, String exerciseName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    return relevantWorkout.exercises.firstWhere((exercise) => exercise.name == exerciseName, orElse: () {
      throw Exception("Exercise '$exerciseName' not found in workout '$workoutName'");
    });
  }

  String getStartDate() {
    return db.getStartDate();
  }

  void loadHeatMap() {
    heatMapDataSet.clear();
    DateTime startDate = createDateTimeObject(getStartDate());
    int daysInBetween = DateTime.now().difference(startDate).inDays;
    for (int i = 0; i <= daysInBetween; i++) {
      DateTime currentDate = startDate.add(Duration(days: i));
      String yyyymmdd = convertDateTimeToYYYYMMDD(currentDate);
      int completionStatus = db.getCompletedStatus(yyyymmdd);
      heatMapDataSet[currentDate] = completionStatus;
    }
  }
}
