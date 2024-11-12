import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/task_group.dart';
import 'package:todo_app/pages/task_list/task_list_page.dart';
import 'package:todo_app/providers/task_group_provider.dart';

class TaskGroupItem extends StatelessWidget {
  final TaskGroupWithCounts taskGroupWithCount;

  const TaskGroupItem({
    Key? key,
    required this.taskGroupWithCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final taskGroup = taskGroupWithCount.taskGroup;
    final isCompleted = taskGroupWithCount.completedTasks > 0;

    return ListTile(
      leading: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(taskGroup.color),
        ),
      ),
      title: Text(
        taskGroup.name,
        style: TextStyle(
          decoration: isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text(
        '${taskGroupWithCount.completedTasks} of ${taskGroupWithCount.totalTasks} tasks',
        style: TextStyle(
          decoration: isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      onTap: () {
        final provider = Provider.of<TaskGroupProvider>(context, listen: false);
        provider.selectedTaskGroup = taskGroup;
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const TaskListPage(),
          ),
        );
      },
    );
  }
}