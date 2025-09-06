import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:positos_frontend_app/const/common_const.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String errorMessage = '';

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // ログイン成功でタスク一覧画面に遷移する
      if (!mounted) return;
      context.go(CommonConstants.routeTaskList);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? 'ログインに失敗しました。メールアドレスまたはパスワードをご確認ください。';
      });
    }
  }

  // 会員登録ページに遷移する
  void navigateToRegister() {
    context.go(CommonConstants.routeRegister);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ログイン')),
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
                  ElevatedButton(onPressed: login, child: const Text('ログイン')),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: navigateToRegister,
                    child: const Text('会員登録'),
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
