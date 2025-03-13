import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repository/dio/dio_client.dart';
import '../repository/dio/logging_interceptor.dart';
import 'package:event_planner/provider/localization_provider.dart';
import 'package:event_planner/provider/splash_provider.dart';

//sl = service locator di = dependency injection
final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => DioClient("", sl(), loggingInterceptor: sl(), sharedPreferences: sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());

  sl.registerFactory(() => SplashProvider());
  sl.registerFactory(() => LocalizationProvider(sharedPreferences: sl()));

  //feature - providers
}
