import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_app/models/task_group.dart';
import 'package:todo_app/repository/supabase_repository.dart';

class TaskGroupProvider extends ChangeNotifier {
  final _repo = SupabaseRepository();

  TaskGroup? selectedTaskGroup;

  List<TaskGroupWithCounts> _taskGroupsWithCounts = [];
  List<TaskGroupWithCounts> get taskGroupsWithCounts => _taskGroupsWithCounts;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

    Future<void> listTaskGroups() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _taskGroupsWithCounts = await _repo.listTaskGroupsWithCounts();
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createTaskGroup(TaskGroup taskGroup) async {
  final supabase = Supabase.instance.client;
  
  try {
    final data = taskGroup.toMap();
    print('Data being sent to Supabase: $data'); // Debug
    
    await supabase
        .from('task_groups')
        .insert(data);
        
  } catch (e, stackTrace) {
    print('Error creating task group: $e');
    print('Stack trace: $stackTrace');
    throw Exception('Failed to create task group: $e');
  }
}
Future<void> updateTaskGroup(TaskGroup taskGroup) async {
  final supabase = Supabase.instance.client;
  
  try {
    // Converte o valor da cor para BIGINT
    final taskGroupMap = taskGroup.toMap();
    // Garante que o color seja tratado como BIGINT
    taskGroupMap['color'] = taskGroup.color.toInt();

    print('Updating task group with data: $taskGroupMap');
    
    await supabase
        .from('task_groups')
        .update(taskGroupMap)
        .eq('id', taskGroup.id);
        
  } catch (e, stackTrace) {
    print('Error details: $e');
    print('Stack trace: $stackTrace');
    throw Exception('Failed to update task group: $e');
  }
}

Future<void> deleteTaskGroup(String id) async {
    try {
      await _repo.deleteTaskGroup(id);
      _taskGroupsWithCounts.removeWhere(
        (group) => group.taskGroup.id == id
      );
      notifyListeners();
    } catch (e) {
      print('Error deleting task group: $e');
      throw Exception('Failed to delete task group');
    }
  }
}