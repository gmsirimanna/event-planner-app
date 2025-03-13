import 'package:event_planner/data/repository/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;
  User? _user;
  String? _errorMessage;
  bool _isLoading = false;

  AuthProvider(this._authRepository) {
    _authRepository.authStateChanges.listen(_authStateChanged);
  }

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

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
      notifyListeners();
      await _authRepository.resetPassword(email);
      _errorMessage = null;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
