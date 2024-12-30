import 'dart:convert';
import 'dart:developer';
import 'package:chat_location/core/database/secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;

  ApiClient(this.baseUrl);

  // GET 요청
  Future<dynamic> get({required String endpoint, bool setToke = false}) async {
    final headers = await _getHeaders();
    return _requestWithAuth(
        request: () => http.get(
              Uri.parse('$baseUrl$endpoint'),
              headers: headers,
            ),
        setToken: setToke);
  }

  // POST 요청
  Future<dynamic> post(
      {required String endpoint,
      Map<String, dynamic>? data,
      bool setToken = false}) async {
    final headers = await _getHeaders();

    return _requestWithAuth(
        request: () => http.post(
              Uri.parse('$baseUrl$endpoint'),
              headers: headers,
              body: jsonEncode(data),
            ),
        setToken: setToken);
  }

  // 공통 요청 처리
  Future<dynamic> _requestWithAuth(
      {required Future<http.Response> Function() request,
      bool setToken = false}) async {
    try {
      final response = await request();

      // 성공 시 응답 처리
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (setToken) {
          log("header 정보${response.headers.toString()}");
          final token = response.headers['authorization'];
          if (token != null) {
            await SecureStorageHelper.saveAuthToken(token);
          }
        }
        log(response.body.toString());
        return jsonDecode(response.body);
      }

      // 권한 문제 (403) 발생 시 토큰 갱신
      if (response.statusCode == 403) {
        log('Token expired. Refreshing token...');
        await _refreshToken();
        return await request(); // 요청 재시도
      }
      // 인증 문제
      if (response.statusCode == 401) {
        return jsonDecode(response.body);
      }
      // 기타 에러
      throw Exception(
          'Request failed: ${response.statusCode} - ${response.body}');
    } catch (e) {
      log('Error during request: $e');
      rethrow;
    }
  }

  // 헤더 생성
  Future<Map<String, String>> _getHeaders() async {
    final token = await SecureStorageHelper.getAuthToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // 토큰 갱신
  Future<void> _refreshToken() async {
    final refreshToken =
        await SecureStorageHelper.getAuthToken(); // Refresh Token 사용
    if (refreshToken == null) {
      throw Exception('No refresh token available');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/auth/refresh'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    if (response.statusCode == 200) {
      final newAuthToken = response.headers['authorization']; // 헤더에서 토큰 추출
      if (newAuthToken != null) {
        await SecureStorageHelper.saveAuthToken(newAuthToken);
        log('New token saved: $newAuthToken');
      } else {
        throw Exception('Authorization token not found in response');
      }
    } else {
      throw Exception('Failed to refresh token: ${response.statusCode}');
    }
  }
}
