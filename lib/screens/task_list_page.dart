import 'package:positos_frontend_app/enums/task_status.dart';
import 'package:positos_frontend_app/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:positos_frontend_app/providers/task_providers.dart';
import 'package:positos_frontend_app/services/task_service.dart';
import 'package:positos_frontend_app/models/task.dart';

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
  final taskGenerateInputController =
      TextEditingController(); // 生成タスクプロンプト入力フォーム

  // フォーカス
  final _taskGenerateInputFocusNode = FocusNode();

  // タスク一覧
  // タスク順番（taskOrder）の値の降順でタスクを一覧表示する
  List<Task> taskList = [];

  // 提案タスク一覧
  List<Task> suggestionTaskList = [];

  String suggestion = '';
  DateTime? selectedDate;

  // ------------ ライフサイクル ------------

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

  // ------------ ライフサイクル ------------
  // ------------ イベント ------------

  // 生成ボタン押下
  void onPressedGenerateSuggestionButton() {
    generateSuggestion();
  }

  // 提案タスク削除ボタン押下
  void onClickRemoveSuggestButton(Task removeTask) {
    removeSuggestionTask(removeTask);
  }

  // 日付入力（カレンダー使用）
  void onPickDate() async {
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
  void onPressedRegisterButton(Task task, Task suggestion) async {
    // タスク登録APIリクエスト
    final createResponseTask = await taskService.createTask(task);

    setState(() {
      // 提案タスクリストから削除し、タスク一覧に加える
      removeSuggestionTask(suggestion);
      taskList.insert(0, createResponseTask);
    });
  }

  // チェックボックス切り替え
  void onChangedCheckBox(Task task, TaskStatus taskStatus) {
    updateTaskStatus(task, taskStatus);
  }

  // タスク完了ボタン押下
  onClickCompleteButton(Task task, TaskStatus taskStatus) {
    updateTaskStatus(task, taskStatus);
  }

  // タスク削除ボタン押下
  onClickDeleteTaskButton(Task delete) {
    deleteTask(delete);
  }

  // ------------ イベント ------------
  // ------------ 処理 ------------

  // 初期表示ロード
  void _loadTasks() async {
    final responseTasks = await taskService.fetchTasks();
    setState(() {
      taskList = responseTasks;
    });
  }

  // タスクを生成する
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

  // 提案タスクリストからタスクを削除する
  void removeSuggestionTask(Task removeTask) {
    setState(() {
      suggestionTaskList.remove(removeTask);

      if (suggestionTaskList.isEmpty) {
        // 提案タスクリストが空になったらタスク生成プロンプトの入力フォームをクリアする
        taskGenerateInputController.clear();
      }
    });
  }

  // タスクステータス更新
  Future<void> updateTaskStatus(Task task, TaskStatus updateTaskStatus) async {
    // 値とビューの更新
    setState(() {
      task.taskStatus = updateTaskStatus;
    });

    try {
      // タスク更新APIリクエスト
      await taskService.updateTask(task);
    } catch (e) {
      // エラー処理
      print('ステータス更新失敗: $e');
      // 必要に応じて元に戻す or スナックバー表示など
    }
  }

  // タスク削除
  Future<void> deleteTask(Task task) async {
    try {
      // タスク削除APIリクエスト
      await taskService.deleteTask(task.taskId.toString());

      setState(() {
        // タスク一覧から対象のタスクを削除
        taskList.remove(task);
      });
    } catch (e) {
      // エラー処理
      print('タスク削除失敗: $e');
      // 必要に応じて元に戻す or スナックバー表示など
    }
  }

  // ------------ 処理 ------------
  // ------------ ウィジェット ------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildCommonAppBar(context: context, showBackButton: false),
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
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
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
                              onPressed: () =>
                                  onClickRemoveSuggestButton(suggestion),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: taskController,
                          decoration: const InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'タスク名',
                            hintText: 'タスク名を入力',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: memoController,
                          decoration: const InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'メモ',
                            hintText: 'メモを入力',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: 80, child: Text('期限：')),
                            Text(
                              selectedDate != null
                                  ? DateFormat(
                                      'yyyy/MM/dd',
                                    ).format(selectedDate!)
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
                              createUserId: FirebaseAuth
                                  .instance
                                  .currentUser
                                  ?.uid
                                  .toString(),
                            );
                            onPressedRegisterButton(task, suggestion);
                          },
                          child: const Text('+ この内容で登録'),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
            const SizedBox(height: 24),
            ...taskList.map(
              (task) => Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: ListTile(
                  leading: Checkbox(
                    value: task.taskStatus != TaskStatus.notStarted,
                    onChanged: task.taskStatus == TaskStatus.completed
                        ? null // 完了ステータスなら無効（非活性）
                        : (value) {
                            task.taskStatus == TaskStatus.notStarted
                                ? onChangedCheckBox(task, TaskStatus.inProgress)
                                : onChangedCheckBox(
                                    task,
                                    TaskStatus.notStarted,
                                  );
                          },
                  ),
                  title: Text(task.taskName),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      OutlinedButton(
                        onPressed: task.taskStatus == TaskStatus.notStarted
                            ? null // タスクステータスが「未着手」の場合、非活性にする
                            : () => {
                                task.taskStatus == TaskStatus.inProgress
                                    ? onClickCompleteButton(
                                        task,
                                        TaskStatus.completed,
                                      )
                                    : onClickCompleteButton(
                                        task,
                                        TaskStatus.inProgress,
                                      ),
                              },
                        child: Text(
                          // タスクステータス"1"：未着手 ⇒ 非活性（完了）
                          // タスクステータス"2"：作業中 ⇒ 活性（完了）
                          // タスクステータス"3"：完了 ⇒ 活性（戻す）
                          task.taskStatus != TaskStatus.completed ? '完了' : '戻す',
                        ),
                      ),
                      const SizedBox(width: 8),
                      // 削除アイコン
                      IconButton(
                        icon: const Icon(Icons.delete),
                        tooltip: 'タスクを削除',
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('削除確認'),
                              content: const Text('このタスクを削除しますか？'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('キャンセル'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    onClickDeleteTaskButton(task);
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    '削除',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------ ウィジェット ------------
}
