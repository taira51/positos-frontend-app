import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:positos_frontend_app/models/joined_project.dart';

import 'package:positos_frontend_app/utils/shared_preferences_project_id_storage.dart';
import 'package:positos_frontend_app/const/common_const.dart';
import 'package:positos_frontend_app/widgets/common_app_bar.dart';

class TopPage extends StatefulWidget {
  const TopPage({super.key});

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  // 参加したプロジェクト一覧
  List<JoinedProject> joinedProjectList = [];

  // ------------ ライフサイクル ------------

  // 初期化（ライフサイクル）
  @override
  void initState() {
    super.initState();

    // 初期表示ロード
    _loadProjects();
  }

  // ------------ ライフサイクル ------------
  // ------------ イベント ------------

  // プロジェクト作成ボタン押下イベント
  void onClickCreateProjectButton(BuildContext context) {
    navigateToCreateProject(context);
  }

  // プロジェクト作成ページに遷移する
  void navigateToCreateProject(BuildContext context) {
    context.go(CommonConstants.routeCreateProject);
  }

  // ------------ イベント ------------
  // ------------ 処理 ------------

  // 初期表示ロード
  Future<void> _loadProjects() async {
    // 参加したプロジェクト一覧をローカルストレージから取得
    final projects = await SharedPreferencesProjectIdStorage.getAll();
    setState(() {
      joinedProjectList = projects;
    });

    // ------------ 処理 ------------
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildCommonAppBar(context: context, showBackButton: false),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.task_alt, size: 100, color: Colors.teal),
                const SizedBox(height: 24),
                const Text(
                  'ポジティブに、みんなでタスク管理。',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.group_add),
                    label: const Text('新しいプロジェクトを作成する'),
                    onPressed: () {
                      onClickCreateProjectButton(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.link),
                    label: const Text('招待リンクを持っている'),
                    onPressed: () {
                      // TODO: プロジェクト参加画面へ遷移
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 16),
                      side: const BorderSide(color: Colors.teal),
                      foregroundColor: Colors.teal,
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '参加したプロジェクト',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
                joinedProjectList.isEmpty
                    ? const Padding(
                        padding: EdgeInsetsGeometry.only(top: 12, left: 12),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'まだ参加したプロジェクトはありません。',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      )
                    : // 何も表示しない
                      Expanded(
                        child: ListView.builder(
                          itemCount: joinedProjectList.length,
                          itemBuilder: (context, index) {
                            final joinedPproject = joinedProjectList[index];
                            return ListTile(
                              leading: const Icon(Icons.folder),
                              title: Text(joinedPproject.projectName),
                              onTap: () {
                                // TODO プロジェクト画面に遷移など
                              },
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
