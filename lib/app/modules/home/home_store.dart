import 'dart:convert';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_mobile_app/app/database/database_service.dart';
import 'package:test_mobile_app/app/database/models.dart';
import 'package:test_mobile_app/app/services/api.dart';
part 'home_store.g.dart';

class HomeStore = HomeStoreBase with _$HomeStore;

abstract class HomeStoreBase with Store {
  final DatabaseService _databaseService;

  HomeStoreBase(this._databaseService) {}

  @observable
  ObservableList<Tasks> tasks = ObservableList<Tasks>();

  @action
  void addTask(Tasks task) {
    tasks.add(task);
  }

  @computed
  List<Tasks> get selectedTasks => tasks.where((task) => task.isSelected).toList();

  @action
  Future<void> fetchTasks() async {
    fetchAndStoreTasks();
    await Future.delayed(const Duration(seconds: 3));
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString('tasksData');
      if (jsonString != null) {
        final List<dynamic> jsonData = json.decode(jsonString);
        final List<Tasks> tasksData = jsonData
            .map((data) => Tasks.fromJson(data as Map<String, dynamic>))
            .toList();
        tasks.clear();
        tasks.addAll(tasksData);
      }
    } catch (e) {
      print('Error fetching tasks: $e');
    }
  }

  @action
  Future<void> deleteTask(String taskId) async {
    try {
      await deleteTasks(taskId);
      tasks.removeWhere((task) => task.id == taskId);
    } catch (e) {
      print('Error deleting task: $e');
    }
  }

  @action 
  Future<void> clean() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('tasksData');
      tasks.clear();
    } catch (e) {
      print('Error cleaning tasks: $e');
    }
  }

}
