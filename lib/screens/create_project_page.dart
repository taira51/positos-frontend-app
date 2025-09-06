import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:positos_frontend_app/const/common_const.dart';

import 'package:positos_frontend_app/widgets/common_app_bar.dart';
import 'package:positos_frontend_app/providers/project_providers.dart';
import 'package:positos_frontend_app/services/project_service.dart';
import 'package:positos_frontend_app/models/project.dart';

class CreateProjectPage extends ConsumerStatefulWidget {
  const CreateProjectPage({super.key});

  @override
  ConsumerState<CreateProjectPage> createState() => _CreateProjectPageState();
}

class _CreateProjectPageState extends ConsumerState<CreateProjectPage> {
  // サービスクラス
  late final ProjectService projectService; // プロジェクト作成サービス

  // エラーメッセージ
  String errorMessage = '';

  // 入力フォーム
  final TextEditingController _projectNameInputController =
      TextEditingController(); // プロジェクト名入力フォーム

  // フォーカス
  final _projectNameInputFocusNode = FocusNode();

  // ------------ ライフサイクル ------------

  // 初期化（ライフサイクル）
  @override
  void initState() {
    super.initState();

    // サービスを初期化
    projectService = ref.read(projectServiceProvider);

    // プロジェクト名入力
    _projectNameInputFocusNode.requestFocus();
  }

  // ウィジェット破棄（ライフサイクル）
  @override
  void dispose() {
    _projectNameInputController.dispose();
    _projectNameInputFocusNode.dispose();
    super.dispose();
  }

  // ------------ ライフサイクル ------------
  // ------------ イベント ------------

  // プロジェクト作成ボタン押下イベント
  void onClickCreateProjectButton() {
    createProject();
  }

  // ------------ イベント ------------
  // ------------ 処理 ------------

  Future<void> createProject() async {
    final String projectName = _projectNameInputController.text;

    if (projectName.trim().isEmpty) {
      // プロジェクト名の入力が無い場合、エラーメッセージを表示して終了
      setState(() {
        errorMessage = 'プロジェクト名を入力してください';
      });

      return;
    }

    final project = Project(projectName: projectName);
    final response = await projectService.createProject(project);

    // TODO
    // ダイアログで「新しいプロジェクトが作成されました」という文言とともに、共有するためのURLを表示する。
    // コピーボタン押下により、URLをコピーする ⇒ コピーしたら「コピーしました」を表示する
    // OKボタン押下により、自動でプロジェクト画面に遷移する

    // 画面遷移など
    if (!mounted) return;
    context.go('${CommonConstants.routeProject}/${response.projectId}');
  }

  // ------------ 処理 ------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildCommonAppBar(context: context, showBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Positosでプロジェクトを作成しましょう',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'あなた専用のプロジェクトURLが作成され、メンバーと共有して一緒にタスクを管理できます。',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            const Text('プロジェクト名', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: _projectNameInputController,
              focusNode: _projectNameInputFocusNode,
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  onClickCreateProjectButton();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: const Text('プロジェクトを作成する'),
              ),
            ),
            errorMessage.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        errorMessage,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                  )
                : const SizedBox(height: 20),
            const SizedBox(height: 48),
            const Divider(),
            const SizedBox(height: 24),
            const Text(
              'よくある質問',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const ExpansionTile(
              title: Text('作成したプロジェクトはどのように共有できますか？'),
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text('プロジェクト作成後に表示されるURLをLINEやメールなどで共有できます。'),
                ),
              ],
            ),
            const ExpansionTile(
              title: Text('プロジェクトの削除はできますか？'),
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text('今後のアップデートで対応予定です。現在はメンバーを削除して管理してください。'),
                ),
              ],
            ),
            const ExpansionTile(
              title: Text('メンバーはどこまで操作できますか？'),
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text('現在はすべてのメンバーがタスクの追加・編集・完了が可能です。将来的に権限設定を追加予定です。'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
