import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/pages/task_group_create/task_group_create_page.dart';
import 'package:todo_app/pages/task_group_list/widgets/task_group_item.dart';
import 'package:todo_app/providers/task_group_provider.dart';
import 'package:todo_app/providers/theme_provider.dart';

class TaskGroupListPage extends StatelessWidget {
  const TaskGroupListPage({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Groups'),
        actions: [
          IconButton(
            icon: Icon(
              Provider.of<ThemeProvider>(context).isDarkMode 
                ? Icons.light_mode 
                : Icons.dark_mode,
            ),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      body: Consumer<TaskGroupProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: provider.taskGroupsWithCounts.length,
            itemBuilder: (context, index) {
              final taskGroupWithCount = provider.taskGroupsWithCounts[index];
              return Dismissible(
                key: Key(taskGroupWithCount.taskGroup.id),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction) {
                  return showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Delete Task Group'),
                        content: const Text(
                          'Are you sure you want to delete this task group?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                },
                onDismissed: (direction) {
                  provider.deleteTaskGroup(taskGroupWithCount.taskGroup.id);
                },
                child: TaskGroupItem(taskGroupWithCount: taskGroupWithCount),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const TaskGroupCreatePage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}