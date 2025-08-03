import 'package:flutter/material.dart';

import 'package:positos_frontend_app/widgets/common_app_bar.dart';

class ProjectPage extends StatelessWidget {
  // プロジェクトID
  final String projectId;

  // コンストラクタ
  const ProjectPage({super.key, required this.projectId});

  // TODO
  // 初期表示時にprojectIdをもとにデータを取得する

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCommonAppBar(context: context, showBackButton: true),
      body: Center(child: Text("プロジェクトID: $projectId")),
    );
  }
}
