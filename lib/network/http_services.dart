import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:peopleapp_flutter/core/exceptions/exceptions.dart';
import 'package:peopleapp_flutter/core/exceptions/exceptions_handling.dart';

class HttpService {
  final String baseUrl;

  HttpService(this.baseUrl);

  Future<bool> isConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      throw NetworkException();
    } catch (e) {
      throw NetworkException();
    }
  }

  Future<http.Response> getRequest({required String endpoint}) async {
    if (!await isConnected()) {
      throw NetworkException();
    }

    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final response = await http.get(url);
      _handleResponse(response);
      return response;
    } catch (error) {
      throw ExceptionHandler.handle(error);
    }
  }

  Future<http.Response> postRequest(
      {required String endpoint, required Map<String, dynamic> body}) async {
    if (!await isConnected()) {
      throw NetworkException();
    }

    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      _handleResponse(response);
      return response;
    } catch (error) {
      throw ExceptionHandler.handle(error);
    }
  }

  Future<http.Response> getRequestWithToken(
      {required String endpoint, required String token}) async {
    if (!await isConnected()) {
      throw NetworkException();
    }

    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );
      _handleResponse(response);
      return response;
    } catch (error) {
      throw ExceptionHandler.handle(error);
    }
  }

  Future<http.Response> postRequestWithToken(
      {required String endpoint,
      required Map<String, dynamic> body,
      required String token}) async {
    if (!await isConnected()) {
      throw NetworkException();
    }

    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );
      _handleResponse(response);
      return response;
    } catch (error) {
      throw ExceptionHandler.handle(error);
    }
  }

  Future<http.Response> deleteRequestWithToken(
      {required String endpoint, required String token}) async {
    if (!await isConnected()) {
      throw NetworkException();
    }

    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );
      _handleResponse(response);
      return response;
    } catch (error) {
      throw ExceptionHandler.handle(error);
    }
  }

  Future<http.Response> patchRequestWithToken(
      String endpoint, Map<String, dynamic> body, String token) async {
    if (!await isConnected()) {
      throw NetworkException();
    }

    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );
      _handleResponse(response);
      return response;
    } catch (error) {
      throw ExceptionHandler.handle(error);
    }
  }

  void _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      print('Request successful: ${response.statusCode}');
    } else {
      throw ApiException(
        message: 'HTTP request failed with status: ${response.statusCode}',
        statusCode: response.statusCode,
        devDetails: response.body,
      );
    }
  }
}
