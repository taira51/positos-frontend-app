import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dart:convert';

import 'package:ai_todo_list_frontend_app/providers/task_providers.dart';
import 'package:ai_todo_list_frontend_app/services/task_service.dart';
import 'package:ai_todo_list_frontend_app/models/task.dart';

// タスク一覧ページ
class TaskListPage extends ConsumerStatefulWidget {
  const TaskListPage({super.key});

  @override
  ConsumerState<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends ConsumerState<TaskListPage> {
  // サービスクラス
  late final TaskService taskService; // タスクサービス

  // 入力フォーム
  final taskInputController = TextEditingController(); // タスク入力フォーム
  final memoController = TextEditingController(); // メモ入力フォーム

  // フォーカス
  final _taskInputFocusNode = FocusNode();

  // タスク一覧
  List<Task> taskList = [];

  // 提案タスク一覧
  List<Task> suggestionTaskList = [];

  String suggestion = '';
  DateTime? selectedDate;

  // 初期化（ライフサイクル）
  @override
  void initState() {
    super.initState();

    // サービスを初期化
    taskService = ref.read(taskServiceProvider);

    // 初期表示ロード
    _loadTasks();
  }

  // ウィジェット破棄（ライフサイクル）
  @override
  void dispose() {
    taskInputController.dispose();
    memoController.dispose();
    _taskInputFocusNode.dispose();
    super.dispose();
  }

  // 初期表示ロード
  void _loadTasks() async {
    final responseTasks = await taskService.fetchTasks();
    setState(() {
      taskList = responseTasks;
    });
  }

  // 生成ボタン押下
  void generateSuggestion() async {
    final text = taskInputController.text.trim();

    if (text.isEmpty) {
      // タスク入力フォームが空の場合はSnackBarを表示して入力を促す
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('入力欄が空です。何か入力してください。')));

      // フォーカスはタスク入力フォームに戻す
      _taskInputFocusNode.requestFocus();
    } else {
      // 入力がある場合はタスクを生成し、提案タスク一覧に加える
      final suggestionTaskList = await taskService.generateTasks(text);

      setState(() {
        taskList = suggestionTaskList + taskList;
      });
    }
  }

  // 日付入力（カレンダー使用）
  void pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // タスク登録ボタン押下
  void registerTask() {

    // taskService.createTask();

    if (suggestion.isNotEmpty && selectedDate != null) {
      setState(() {
        // taskList.add({
        //   'task': suggestion,
        //   'memo': memoController.text,
        //   'date': DateFormat('yyyy/MM/dd').format(selectedDate!),
        // });
        // 入力クリア
        taskInputController.clear();
        memoController.clear();
        selectedDate = null;
      });
    }
  }

  //
  Future<void> requestApiPostTask(
    String task,
    String memo,
    String deadline,
  ) async {
    final url = Uri.parse('http://localhost:8000/tasks');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'task': task, 'memo': memo, 'deadline': deadline}),
    );

    if (response.statusCode == 200) {
      print('登録成功: ${response.body}');
    } else {
      print('登録失敗: ${response.statusCode} ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TODOアプリ'),
        actions: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(child: Text('[ChatGPT連携あり]')),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: taskInputController,
              focusNode: _taskInputFocusNode,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '来週プレゼンの準備をしなきゃ',
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: generateSuggestion,
              child: const Text('+ 生成'),
            ),
            if (suggestionTaskList.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(border: Border.all()),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('生成されたタスク候補：'),
                    Text('・タスク名: $suggestion'),
                    Text(
                      '・期限: ${selectedDate != null ? DateFormat('yyyy/MM/dd').format(selectedDate!) : '未設定'}',
                    ),
                    Text('・メモ: ${memoController.text}'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: memoController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'メモを入力',
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(onPressed: pickDate, child: const Text('期限を選択')),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: registerTask,
                      child: const Text('この内容で登録'),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            ...taskList.map(
              (task) => ListTile(
                leading: const Checkbox(value: false, onChanged: null),
                title: Text(task.taskName),
                // subtitle: Text('メモ: ${Task['memo'] ?? ''}\n期限: ${Task['date'] ?? ''}'),
                trailing: OutlinedButton(
                  onPressed: () {},
                  child: const Text('完了'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
