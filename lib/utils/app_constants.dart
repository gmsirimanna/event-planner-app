// ignore_for_file: constant_identifier_names

import 'package:event_planner/data/model/language_model.dart';
import 'package:event_planner/utils/images.dart';

class AppConstants {
  // Shared Key
  static const String THEME = 'theme';
  static const String BT_ADDRESSES = 'BT_ADDRESSES';
  static const String COUNTRY_CODE = 'country_code';
  static const String LANGUAGE_CODE = 'language_code';

  static List<LanguageModel> languages = [
    LanguageModel(imageUrl: "", languageName: 'English', countryCode: 'US', languageCode: 'en'),
    LanguageModel(imageUrl: "", languageName: 'සිංහල', countryCode: 'SL', languageCode: 'si'),
  ];
}
