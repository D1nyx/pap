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
  final exerciseNameController = TextEditingController();
  final weightController = TextEditingController();
  final repsController = TextEditingController();
  final setsController = TextEditingController();

  @override
  void dispose() {
    exerciseNameController.dispose();
    weightController.dispose();
    repsController.dispose();
    setsController.dispose();
    super.dispose();
  }

  void onCheckBoxChanged(String workoutName, String exerciseName) {
    Provider.of<WorkoutData>(context, listen: false)
        .checkOffExercise(workoutName, exerciseName);
  }

  void createNewExercise() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Adicionar novo exercício',
          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(
              controller: exerciseNameController,
              hintText: "Nome do Exercício",
            ),
            _buildTextField(
              controller: weightController,
              hintText: "Peso (kg)",
              keyboardType: TextInputType.number,
            ),
            _buildTextField(
              controller: repsController,
              hintText: "Repetições",
              keyboardType: TextInputType.number,
            ),
            _buildTextField(
              controller: setsController,
              hintText: "Sets",
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: save,
            style: TextButton.styleFrom(foregroundColor: Colors.green),
            child: const Text("Guardar"),
          ),
          TextButton(
            onPressed: cancel,
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Cancelar"),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey),
          ),
        ),
        keyboardType: keyboardType,
        style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
      ),
    );
  }

  void save() {
    String newExerciseName = exerciseNameController.text.trim();
    String weight = weightController.text.trim();
    String reps = repsController.text.trim();
    String sets = setsController.text.trim();

    if (newExerciseName.isNotEmpty &&
        weight.isNotEmpty &&
        reps.isNotEmpty &&
        sets.isNotEmpty) {
      Provider.of<WorkoutData>(context, listen: false).addExercise(
        widget.workoutName,
        newExerciseName,
        weight,
        reps,
        sets,
      );
    }

    Navigator.pop(context);
    clear();
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    exerciseNameController.clear();
    weightController.clear();
    repsController.clear();
    setsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4A148C), Color(0xFF880E4F)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                title: Text(
                  widget.workoutName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: ListView.builder(
                    itemCount:
                        value.numberOfExercisesInWorkout(widget.workoutName),
                    itemBuilder: (context, index) {
                      var exercise = value
                          .getRelevantWorkout(widget.workoutName)
                          .exercises[index];
                      return ExerciseTitle(
                        exerciseName: exercise.name,
                        weight: exercise.weight,
                        reps: exercise.reps,
                        sets: exercise.sets,
                        isCompleted: exercise.isCompleted,
                        onCheckBoxChanged: (val) => onCheckBoxChanged(
                          widget.workoutName,
                          exercise.name,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewExercise,
          backgroundColor: Colors.pinkAccent,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
