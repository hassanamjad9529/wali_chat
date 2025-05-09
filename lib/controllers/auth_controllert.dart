import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wali_project/components/utils/utils.dart';
import 'package:wali_project/screens/dashbaord_screen.dart';
import '../screens/login_screen.dart';
import 'wali_controller.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var isLoading = false.obs;

  Future<void> signUp(String name, String email, String password, String waliEmail) async {
    try {
      isLoading.value = true;
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        await userCredential.user!.updateDisplayName(name);
        await Get.find<WaliController>().initializeUser(waliEmail);
        Get.off(() => DashboardScreen());
      } else {
         Utils.toastMessage(
          
          'User creation failed.',
          
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'This email is already registered.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address.';
          break;
        case 'weak-password':
          errorMessage = 'Password is too weak.';
          break;
        default:
          errorMessage = 'Signup failed: ${e.message}';
      }
       Utils.toastMessage(
        errorMessage,
        
      );
    } catch (e) {
       Utils.toastMessage(
        
        'An unexpected error occurred: $e',
       
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await Get.find<WaliController>().fetchWalis();
      Get.off(() => DashboardScreen());
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address.';
          break;
        default:
          errorMessage = 'Login failed: ${e.message}';
      }
       Utils.toastMessage(
        
        errorMessage,
       
      );
    } catch (e) {
       Utils.toastMessage(

        'An unexpected error occurred: $e',
      
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      Get.find<WaliController>().clearWalis();
      Get.offAll(() => LoginScreen());
    } catch (e) {
       Utils.toastMessage(

        'Logout failed: $e',
       
      );
    }
  }
}