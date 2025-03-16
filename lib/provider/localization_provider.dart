import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:event_planner/utils/app_constants.dart';

class LocalizationProvider extends ChangeNotifier {
  final SharedPreferences sharedPreferences;
  int _index = 0;
  Locale _locale = const Locale('en', 'US');
  bool _fromSetting = false;

  bool get fromSetting => _fromSetting;
  Locale get locale => _locale;
  int get index => _index;

  LocalizationProvider({required this.sharedPreferences}) {
    _loadCurrentLanguage();
  }

  void setLanguageIndex(int index) {
    if (index == 0) {
      _locale = const Locale('en', 'US');
      _index = 0;
    } else if (index == 1) {
      _locale = const Locale('si', 'LK');
      _index = 1;
    }
    _saveLanguage(_locale);
    notifyListeners();
  }

  void setFromSetting(bool isSetting) {
    _fromSetting = isSetting;
  }

  _loadCurrentLanguage() async {
    _locale = Locale(sharedPreferences.getString(AppConstants.LANGUAGE_CODE) ?? 'en',
        sharedPreferences.getString(AppConstants.COUNTRY_CODE) ?? 'US');
    _locale.countryCode == "US" ? _index = 0 : _index = 1;
    notifyListeners();
  }

  _saveLanguage(Locale locale) async {
    sharedPreferences.setString(AppConstants.LANGUAGE_CODE, locale.languageCode);
    sharedPreferences.setString(AppConstants.COUNTRY_CODE, locale.countryCode!);
  }
}
