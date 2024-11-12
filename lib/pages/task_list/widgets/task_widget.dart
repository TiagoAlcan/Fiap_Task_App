import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/providers/task_provider.dart';

class TaskWidget extends StatelessWidget {
  final Task task;
  final Color color;

  const TaskWidget({
    Key? key,
    required this.task,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: InkWell(
        onTap: () {
          final taskProvider = context.read<TaskProvider>();
          final updatedTask = task.copyWith(
            isCompleted: !task.isCompleted,
          );
          taskProvider.updateTask(updatedTask);
        },
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: color,
              width: 2,
            ),
            color: task.isCompleted ? color : Colors.transparent,
          ),
          child: task.isCompleted
              ? const Icon(
                  Icons.check,
                  size: 16,
                  color: Colors.white,
                )
              : null,
        ),
      ),
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.isCompleted 
              ? TextDecoration.lineThrough 
              : TextDecoration.none,
        ),
      ),
      subtitle: Text(
        task.subtitle,
        style: TextStyle(
          decoration: task.isCompleted 
              ? TextDecoration.lineThrough 
              : TextDecoration.none,
        ),
      ),
      trailing: Text(
        // Formatar a data aqui
        task.date.toString(),
        style: TextStyle(
          decoration: task.isCompleted 
              ? TextDecoration.lineThrough 
              : TextDecoration.none,
        ),
      ),
    );
  }
}