import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:positos_frontend_app/services/api_service.dart';
import 'package:positos_frontend_app/services/project_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

final projectServiceProvider = Provider<ProjectService>((ref) {
  final api = ref.watch(apiServiceProvider);
  return ProjectService(api: api);
});
