class ErrorModel implements Exception {
  final String message;
  final int code;

  ErrorModel({required this.message, required this.code});

  @override
  String toString() {
    return '$message (code: $code)';
  }
}
