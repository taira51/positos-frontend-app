import 'api_service.dart';
import 'package:ai_todo_list_frontend_app/models/task.dart';

// タスクサービス
class TaskService {
  final ApiService api;

  TaskService({required this.api});

  // 全件取得
  Future<List<Task>> fetchTasks() async {
    final data = await api.get('/tasks');
    return data.map<Task>((json) => Task.fromJson(json)).toList();
  }

  // 作成
  Future<Task> createTask(Task task) async {
    final data = await api.post('/tasks', task.toJson());
    return Task.fromJson(data);
  }

  // 削除
  Future<void> deleteTask(String id) async {
    await api.delete('/tasks/$id');
  }
}
