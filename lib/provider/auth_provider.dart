import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_planner/data/model/user_model.dart';
import 'package:event_planner/data/repository/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AuthenticationProvider extends ChangeNotifier {
  final AuthRepository _authRepository;
  User? _user;
  UserModel? _userModel;
  String? _errorMessage;
  String? _successMessage;
  bool _isLoading = false;
  bool _canResend = true;
  File? _selectedImage;
  String? _imageUrl;
  String? _userEmail;

  AuthenticationProvider(this._authRepository) {
    _authRepository.authStateChanges.listen(_authStateChanged);
  }

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  String? get userEmail => _userEmail;
  bool get canResend => _canResend;
  UserModel? get userModel => _userModel;

  File? get selectedImage => _selectedImage;
  String? get imageUrl => _imageUrl;

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

  //// Fetch user data from Firestore and return as a UserModel
  Future<void> fetchUserData() async {
    try {
      _isLoading = true;
      notifyListeners();

      final _firebaseUser = FirebaseAuth.instance.currentUser;
      if (_firebaseUser == null) return;

      DocumentSnapshot? docSnapshot = await _authRepository.getUserData(_firebaseUser!.uid);

      if (docSnapshot != null && docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        _userModel = UserModel.fromMap(_firebaseUser!.uid, data);
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = "Error fetching user data";
    } finally {
      _isLoading = false;
      notifyListeners();
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
}
