class Task {
  final int? taskId;
  final String taskName;
  final int taskStatus;

  Task({
    required this.taskId,
    required this.taskName,
    required this.taskStatus,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      taskId: json['taskId'],
      taskName: json['taskName'],
      taskStatus: json['taskStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'taskId': taskId, 'taskName': taskName, 'taskStatus': taskStatus};
  }
}
