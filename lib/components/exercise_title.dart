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
      color: const Color.fromARGB(255, 178, 118, 189),
      child: ListTile(
        title: Text(
          exerciseName,
        ),
        subtitle: Row(
          children: [
            Chip(
              label: Text(
                "$weight Kg",
              ),
            ),
            Chip(
              label: Text(
                "$reps Repetições",
              ),
            ),
            Chip(
              label: Text(
                "$sets Sets",
              ),
            ),
          ],
        ),
        trailing: Checkbox(
          value: isCompleted,
          onChanged: onCheckBoxChanged != null ? (value) => onCheckBoxChanged!(value) : null,
        ),
      ),
    );
  }
  // Olá
}
