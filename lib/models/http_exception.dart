class HttpException implements Exception {
  //Exception is abstract class
  //Forced to implement all methods of Exception

  final String message;

  HttpException(this.message);

  @override
  String toString() {
    return message;
  }
}
