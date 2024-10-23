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
    Provider.of<WorkoutData>(context, listen: false).initializeWorkoutList(); // Fixed typo
  }

  @override
  void dispose() {
    newWorkoutNameController.dispose(); // Dispose controller to avoid memory leaks
    super.dispose();
  }

  void createNewWorkout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Criar novo treino"),
        content: TextField(
          controller: newWorkoutNameController,
          decoration: const InputDecoration(hintText: "Nome do treino"),
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

  void goToWorkoutPage(String workoutName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutPage(
          workoutName: workoutName,
        ),
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
        backgroundColor: const Color.fromARGB(255, 240, 230, 241),
        appBar: AppBar(
          title: const Text('FitJourney'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewWorkout,
          child: const Icon(Icons.add),
        ),
        body: Column(
          children: [
            // Heat Map
            MyHeatMap(
              datasets: value.heatMapDataSet,
              startDateYYYYMMDD: value.getStartDate(),
            ),
            // Workout List
            Expanded(
              child: ListView.builder(
                itemCount: value.getWorkoutList().length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(value.getWorkoutList()[index].name),
                  trailing: IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: () =>
                        goToWorkoutPage(value.getWorkoutList()[index].name),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
