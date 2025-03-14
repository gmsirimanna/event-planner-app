import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:event_planner/main.dart';
import 'package:flutter/material.dart';

class ConnectivityProvider with ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  bool _isConnected = true;
  late StreamSubscription _subscription;
  BuildContext? _dialogContext; // Holds dialog context

  bool get isConnected => _isConnected;

  ConnectivityProvider() {
    _listenToConnectivityChanges();
  }

  /// **Listen for connectivity changes & check real internet instantly**
  void _listenToConnectivityChanges() {
    _subscription = _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) async {
      _updateInternetStatus();
    });

    // Initial check when provider is created
    _updateInternetStatus();
  }

  /// **Check Real Internet Access & Update Instantly**
  Future<void> _updateInternetStatus() async {
    bool hasNetwork = await _hasInternetAccess();

    if (_isConnected != hasNetwork) {
      _isConnected = hasNetwork;
      notifyListeners();

      // Handle alert visibility
      if (!_isConnected) {
        _showNoInternetDialog();
      } else {
        _dismissNoInternetDialog();
      }
    }
  }

  /// **Perform an actual internet access check (Google, example.com, etc.)**
  Future<bool> _hasInternetAccess() async {
    try {
      final result = await InternetAddress.lookup('www.google.lk'); // Example site
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  void _showNoInternetDialog() {
    if (_dialogContext != null) return; // Prevent multiple alerts

    // Ensure navigatorKey has a valid context
    if (MyApp.navigatorKey.currentContext == null) return;

    Future.delayed(Duration.zero, () {
      showDialog(
        context: MyApp.navigatorKey.currentContext!,
        barrierDismissible: false, // Cannot dismiss
        builder: (context) {
          _dialogContext = context;
          return AlertDialog(
            title: const Text("No Internet"),
            content: const Text("You are offline. Please check your connection."),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    });
  }

  /// **Dismiss alert when reconnected**
  void _dismissNoInternetDialog() {
    if (_dialogContext != null) {
      Navigator.of(_dialogContext!).pop();
      _dialogContext = null;
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
