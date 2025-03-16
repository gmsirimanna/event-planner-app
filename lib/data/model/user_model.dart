class UserModel {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String mailingAddress;
  final String profileImageUrl;

  UserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.mailingAddress,
    required this.profileImageUrl,
  });

  /// Convert Firestore data to `UserModel`
  factory UserModel.fromMap(String uid, Map<String, dynamic> data) {
    return UserModel(
      uid: uid,
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      mailingAddress: data['mailingAddress'] ?? '',
      profileImageUrl: data['profileImageUrl'] ?? '',
    );
  }

  /// Convert `UserModel` to `Map` (for saving to Firestore)
  Map<String, dynamic> toMap() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "phoneNumber": phoneNumber,
      "mailingAddress": mailingAddress,
      "profileImageUrl": profileImageUrl,
    };
  }
}
