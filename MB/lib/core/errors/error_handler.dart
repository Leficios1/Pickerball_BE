import 'package:http/http.dart' as http;

import 'error_constants.dart';
import 'error_model.dart';

class ErrorHandler {
  static ErrorModel handleError(Exception e, [String? locale]) {
    if (e is NetworkException) {
      return ErrorModel(
          message: ErrorConstants.networkError(locale!), code: 500);
    } else {
      return ErrorModel(
          message: ErrorConstants.unknownError(locale!), code: 1000);
    }
  }

  static ErrorModel handleApiError(dynamic error, [String? locale]) {
    if (error is http.ClientException) {
      return ErrorModel(
          message: ErrorConstants.networkError(locale!), code: 500);
    } else if (error is ErrorModel) {
      return error;
    } else {
      return ErrorModel(
          message: ErrorConstants.unknownError(locale!), code: 1000);
    }
  }

  static Exception handleHttpResponseError(http.Response response) {
    final errorMsg = response.body.isNotEmpty
        ? response.body
        : 'Failed to process request. Status code: ${response.statusCode}';
    return ErrorModel(message: errorMsg, code: response.statusCode);
  }
}

class NetworkException implements Exception {}
