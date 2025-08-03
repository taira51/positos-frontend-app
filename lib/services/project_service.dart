import 'api_service.dart';

import 'package:positos_frontend_app/models/project.dart';

// タスクサービス
class ProjectService {
  // URL
  static const String projectUrl = '/project';

  final ApiService api;

  // コンストラクタ
  ProjectService({required this.api});

  // プロジェクト作成
  Future<Project> createProject(Project project) async {
    final data = await api.post(projectUrl, project.toJson());
    return Project.fromJson(data);
  }
}
