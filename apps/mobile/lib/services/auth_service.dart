import '../config/environment_config.dart';
import 'package:dio/dio.dart'; // Assuming Dio is used and needs to be imported.

class AuthService {
  final Dio _dio = Dio(BaseOptions(baseUrl: EnvironmentConfig.baseUrl)); 

  Future<Map<String, dynamic>> register(String email, String username, String password, String inviteCode) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'email': email,
        'username': username,
        'password': password,
        'invitationCode': inviteCode,
      });
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> login(String identifier, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'identifier': identifier,
        'password': password,
      });
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
