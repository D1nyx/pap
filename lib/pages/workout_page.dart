import 'package:flutter/material.dart';
import 'package:pap/components/exercise_title.dart';
import 'package:pap/data/workout_data.dart';
import 'package:provider/provider.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;
  const WorkoutPage({super.key, required this.workoutName});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {

  void onCheckBoxChanged(String workoutName, String exerciseName) {
    Provider.of<WorkoutData>(context, listen: false)
    .checkOffExercise(workoutName, exerciseName);
  }

  final exerciseNameController = TextEditingController();
  final weightController = TextEditingController();
  final repsController = TextEditingController();
  final setsController = TextEditingController();

  void createNewExercise() {
      showDialog(context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adicionar novo exercício'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              TextField(
                controller: exerciseNameController,
                decoration: const InputDecoration(hintText: "Nome do Exercício"),
              ),

               TextField(
                controller: weightController,
                decoration: const InputDecoration(hintText: "Peso"),
              ),

               TextField(
                controller: repsController,
                decoration: const InputDecoration(hintText: "Repetições"),
              ),

               TextField(
                controller: setsController,
                decoration: const InputDecoration(hintText: "Sets"),
              ),

            ],
          ),
        actions: [
            MaterialButton(
            onPressed: save,
            child: const Text("Guardar"),
          ),

            MaterialButton(
            onPressed: cancel,
            child: const Text("Cancelar"),
          ),
        ],
      ),
    );
  }

  void save() {
    String newExerciseName = exerciseNameController.text;
    String weight = weightController.text;
    String reps = repsController.text;
    String sets = setsController.text;

    Provider.of<WorkoutData>(context, listen: false).addExercise(
      widget.workoutName,
      newExerciseName,
      weight,
      reps,
      sets,
      );

    Navigator.pop(context);
    clear();
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear(){
    exerciseNameController.clear();
    weightController.clear();
    repsController.clear();
    setsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(title: Text(widget.workoutName)),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewExercise,          
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
            itemCount: value.numberOfExercisesInWorkout(widget.workoutName),
          itemBuilder: (context, index) => ExerciseTitle(
            exerciseName: value
              .getRelevantWorkout(widget.workoutName)
              .exercises[index]
              .name,
            weight: value
              .getRelevantWorkout(widget.workoutName)
              .exercises[index]
              .weight,
            reps: value
              .getRelevantWorkout(widget.workoutName)
              .exercises[index]
              .reps,
            sets: value
              .getRelevantWorkout(widget.workoutName)
              .exercises[index]
              .sets,
            isCompleted: value
              .getRelevantWorkout(widget.workoutName)
              .exercises[index]
              .isCompleted,
            onCheckBoxChanged: (val) => onCheckBoxChanged(
              widget.workoutName,
              value
                .getRelevantWorkout(widget.workoutName)
                .exercises[index]
                .name,
            ),
          ),
        ),
      ),
    );
  }
}