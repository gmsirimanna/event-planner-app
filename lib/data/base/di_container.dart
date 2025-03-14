import 'package:dio/dio.dart';
import 'package:event_planner/data/repository/auth_repo.dart';
import 'package:event_planner/data/repository/home_repo.dart';
import 'package:event_planner/data/repository/post_repo.dart';
import 'package:event_planner/provider/auth_provider.dart';
import 'package:event_planner/provider/connectivity_provider.dart';
import 'package:event_planner/provider/home_provider.dart';
import 'package:event_planner/provider/nav_bar_provider.dart';
import 'package:event_planner/provider/post_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repository/dio/dio_client.dart';
import '../repository/dio/logging_interceptor.dart';
import 'package:event_planner/provider/localization_provider.dart';

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
  sl.registerLazySingleton(() => AuthRepository());
  sl.registerLazySingleton(() => HomeRepository(dioClient: sl()));
  sl.registerLazySingleton(() => PostRepository(dioClient: sl()));

  sl.registerFactory(() => AuthenticationProvider(sl(), sl()));
  sl.registerFactory(() => LocalizationProvider(sharedPreferences: sl()));
  sl.registerFactory(() => NavBarProvider());
  sl.registerFactory(() => HomeProvider(homeRepository: sl()));
  sl.registerFactory(() => PostProvider(postRepository: sl()));
  sl.registerFactory(() => ConnectivityProvider());

  //feature - providers
}
