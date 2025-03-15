import 'dart:io';

import 'package:event_planner/data/repository/exception/api_error_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../model/user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  User? get currentUser => _auth.currentUser;

  //Stream to listen for authentication changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  //Sign in with email & password
  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  //Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  //Register new user
  Future<UserCredential> signUp(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  //Send password reset email
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> saveUserData({
    required String userId,
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String mailingAddress,
    required String profileImageUrl,
    required String fcmToken,
  }) async {
    try {
      await _firestore.collection("users").doc(userId).set({
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "phoneNumber": phoneNumber,
        "mailingAddress": mailingAddress,
        "fcmToken": fcmToken,
        "profileImageUrl": profileImageUrl,
        "createdAt": FieldValue.serverTimestamp(), // Store timestamp
      }, SetOptions(merge: true)); // Merge in case of updates
    } catch (e) {
      throw Exception(ApiErrorHandler.getMessage(e));
    }
  }

  Future<DocumentSnapshot?> getUserData(String userId) async {
    try {
      return await _firestore.collection("users").doc(userId).get();
    } catch (e) {
      return null;
    }
  }

  /// Listens to real-time Firestore user document changes
  Stream<UserModel?> listenToUserData(String userId) {
    return _firestore.collection("users").doc(userId).snapshots().map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return UserModel.fromMap(userId, snapshot.data()!);
      }
      return null;
    });
  }

  /// Pick image from Camera or Gallery
  Future<File?> pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      print("Error picking image: $e");
      return null;
    }
  }

  /// Upload Image to Firebase Storage and return the URL
  Future<String?> uploadImageToFirebase(File imageFile) async {
    try {
      String fileName = "profile_${DateTime.now().millisecondsSinceEpoch}.jpg";
      Reference firebaseStorageRef = _storage.ref().child('profile_images/$fileName');

      UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;

      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }
}
