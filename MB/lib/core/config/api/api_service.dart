import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:pickleball_app/core/constants/app_constants.dart';
import 'package:pickleball_app/core/constants/app_global.dart';
import 'package:pickleball_app/core/errors/error_handler.dart';
import 'package:pickleball_app/core/errors/error_model.dart';

class ApiService {
  final http.Client client;

  ApiService({
    http.Client? client,
  }) : client = client ?? http.Client();

  static String baseUrl = AppConstants.apiBaseUrl;

  Future<String?> _getToken() async {
    return await globalTokenService.getAccessToken();
  }

  Future<Map<String, String>> _getHeaders([String? locale]) async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      if (locale != null) 'Accept-Language': locale,
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<http.Request> _createRequest(
      String method, String endpoint, Map<String, dynamic>? data,
      [String? locale]) async {
    final headers = await _getHeaders(locale);
    final request = http.Request(method, Uri.parse('$baseUrl$endpoint'))
      ..headers.addAll(headers);
    if (data != null) {
      request.body = json.encode(data);
    }
    return request;
  }

  Future<Map<String, dynamic>> _handleResponse(http.Response response) async {
    final decodedBody = json.decode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decodedBody;
    } else {
      final errorMsg = decodedBody['message'] ??
          'Failed to process request. Status code: ${response.statusCode}';
      throw ErrorModel(message: errorMsg, code: response.statusCode);
    }
  }

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data,
      [String? locale]) async {
    try {
      final request = await _createRequest('POST', endpoint, data, 'en');
      final response =
          await client.send(request).then(http.Response.fromStream);
      return await _handleResponse(response);
    } catch (error) {
      throw ErrorHandler.handleApiError(error, 'en');
    }
  }

  Future<Map<String, dynamic>> get(String endpoint, [String? locale]) async {
    try {
      final request = await _createRequest('GET', endpoint, null, 'en');
      final response =
          await client.send(request).then(http.Response.fromStream);
      return await _handleResponse(response);
    } catch (error) {
      throw ErrorHandler.handleApiError(error, 'en');
    }
  }

  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data,
      [String? locale]) async {
    final request = await _createRequest('PUT', endpoint, data, locale);
    final response = await client.send(request).then(http.Response.fromStream);

    if (response.statusCode == 400) {
      if (response.body.isEmpty) {
        throw ErrorModel(
            message: 'Empty response body', code: response.statusCode);
      }
      return jsonDecode(response.body);
    } else if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ErrorHandler.handleHttpResponseError(response);
    }

    if (response.body.isEmpty) {
      throw ErrorModel(
          message: 'Empty response body', code: response.statusCode);
    }
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> delete(String endpoint, [String? locale]) async {
    try {
      final request = await _createRequest('DELETE', endpoint, null, 'en');
      final response =
          await client.send(request).then(http.Response.fromStream);
      return await _handleResponse(response);
    } catch (error) {
      throw ErrorHandler.handleApiError(error, 'en');
    }
  }

  Future<Map<String, dynamic>> patch(String endpoint, Map<String, dynamic> data,
      [String? locale]) async {
    try {
      final request = await _createRequest('PATCH', endpoint, data, locale);
      final response =
          await client.send(request).then(http.Response.fromStream);
      return await _handleResponse(response);
    } catch (error) {
      throw ErrorHandler.handleApiError(error, locale ?? 'en');
    }
  }

  Future<dynamic> postMultipart(String url, Map<String, String> fields, File file) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll(fields);
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    var response = await request.send();
    final responseBody = await response.stream.bytesToString();
    return jsonDecode(responseBody);
  }

}
