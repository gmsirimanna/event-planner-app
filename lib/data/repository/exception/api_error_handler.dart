import 'package:dio/dio.dart';
import 'package:event_planner/data/base/error_response.dart';

class ApiErrorHandler {
  static dynamic getMessage(error) {
    dynamic errorDescription = "";
    if (error is Exception) {
      try {
        if (error is DioException) {
          switch (error.type) {
            case DioExceptionType.connectionTimeout:
              errorDescription = "Request to API server was cancelled";
              break;
            case DioExceptionType.sendTimeout:
              errorDescription = "Send Timeout timeout with API server";
              break;
            case DioExceptionType.receiveTimeout:
              errorDescription = "Receive Timeout timeout with server";
              break;
            case DioExceptionType.badCertificate:
              errorDescription = "Bad Certificate";
              break;
            case DioExceptionType.cancel:
              break;
            case DioExceptionType.connectionError:
              errorDescription =
                  "You are not connected to the internet right now. Please check your connection.";
              break;
            case DioExceptionType.unknown:
              errorDescription = "Invalid Token";
              break;
            case DioExceptionType.badResponse:
              errorDescription = "Unexpected error occured";
              throw UnimplementedError();
          }
        } else {
          errorDescription = "Unexpected error occured";
        }
      } on FormatException catch (e) {
        errorDescription = e.toString();
      }
    } else {
      errorDescription = "is not a subtype of exception";
    }
    return errorDescription;
  }
}
