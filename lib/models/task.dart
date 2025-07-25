import 'package:ai_todo_list_frontend_app/enums/task_status.dart';

class Task {
  /// タスクID
  int? taskId;

  /// タスク名
  String taskName;

  /// タスクステータス
  TaskStatus? taskStatus;

  /// タスク順番
  int? taskOrder;

  /// タスクメモ
  String? taskMemo;

  /// タスク期限日時
  DateTime? taskDeadline;

  /// タスク完了者ID（Firebase UID）
  String? taskCompletedUserId;

  /// 作成者ユーザーID（Firebase UID）
  String? createUserId;

  /// 作成日時
  DateTime? createDateTime;

  /// 更新ユーザーID（Firebase UID）
  String? updateUserId;

  /// 更新日時
  DateTime? updateDateTime;

  Task({
    this.taskId,
    required this.taskName,
    this.taskStatus,
    this.taskOrder,
    this.taskMemo,
    this.taskDeadline,
    this.taskCompletedUserId,
    this.createUserId,
    this.createDateTime,
    this.updateUserId,
    this.updateDateTime,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      taskId: json['taskId'],
      taskName: json['taskName'],
      taskStatus: json['taskStatus'] != null
          ? TaskStatusExtension.fromCode(json['taskStatus'])
          : null,
      taskOrder: json['taskOrder'],
      taskMemo: json['taskMemo'],
      taskDeadline: json['taskDeadline'] != null
          ? DateTime.parse(json['taskDeadline'])
          : null,
      taskCompletedUserId: json['taskCompletedUserId'],
      createUserId: json['createUserId'],
      createDateTime: json['createDateTime'] != null
          ? DateTime.parse(json['createDateTime'])
          : null,
      updateUserId: json['updateUserId'],
      updateDateTime: json['updateDateTime'] != null
          ? DateTime.parse(json['updateDateTime'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taskId': taskId,
      'taskName': taskName,
      'taskStatus': taskStatus?.code,
      'taskOrder': taskOrder,
      'taskMemo': taskMemo,
      'taskDeadline': taskDeadline?.toIso8601String(),
      'taskCompletedUserId': taskCompletedUserId,
      'createUserId': createUserId,
      'createDateTime': createDateTime?.toIso8601String(),
      'updateUserId': updateUserId,
      'updateDateTime': updateDateTime?.toIso8601String(),
    };
  }
}
