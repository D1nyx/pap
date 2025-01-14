import 'package:flutter/material.dart';
import 'package:pap/components/heat_map.dart';
import 'package:pap/data/workout_data.dart';
import 'package:pap/models/workout.dart';
import 'package:provider/provider.dart';
import 'workout_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final newWorkoutNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<WorkoutData>(context, listen: false).initializeWorkoutList();
  }

  @override
  void dispose() {
    newWorkoutNameController.dispose();
    super.dispose();
  }

  void createNewWorkout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Text(
          "Criar novo treino",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        content: TextField(
          controller: newWorkoutNameController,
          decoration: InputDecoration(
            hintText: "Nome do treino",
            hintStyle: TextStyle(color: Colors.grey[600]),
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          style: const TextStyle(color: Colors.black),
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

  void goToWorkoutPage(String workoutName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutPage(workoutName: workoutName),
      ),
    );
  }

  void save() {
    String newWorkoutName = newWorkoutNameController.text.trim();
    if (newWorkoutName.isNotEmpty) {
      Provider.of<WorkoutData>(context, listen: false).addWorkout(newWorkoutName);
    }
    Navigator.pop(context);
    clear();
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    newWorkoutNameController.clear();
  }

  void editWorkout(BuildContext context, Workout workout) {
    final controller = TextEditingController(text: workout.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Editar Treino"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "Novo nome do treino",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              String newName = controller.text.trim();
              if (newName.isNotEmpty) {
                Provider.of<WorkoutData>(context, listen: false).editWorkout(workout.name, newName);
              }
              Navigator.pop(context);
            },
            child: const Text("Guardar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
        ],
      ),
    );
  }

  void deleteWorkout(BuildContext context, String workoutName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Eliminar Treino"),
        content: const Text("Tem certeza que deseja eliminar este treino?"),
        actions: [
          TextButton(
            onPressed: () {
              Provider.of<WorkoutData>(context, listen: false).removeWorkout(workoutName);
              Navigator.pop(context);
            },
            child: const Text("Sim"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Não"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1A237E), Color(0xFFD500F9)],
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
                title: const Text(
                  'FitJourney',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: MyHeatMap(
                      datasets: value.heatMapDataSet,
                      startDateYYYYMMDD: value.getStartDate(),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  itemCount: value.getWorkoutList().length,
                  itemBuilder: (context, index) {
                    final workout = value.getWorkoutList()[index];

                    bool hasSelectedExercise = workout.exercises.any((exercise) => exercise.isCompleted);

                    return GestureDetector(
                      onTap: () => goToWorkoutPage(workout.name),
                      child: Card(
                        color: hasSelectedExercise ? Colors.green : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: Image.asset(
                            'lib/images/logo.png',
                            width: 40,
                            height: 40,
                          ),
                          title: Text(
                            workout.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => editWorkout(context, workout),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => deleteWorkout(context, workout.name),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewWorkout,
          backgroundColor: Colors.pinkAccent,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
