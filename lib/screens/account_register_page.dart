import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class AccountRegisterPage extends StatefulWidget {
  const AccountRegisterPage({super.key});

  @override
  State<AccountRegisterPage> createState() => _AccountRegisterPageState();
}

class _AccountRegisterPageState extends State<AccountRegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  String errorMessage = '';

  Future<void> register() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirm = confirmController.text;

    if (password != confirm) {
      setState(() {
        errorMessage = 'パスワードが一致しません';
      });
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // 登録成功 → ログイン画面に戻す
      if (!mounted) return;
      Navigator.pop(context); // 戻る（ログイン画面へ）
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? '登録に失敗しました';
      });
    }
  }

  // ログインページに遷移する
  void navigateToLogin() {
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('会員登録')),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400), // 最大幅制限
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'メールアドレス'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: 'パスワード'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: confirmController,
                    decoration: const InputDecoration(labelText: 'パスワード（確認）'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 48),
                  errorMessage.isNotEmpty
                      ? Text(
                          errorMessage,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        )
                      : const SizedBox(height: 20),
                  const SizedBox(height: 10),
                  ElevatedButton(onPressed: register, child: const Text('登録')),
                  if (errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: navigateToLogin,
                    child: const Text('ログイン'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
