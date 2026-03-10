import 'package:dio/dio.dart';
import '../config/environment_config.dart';

class KeysService {
  final Dio _dio;

  KeysService(String token) : _dio = Dio(BaseOptions(
    baseUrl: EnvironmentConfig.baseUrl,
    headers: {'Authorization': 'Bearer $token'},
  ));

  Future<void> uploadKeys(Map<String, dynamic> bundle) async {
    try {
      await _dio.post('/keys/upload', data: bundle);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getPreKeyBundle(String userId) async {
    try {
      final response = await _dio.get('/keys/$userId');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
