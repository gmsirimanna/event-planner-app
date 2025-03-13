import 'package:event_planner/data/repository/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenticationProvider extends ChangeNotifier {
  final AuthRepository _authRepository;
  User? _user;
  String? _errorMessage;
  String? _successMessage;
  bool _isLoading = false;
  bool _canResend = true;

  AuthenticationProvider(this._authRepository) {
    _authRepository.authStateChanges.listen(_authStateChanged);
  }

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  bool get canResend => _canResend;

  //Listen for auth state changes
  void _authStateChanged(User? user) {
    _user = user;
    notifyListeners();
  }

  // Sign in
  Future<void> signIn(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _authRepository.signIn(email, password);
      _errorMessage = null;
    } on FirebaseAuthException catch (e) {
      // if (e.message?.contains("incorrect") ?? false) {
      //   _errorMessage = "Username pass incorrect";
      // } else {
      //   _errorMessage = e.message;
      // }
      _errorMessage = e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _authRepository.signOut();
  }

  // Register
  Future<void> signUp(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _authRepository.signUp(email, password);
      _errorMessage = null;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
      notifyListeners();

      await _authRepository.resetPassword(email);

      _successMessage = "Password reset link sent successfully! Please check your email.";
      _canResend = false;
      notifyListeners();

      // Enable resend button after 30 seconds
      Future.delayed(const Duration(seconds: 30), () {
        _canResend = true;
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
      _successMessage = null;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }
}
