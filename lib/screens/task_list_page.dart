import 'package:ai_todo_list_frontend_app/enums/task_status.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  final taskGenerateInputController = TextEditingController(); // タスク入力フォーム

  // フォーカス
  final _taskGenerateInputFocusNode = FocusNode();

  // タスク一覧
  // タスク順番（taskOrder）の値の降順でタスクを一覧表示する
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
    taskGenerateInputController.dispose();
    _taskGenerateInputFocusNode.dispose();
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
    final text = taskGenerateInputController.text.trim();

    if (text.isEmpty) {
      // タスク入力フォームが空の場合はSnackBarを表示して入力を促す
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('入力欄が空です。何か入力してください。')));

      // フォーカスはタスク入力フォームに戻す
      _taskGenerateInputFocusNode.requestFocus();
    } else {
      // 入力がある場合はタスクを生成し、提案タスク一覧に加える
      final responseSuggestionTaskList = await taskService.generateTasks(text);

      setState(() {
        for (final suggestion in responseSuggestionTaskList) {
          if (!suggestionTaskList.any(
            (existing) => existing.taskName == suggestion.taskName,
          )) {
            // タスク名が重複していないものだけ追加する
            suggestionTaskList.add(suggestion);
          }
        }
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
  void registerTask(Task task, Task removeSuggestionTask) async {
    
    // タスク登録APIリクエスト
    final createResponseTask = await taskService.createTask(task);

    setState(() {
      suggestionTaskList.remove(removeSuggestionTask);
      taskList.insert(0, createResponseTask);
    });
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
              controller: taskGenerateInputController,
              focusNode: _taskGenerateInputFocusNode,
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
              ...suggestionTaskList.map((suggestion) {
                final taskController = TextEditingController(); // タスク入力フォーム
                final memoController = TextEditingController(); // メモ入力フォーム

                taskController.text = suggestion.taskName;
                DateTime? selectedDate;
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(border: Border.all()),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('生成されたタスク候補'),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.close),
                            tooltip: 'この候補を削除',
                            onPressed: () {
                              setState(() {
                                suggestionTaskList.remove(suggestion);
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: 80, child: Text('タスク名：')),
                          Expanded(
                            child: TextField(
                              controller: taskController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'タスク名を入力',
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: 80, child: Text('メモ：')),
                          Expanded(
                            child: TextField(
                              controller: memoController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'メモを入力',
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: 80, child: Text('期限：')),
                          Text(
                            selectedDate != null
                                ? DateFormat('yyyy/MM/dd').format(selectedDate!)
                                : '未設定',
                          ),
                          TextButton(
                            onPressed: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now().subtract(
                                  const Duration(days: 365),
                                ),
                                lastDate: DateTime.now().add(
                                  const Duration(days: 365),
                                ),
                              );
                              if (date != null) {
                                setState(() {
                                  selectedDate = date;
                                });
                              }
                            },
                            child: const Text('期限を選択'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          final task = Task(
                            taskName: taskController.text,
                            taskStatus: TaskStatus.notStarted,
                            taskOrder: taskList.length + 1,
                            taskMemo: memoController.text,
                            taskDeadline: selectedDate,
                            createUserId: FirebaseAuth.instance.currentUser?.uid.toString()
                          );
                          registerTask(task, suggestion);
                          },
                        child: const Text('+ この内容で登録'),
                      ),
                    ],
                  ),
                );
              }),
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
