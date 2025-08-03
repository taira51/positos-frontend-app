

class Project {
  /// プロジェクトID
  String? projectId;

  /// プロジェクト名
  String projectName;

  /// プロジェクト順番
  int? projectOrder;

  /// 作成者ユーザーID（Firebase UID）
  String? createUserId;

  /// 作成日時
  DateTime? createDateTime;

  /// 更新ユーザーID（Firebase UID）
  String? updateUserId;

  /// 更新日時
  DateTime? updateDateTime;

  Project({
    this.projectId,
    required this.projectName,
    this.projectOrder,
    this.createUserId,
    this.createDateTime,
    this.updateUserId,
    this.updateDateTime,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      projectId: json['projectId'],
      projectName: json['projectName'],
      projectOrder: json['projectOrder'],
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
      'projectId': projectId,
      'projectName': projectName,
      'projectOrder': projectOrder,
      'createUserId': createUserId,
      'createDateTime': createDateTime?.toIso8601String(),
      'updateUserId': updateUserId,
      'updateDateTime': updateDateTime?.toIso8601String(),
    };
  }
}
