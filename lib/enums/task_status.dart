/// タスクステータスを管理するコード
enum TaskStatus {
  notStarted, // 1
  inProgress, // 2
  completed, // 3
}

extension TaskStatusExtension on TaskStatus {
  int get code {
    switch (this) {
      case TaskStatus.notStarted:
        return 1;
      case TaskStatus.inProgress:
        return 2;
      case TaskStatus.completed:
        return 3;
    }
  }

  String get label {
    switch (this) {
      case TaskStatus.notStarted:
        return '未着手';
      case TaskStatus.inProgress:
        return '作業中';
      case TaskStatus.completed:
        return '完了';
    }
  }

  static TaskStatus fromCode(int code) {
    switch (code) {
      case 1:
        return TaskStatus.notStarted;
      case 2:
        return TaskStatus.inProgress;
      case 3:
        return TaskStatus.completed;
      default:
        throw ArgumentError('無効なステータスコード: $code');
    }
  }
}
