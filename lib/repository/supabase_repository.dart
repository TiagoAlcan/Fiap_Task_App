import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_app/models/task_group.dart';
import 'package:todo_app/models/task_model.dart';

class SupabaseRepository {
  Future<List<TaskGroup>> listTaskGroups() async {
    final supabase = Supabase.instance.client;
    final response = await supabase.from('task_groups').select();
    return response.map((task) => TaskGroup.fromMap(task)).toList();
  }

  Future<List<TaskGroupWithCounts>> listTaskGroupsWithCounts() async {
    final supabase = Supabase.instance.client;
    final taskGroups = await supabase.from('task_groups').select('''
        id,
        name,
        color,
        tasks (
          id,
          is_completed
        )
      ''');

    final List<TaskGroupWithCounts> taskGroupsWithCounts =
        taskGroups.map((taskGroup) {
      final tasks = taskGroup['tasks'] as List;
      final completedTasks = tasks.where((task) => task['is_completed']).length;
      final totalTasks = tasks.length;
      return TaskGroupWithCounts(
        taskGroup: TaskGroup.fromMap(taskGroup),
        completedTasks: completedTasks,
        totalTasks: totalTasks,
      );
    }).toList();

    return taskGroupsWithCounts;
  }

  Future<List<Task>> listTasksByGroup(String groupId) async {
    final supabase = Supabase.instance.client;
    final response =
        await supabase.from('tasks').select().eq('task_group_id', groupId);
    return response.map((task) => Task.fromMap(task)).toList();
  }

  Future createTask(Task task) async {
    final supabase = Supabase.instance.client;
    await supabase.from('tasks').insert(task.toMap());
  }

  Future deleteTask(String taskId) async {
    final supabase = Supabase.instance.client;
    await supabase.from('tasks').delete().eq('id', taskId);
  }

 Future<void> createTaskGroup(TaskGroup taskGroup) async {
  final supabase = Supabase.instance.client;
  
  try {
    print('Creating task group with data: ${taskGroup.toMap()}'); // Log dos dados
    
    final response = await supabase
        .from('task_groups')
        .insert(taskGroup.toMap())
        .select(); // Adiciona .select() para retornar os dados inseridos
    
    print('Response after creating: $response'); // Log da resposta
    
  } catch (e, stackTrace) {
    print('Error creating task group: $e');
    print('Stack trace: $stackTrace');
    throw Exception('Failed to create task group: $e');
  }
}

Future<void> updateTaskGroup(TaskGroup taskGroup) async {
  final supabase = Supabase.instance.client;
  
  try {
    print('Updating task group with data: ${taskGroup.toMap()}'); // Log dos dados
    
    final response = await supabase
        .from('task_groups')
        .update(taskGroup.toMap())
        .eq('id', taskGroup.id)
        .select(); // Adiciona .select() para retornar os dados atualizados
    
    print('Response after updating: $response'); // Log da resposta
    
  } catch (e, stackTrace) {
    print('Error updating task group: $e');
    print('Stack trace: $stackTrace');
    throw Exception('Failed to update task group: $e');
  }
}

  Future<void> deleteTaskGroup(String id) async {
      final supabase = Supabase.instance.client;
  try {
    await supabase
        .from('task_groups')
        .delete()
        .eq('id', id);
  } catch (e) {
    throw Exception('Failed to delete task group: $e');
  }
}

Future<void> updateTask(Task task) async {
      final supabase = Supabase.instance.client;
  try {
    await supabase
        .from('tasks')
        .update(task.toMap())
        .eq('id', task.id);
  } catch (e) {
    throw Exception('Failed to update task: $e');
  }
  }
}
