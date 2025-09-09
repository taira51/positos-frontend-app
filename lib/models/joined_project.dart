class JoinedProject {
  /// プロジェクトID
  final String projectId;

  /// プロジェクト名
  final String projectName;

  /// 参加日次（プロジェクトを開くたびに更新される）
  final DateTime joinedAt;

  JoinedProject({
    required this.projectId,
    required this.projectName,
    required this.joinedAt,
  });

  // JSON化
  Map<String, dynamic> toJson() => {
    'projectId': projectId,
    'projectName': projectName,
    'joinedAt': joinedAt.toIso8601String(),
  };

  // JSONから復元
  factory JoinedProject.fromJson(Map<String, dynamic> json) => JoinedProject(
    projectId: json['projectId'],
    projectName: json['projectName'],
    joinedAt: DateTime.parse(json['joinedAt']),
  );
}
