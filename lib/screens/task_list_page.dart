import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';


import 'dart:convert';

import 'package:ai_todo_list_frontend_app/providers/task_providers.dart';
import 'package:ai_todo_list_frontend_app/models/task.dart';


class TaskListPage extends ConsumerStatefulWidget  {
  const TaskListPage({super.key});

  @override
  ConsumerState<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends ConsumerState<TaskListPage> {

  final inputController = TextEditingController(); // タスク入力フォーム
  final memoController = TextEditingController(); // メモ入力フォーム
  String suggestion = '';
  DateTime? selectedDate;
  List<Task> taskList = [];

  bool showSuggestion = false;

  // 初期表示
  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  // サービスクラス初期化
  void _loadTasks() async {
    final taskService = ref.read(taskServiceProvider);
    final responseTasks = await taskService.fetchTasks();
    
    setState(() {
      taskList = responseTasks;
    });
  }

  void generateSuggestion() {
    setState(() {
      suggestion = inputController.text;
      showSuggestion = true;
    });
  }

  void registerTask() {
    if (suggestion.isNotEmpty && selectedDate != null) {
      setState(() {
        // taskList.add({
        //   'task': suggestion,
        //   'memo': memoController.text,
        //   'date': DateFormat('yyyy/MM/dd').format(selectedDate!),
        // });
        // 入力クリア
        inputController.clear();
        memoController.clear();
        showSuggestion = false;
        selectedDate = null;
      });
    }
  }

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

  // 
  Future<void> requestApiPostTask(String task, String memo, String deadline) async {
    final url = Uri.parse('http://localhost:8000/tasks');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'task': task,
        'memo': memo,
        'deadline': deadline,
      }),
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
        actions: [const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(child: Text('[ChatGPT連携あり]')),
        )],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: inputController,
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
            if (showSuggestion) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('生成されたタスク候補：'),
                    Text('・タスク名: $suggestion'),
                    Text('・期限: ${selectedDate != null ? DateFormat('yyyy/MM/dd').format(selectedDate!) : '未設定'}'),
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
                    TextButton(
                      onPressed: pickDate,
                      child: const Text('期限を選択'),
                    ),
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
            ...taskList.map((task) => ListTile(
              leading: const Checkbox(value: false, onChanged: null),
              title: Text(task.taskName),
              // subtitle: Text('メモ: ${Task['memo'] ?? ''}\n期限: ${Task['date'] ?? ''}'),
              trailing: OutlinedButton(
                onPressed: () {},
                child: const Text('完了'),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
