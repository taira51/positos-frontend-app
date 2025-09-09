import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:positos_frontend_app/models/joined_project.dart';

/// 参加したことのあるプロジェクトをローカルストレージで管理する
/// （直近のプロジェクトがリストの先頭に格納され、古いプロジェクトが末尾となる）
class SharedPreferencesProjectIdStorage {
  static const _key = 'joined_project_ids';

  /// プロジェクトIDをリストに追加する
  static Future<void> add(JoinedProject joinProject) async {
    final prefs = await SharedPreferences.getInstance();
    final joinedProjectList = prefs.getStringList(_key) ?? [];

    // 既に同じIDがある場合は削除
    joinedProjectList.removeWhere((e) {
      final p = JoinedProject.fromJson(jsonDecode(e));
      return p.projectId == joinProject.projectId;
    });

    // 参加したプロジェクトを先頭に追加
    joinedProjectList.insert(0, jsonEncode(joinProject.toJson()));

    // ローカルストレージに保存
    await prefs.setStringList(_key, joinedProjectList);
  }

  /// プロジェクトIDリストをすべて取得する
  static Future<List<JoinedProject>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key) ?? [];

    return jsonList.map((e) => JoinedProject.fromJson(jsonDecode(e))).toList();
  }

  /// プロジェクトIDをリストから削除する
  static Future<void> remove(JoinedProject joinProject) async {
    final prefs = await SharedPreferences.getInstance();
    final joinedProjectList = prefs.getStringList(_key) ?? [];

    // 既に同じIDがある場合は削除
    joinedProjectList.removeWhere((e) {
      final p = JoinedProject.fromJson(jsonDecode(e));
      return p.projectId == joinProject.projectId;
    });

    // ローカルストレージに保存
    await prefs.setStringList(_key, joinedProjectList);
  }

  /// プロジェクトIDリストをリストごと全削除
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
