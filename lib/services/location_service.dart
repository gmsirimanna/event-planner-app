// import 'package:dio/dio.dart';
// import '../data/base/api_response.dart';
// import '../data/repository/dio/dio_client.dart';
// import '../data/repository/exception/api_error_handler.dart';
// import '../utils/base.dart';

// class LocationService {
//   final DioClient dioClient;
//   LocationService({required this.dioClient});

//   Future<ApiResponse> showAllChargePointDataByUser({required CancelToken cancelToken}) async {
//     try {
//       Response? response = await dioClient.post(
//         Base.chargerLocationsList,
//         data: {"userID": 1192, "token": "8EE41D5E7029A547BA818E9A1BF0BD5197802A1D"},
//         options: Options(
//           headers: {'Content-Type': 'application/x-www-form-urlencoded'},
//         ),
//         cancelToken: cancelToken
//       );
//       return ApiResponse.withSuccess(response);
//     } catch (e) {
//       return ApiResponse.withError(ApiErrorHandler.getMessage(e));
//     }
//   }
// }
