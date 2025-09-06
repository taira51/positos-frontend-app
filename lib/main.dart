import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'screens/top_page.dart';
import 'screens/create_project_page.dart';
import 'screens/project_page.dart';
import 'screens/login_page.dart';
import 'screens/account_register_page.dart';
import 'screens/task_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // GoRouter 定義
  final _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const TopPage()),
      GoRoute(
        path: '/create_project',
        builder: (context, state) => const CreateProjectPage(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const AccountRegisterPage(),
      ),
      GoRoute(
        path: '/task_list',
        builder: (context, state) => const TaskListPage(),
      ),
      // 動的パラメータ /project/:projectId
      GoRoute(
        path: '/project/:projectId',
        builder: (context, state) =>
            ProjectPage(projectId: state.pathParameters['projectId']!),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            // TODO トップページに戻るボタンを作る。
            '指定したURLのプロジェクトが見つかりませんでした。\n'
            'URLが誤っているか、該当のプロジェクトが非公開になっている可能性があります。',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Positos - タスク共有アプリ',
      locale: Locale('ja'),
      themeMode: ThemeMode.light,
      routerConfig: _router,

      // theme
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: 'NotoSansJP',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.blueGrey),
          bodyMedium: TextStyle(color: Colors.blueGrey),
          titleLarge: TextStyle(color: Colors.blueGrey),
          labelLarge: TextStyle(color: Colors.blueGrey),
        ),

        // ElevatedButton
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontSize: 16),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),

        // OutlinedButton
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.teal,
            textStyle: const TextStyle(fontSize: 16),
            side: const BorderSide(color: Colors.teal),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}
