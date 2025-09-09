import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:positos_frontend_app/widgets/common_app_bar.dart';
import 'package:positos_frontend_app/utils/shared_preferences_project_id_storage.dart';
import 'package:positos_frontend_app/models/joined_project.dart';
import 'package:positos_frontend_app/providers/project_providers.dart';
import 'package:positos_frontend_app/services/project_service.dart';
import 'package:positos_frontend_app/models/project.dart';

class ProjectPage extends ConsumerStatefulWidget {
  final String projectId;

  const ProjectPage({super.key, required this.projectId});

  @override
  ConsumerState<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends ConsumerState<ProjectPage> {
  // サービスクラス
  late final ProjectService projectService; // プロジェクト作成サービス

  // プロジェクト
  Project? project;

  // ------------ ライフサイクル ------------

  // 初期化（ライフサイクル）
  @override
  void initState() {
    super.initState();

    // サービスを初期化
    projectService = ref.read(projectServiceProvider);

    // 初期表示ロード
    _loadProjects();
  }

  // ------------ ライフサイクル ------------
  // ------------ 処理 ------------

  // 初期表示ロード
  Future<void> _loadProjects() async {
    // プロジェクトIDをキーにプロジェクトを取得
    final fetchedProject = await projectService.getProject(widget.projectId);

    // 参加したプロジェクトをローカルストレージに保存する
    final joinedProject = JoinedProject(
      projectId: fetchedProject.projectId!,
      projectName: fetchedProject.projectName,
      joinedAt: DateTime.now(),
    );

    await SharedPreferencesProjectIdStorage.add(joinedProject);

    setState(() {
      project = fetchedProject;
    });
  }

  // ------------ 処理 ------------

  @override
  Widget build(BuildContext context) {
    if (project == null) {
      // ロード中
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: buildCommonAppBar(context: context, showBackButton: true),
      body: Center(child: Text("プロジェクト名: ${project!.projectName}")),
    );
  }
}
