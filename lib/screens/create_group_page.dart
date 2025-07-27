import 'package:ai_todo_list_frontend_app/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';

class CreateGroupPage extends StatelessWidget {
  const CreateGroupPage({super.key});

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
              'Positosでグループを作成しましょう',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'あなた専用のグループURLが作成され、メンバーと共有して一緒にタスクを管理できます。',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            const Text('グループ名', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: グループ作成APIの呼び出し・リンク生成処理
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: const Text('グループを作成する'),
              ),
            ),
            const SizedBox(height: 48),
            const Divider(),
            const SizedBox(height: 24),
            const Text(
              'よくある質問',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const ExpansionTile(
              title: Text('作成したグループはどのように共有できますか？'),
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text('グループ作成後に表示されるURLをLINEやメールなどで共有できます。'),
                ),
              ],
            ),
            const ExpansionTile(
              title: Text('グループの削除はできますか？'),
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
