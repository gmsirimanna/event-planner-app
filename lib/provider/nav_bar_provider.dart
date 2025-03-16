import 'package:flutter/foundation.dart';

class NavBarProvider with ChangeNotifier {
  int _currentNavIndex = 0;

  int get currentNavIndex => _currentNavIndex;

  Future<void> setNavBarIndex(val) async {
    _currentNavIndex = val;
    notifyListeners();
  }
}
