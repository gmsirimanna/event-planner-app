import 'package:flutter/material.dart';

class SplashProvider extends ChangeNotifier {
  int _pageIndex = 0;
  bool _fromSetting = false;
  bool _firstTimeConnectionCheck = true;
  bool _isConnectingToVehicle = false;

  int get pageIndex => _pageIndex;
  bool get fromSetting => _fromSetting;
  bool get firstTimeConnectionCheck => _firstTimeConnectionCheck;
  bool get isConnectingToVehicle => _isConnectingToVehicle;

  void setFirstTimeConnectionCheck(bool isChecked) {
    _firstTimeConnectionCheck = isChecked;
  }

  void setPageIndex(int index) {
    _pageIndex = index;
    notifyListeners();
  }

  void setFromSetting(bool isSetting) {
    _fromSetting = isSetting;
  }

  void setConnectingToVehicle(bool isConnection) {
    _isConnectingToVehicle = isConnection;
    notifyListeners();
  }
}
