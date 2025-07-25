import 'dart:convert';
import 'package:http/http.dart' as http;

// APIサービス共通共通クラス
class ApiService {
  // TODO プロパティで保持
  static const String baseUrl = 'http://localhost:8000';
  static const headers = {'Content-Type': 'application/json'};

  // 取得
  Future<List<dynamic>> get(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl$endpoint'));
    handleError(response);
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  // 作成
  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(body),
    );
    handleError(response);
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  // 更新
  Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(body),
    );
    handleError(response);
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  // 削除
  Future<void> delete(String endpoint) async {
    final response = await http.delete(Uri.parse('$baseUrl$endpoint'));
    handleError(response);
  }

  // 例外ハンドリング
  void handleError(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('API error: ${response.statusCode} ${response.body}');
    }
  }
}
