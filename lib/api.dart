import 'package:http/http.dart' as http;

class ApiClient {
  static const String _baseUrl = 'http://192.168.0.114:3000';

  Future<http.Response> get(String route) async {
    final response = await http.get(Uri.parse('$_baseUrl$route'));
    return response;
  }

  Future<http.Response> post(String route, dynamic body) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$route'),
      body: body,
    );
    return response;
  }
}
