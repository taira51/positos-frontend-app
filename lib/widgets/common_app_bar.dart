import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 共通appBar
/// showBackButton 戻るボタン表示制御（trueで表示する）
PreferredSizeWidget buildCommonAppBar({
  required BuildContext context,
  bool showBackButton = false,
}) {
  return AppBar(
    automaticallyImplyLeading: showBackButton,
    title: GestureDetector(
      onTap: () {
        context.go('/');
      },
      child: const Text(
        'Positos',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: Colors.teal,
        ),
      ),
    ),
    centerTitle: true,
    backgroundColor: Colors.white,
    elevation: 0,
    actions: [
      TextButton(
        onPressed: () => context.go('/login'),
        child: const Text('ログイン'),
      ),
      TextButton(
        onPressed: () => context.go('/signup'),
        child: const Text('会員登録'),
      ),
      IconButton(
        icon: const Icon(Icons.settings),
        onPressed: () => context.go('/settings'),
      ),
    ],
  );
}
