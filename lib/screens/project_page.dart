import 'package:flutter/material.dart';
import 'package:positos_frontend_app/widgets/common_app_bar.dart';

class ProjectPage extends StatefulWidget {
  final String projectId;

  const ProjectPage({super.key, required this.projectId});

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  // ------------ ライフサイクル ------------

  // 初期化（ライフサイクル）
  @override
  void initState() {
    super.initState();
  }

  // ------------ ライフサイクル ------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCommonAppBar(context: context, showBackButton: true),
      body: Center(child: Text("プロジェクトID: ${widget.projectId}")),
    );
  }
}
