import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:wali_project/controllers/wali_controller.dart';
import 'package:wali_project/screens/dashbaord_screen.dart';
import '../screens/login_screen.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var isLoading = false.obs;

  Future<void> signUp(String name, String email, String password) async {
    try {
      isLoading.value = true;
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user!.updateDisplayName(name);
      // Initialize empty wali list for new user
      await Get.find<WaliController>().fetchWalis();
      Get.off(() => DashboardScreen());
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      // Fetch walis for the new user
      await Get.find<WaliController>().fetchWalis();
      Get.off(() => DashboardScreen());
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      Get.offAll(() => LoginScreen());
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
