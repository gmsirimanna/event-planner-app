import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_planner/data/model/user_model.dart';
import 'package:event_planner/data/repository/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationProvider extends ChangeNotifier {
  final AuthRepository _authRepository;
  final SharedPreferences prefs;
  User? _user;
  UserModel? _userModel;
  String? _errorMessage;
  String? _successMessage;
  bool _isLoading = false;
  bool _canResend = true;
  File? _selectedImage;
  String? _imageUrl;
  String? _userEmail;
  bool _hasChanged = false;

  AuthenticationProvider(this._authRepository, this.prefs) {
    _authRepository.authStateChanges.listen(_authStateChanged);
  }

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  String? get userEmail => _userEmail;
  bool get canResend => _canResend;
  bool get hasChanged => _hasChanged;
  UserModel? get userModel => _userModel;

  File? get selectedImage => _selectedImage;
  String? get imageUrl => _imageUrl;

  //Listen for auth state changes
  void _authStateChanged(User? user) {
    _user = user;
    notifyListeners();
  }

  void onChange({bool val = true}) {
    _hasChanged = val;
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

    await prefs.remove('isLoggedIn');
    await prefs.remove('userUUID'); // Remove UUID on logout
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

  Future<void> createUpdateUserData({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String mailingAddress,
    required String profileImageUrl,
  }) async {
    if (_user == null) return;

    try {
      await _authRepository.saveUserData(
        userId: _user!.uid,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phoneNumber: phoneNumber,
        mailingAddress: mailingAddress,
        profileImageUrl: profileImageUrl,
      );
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    _selectedImage = null;
    notifyListeners();
  }

  Future<bool> checkUserAvailable() async {
    try {
      final _firebaseUser = FirebaseAuth.instance.currentUser;
      if (_firebaseUser == null) return false;

      DocumentSnapshot? docSnapshot = await _authRepository.getUserData(_firebaseUser.uid);

      return docSnapshot != null && docSnapshot.exists;
    } catch (e) {
      return false;
    }
  }

  /// Listen for real-time user updates from Firestore
  void listenToUserData() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _authRepository.listenToUserData(user.uid).listen((updatedUser) {
        _userModel = updatedUser;
        notifyListeners(); // Update UI whenever user data changes
      });
    }
  }

  /// Select Image from Camera or Gallery
  Future<void> selectImage(ImageSource source) async {
    File? image = await _authRepository.pickImage(source);
    if (image != null) {
      _selectedImage = image;
      notifyListeners();
    }
  }

  /// Upload Image and Store URL
  Future<String?> uploadProfileImage() async {
    _isLoading = true;
    notifyListeners();
    if (_selectedImage == null) {
      return null;
    } else {
      _imageUrl = await _authRepository.uploadImageToFirebase(_selectedImage!);
      return _imageUrl;
    }
  }

  Future<bool> saveUserData() async {
    _isLoading = true;
    notifyListeners();
    final isAvailable = await checkUserAvailable();
    if (isAvailable) {
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userUUID', user?.uid ?? ""); // Store UUID
    }
    _isLoading = false;
    notifyListeners();
    return isAvailable;
  }
}
