import 'api_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:positos_frontend_app/models/task.dart';

// タスクサービス
class TaskService {
  // URL
  static const String taskUrl = '/task';
  static const String generateTasksUrl = '/generate';

  final ApiService api;

  // コンストラクタ
  TaskService({required this.api});

  // 全件取得
  Future<List<Task>> fetchTasks() async {
    final data = await api.get(taskUrl);
    return data.map<Task>((json) => Task.fromJson(json)).toList();
  }

  // 作成
  Future<Task> createTask(Task task) async {
    final data = await api.post(taskUrl, task.toJson());
    return Task.fromJson(data);
  }

  // 更新
  Future<Task> updateTask(Task task) async {
    final id = task.taskId;
    final data = await api.put('$taskUrl/$id', task.toJson());
    return Task.fromJson(data);
  }

  // 削除
  Future<void> deleteTask(String id) async {
    await api.delete('$taskUrl/$id');
  }

  // タスク生成（ChatGPT API使用）
  Future<List<Task>> generateTasks(String prompt) async {
    final response = await http.post(
      Uri.parse(ApiService.baseUrl + taskUrl + generateTasksUrl),
      headers: ApiService.headers,
      body: jsonEncode({'prompt': prompt}),
    );
    api.handleError(response);
    return jsonDecode(
      utf8.decode(response.bodyBytes),
    ).map<Task>((json) => Task.fromJson(json)).toList();
  }
}
