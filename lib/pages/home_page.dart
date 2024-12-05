import 'package:flutter/material.dart';
import 'package:pap/components/heat_map.dart';
import 'package:pap/data/workout_data.dart';
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
              // AppBar
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

              // Heat Map Section
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

              // Workout List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  itemCount: value.getWorkoutList().length,
                  itemBuilder: (context, index) {
                    final workout = value.getWorkoutList()[index];

                    bool hasSelectedExercise = workout.exercises.any((exercise) => exercise.isSelected);

                    return GestureDetector(
                      onTap: () => goToWorkoutPage(workout.name),
                      child: Card(
                        color: hasSelectedExercise ? Colors.green : Colors.white, // Green if any exercise is selected
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
                          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.purple),
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
