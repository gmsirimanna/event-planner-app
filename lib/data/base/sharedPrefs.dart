import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final SharedPreferences prefs = GetIt.instance();

// void saveDeviceRegistered(bool value){
//   prefs.setBool(lDeviceRegistered, value);
// }
//
// bool getDeviceRegistered() {
//   return prefs.getBool(lDeviceRegistered) ?? false;
// }

clearSharedPrefs(){
  prefs.clear();
}