import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test_mobile_app/app/database/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> fetchAndStoreTasks() async {
  try {
    final response = await http.get(
      Uri.parse('https://task-manager-api3.p.rapidapi.com/'),
      headers: {
        'X-RapidAPI-Key': 'bb34bfdbcbmsh307f76ef2f852c9p16589cjsn4689bc4d6f76',
        'X-RapidAPI-Host': 'task-manager-api3.p.rapidapi.com',
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> tasksData = jsonData['data'];
      final prefs = await SharedPreferences.getInstance();
      final jsonString = json.encode(tasksData);
      await prefs.setString('tasksData', jsonString);
      print('Tasks data stored locally');
    } else {
      throw Exception('Failed to fetch tasks');
    }
  } catch (e) {
    print('Error fetching and storing tasks: $e');
  }
}

Future<void> deleteTasks(String taskId) async {
  try {
    final response = await http.delete(
      Uri.parse('https://task-manager-api3.p.rapidapi.com/$taskId'),
      headers: {
        'X-RapidAPI-Key': 'bb34bfdbcbmsh307f76ef2f852c9p16589cjsn4689bc4d6f76',
        'X-RapidAPI-Host': 'task-manager-api3.p.rapidapi.com',
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );
    if (response.statusCode == 200) {
      print('Task deleted successfully');
    } else {
      throw Exception('Failed to delete task');
    }
  } catch (e) {
    print('Error deleting task: $e');
  }
}

Future<void> updateTask(String id, Map<String, dynamic> data) async {
  final String url = 'https://task-manager-api3.p.rapidapi.com/$id';
  final Map<String, String> headers = {
    'content-type': 'application/json',
    'X-RapidAPI-Key': 'bb34bfdbcbmsh307f76ef2f852c9p16589cjsn4689bc4d6f76',
    'X-RapidAPI-Host': 'task-manager-api3.p.rapidapi.com'
  };

  try {
    final http.Response response = await http.put(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(data),
    );
    final dynamic responseData = jsonDecode(response.body);
    print(responseData);
  } catch (error) {
    print('Error updating task: $error');
  }
}

Future<void> createTask(Map<String, dynamic> data) async {
  const String url = 'https://task-manager-api3.p.rapidapi.com/';
  final Map<String, String> headers = {
    'content-type': 'application/json',
    'X-RapidAPI-Key': 'bb34bfdbcbmsh307f76ef2f852c9p16589cjsn4689bc4d6f76',
    'X-RapidAPI-Host': 'task-manager-api3.p.rapidapi.com'
  };

  try {
    final http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(data),
    );
    final dynamic responseData = jsonDecode(response.body);
    print(responseData);
  } catch (error) {
    print('Error creating task: $error');
  }
}