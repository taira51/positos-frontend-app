/// アプリ内で共通して使う定数をまとめる
class CommonConstants {
  // ---- Routes ----

  /// トップページ
  static const String routeTop = '/';

  /// ログイン
  static const String routeLogin = '/login';

  /// 会員登録
  static const String routeRegister = '/register';

  /// 設定
  static const String routeSettings = '/settings';

  /// プロジェクト作成
  static const String routeCreateProject = '/create_project';

  /// プロジェクト
  static const String routeProject = '/project';

  /// タスク一覧
  static const String routeTaskList = '/task_list';

  // ---- PathParameters ----
  /// プロジェクトID
  static const String pathParameterProjectId = 'projectId';
}
