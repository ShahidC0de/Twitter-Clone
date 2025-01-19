class ServerException implements Exception {
  final String message;
  final StackTrace stackTrace;
  ServerException({required this.message, required this.stackTrace});
  @override
  String toString() {
    return 'ServerException: $message\n$stackTrace';
  }
}
