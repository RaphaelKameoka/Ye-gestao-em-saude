import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiClient {
  late final String _baseUrl;

  ApiClient() {
    initializeBaseUrl();
  }

  Future<void> initializeBaseUrl() async {
    await dotenv.load(fileName: ".env");
    final ip = dotenv.env['IP_ADRESS'];
    _baseUrl = 'http://$ip:3000';
    print('BaseUrl: $_baseUrl');
  }

  Future<http.Response> get(String route) async {
    final response = await http.get(Uri.parse('$_baseUrl$route'));
    return response;
  }

  Future<http.Response> post(String route, dynamic body) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$route'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    return response;
  }
}
