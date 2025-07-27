import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:positos_frontend_app/services/api_service.dart';
import 'package:positos_frontend_app/services/task_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

final taskServiceProvider = Provider<TaskService>((ref) {
  final api = ref.watch(apiServiceProvider);
  return TaskService(api: api);
});
