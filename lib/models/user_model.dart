import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String name;
  String email;

  UserModel({required this.name, required this.email});

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      name: user.displayName ?? '',
      email: user.email ?? '',
    );
  }
}