import 'package:flutter/material.dart';

class ExerciseTitle extends StatelessWidget {
  final String exerciseName;
  final String weight;
  final String reps;
  final String sets;
  final bool isCompleted;
  final void Function(bool?)? onCheckBoxChanged;

  const ExerciseTitle({
    super.key,
    required this.exerciseName,
    required this.weight,
    required this.reps,
    required this.sets,
    required this.isCompleted,
    required this.onCheckBoxChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 0, 0, 0),
      child: ListTile(
        title: Text(
          exerciseName,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Row(
          children: [
            Chip(
              label: Text(
                "$weight Kg",
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.black,
            ),
            const SizedBox(width: 5),
            Chip(
              label: Text(
                "$reps Repetições",
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.black,
            ),
            const SizedBox(width: 5),
            Chip(
              label: Text(
                "$sets Sets",
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.black,
            ),
          ],
        ),
        trailing: Checkbox(
          value: isCompleted,
          onChanged: onCheckBoxChanged != null ? (value) => onCheckBoxChanged!(value) : null,
          activeColor: Colors.white,
          checkColor: Colors.black,
        ),
      ),
    );
  }
}
