import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Positos - タスク共有アプリ',
      locale: Locale('ja'),
      themeMode: ThemeMode.light,

      // router
      initialRoute: '/',
      routes: {
        '/': (context) => const TopPage(),
        '/create_project': (context) => const CreateProjectPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const AccountRegisterPage(),
        '/task_list': (context) => const TaskListPage(),
      },
      onGenerateRoute: (settings) {
        final uri = Uri.parse(settings.name ?? '');

        if (uri.pathSegments.length == 2 && uri.pathSegments[0] == 'project') {
          final projectId = uri.pathSegments[1];
          return MaterialPageRoute(
            builder: (context) => ProjectPage(projectId: projectId),
            settings: settings,
          );
        }

        // それ以外のパス → NotFoundなど
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Text(
                // TODO トップページに戻るボタンを作る。
                '指定したURLのプロジェクトが見つかりませんでした。\nURLが誤っているか、該当のプロジェクトが削除、もしくは非公開になっている可能性があります。',
              ),
            ),
          ),
        );
      },

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
