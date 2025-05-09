import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wali_project/components/reuseable_widgets/custom_textfield.dart';
import 'package:wali_project/components/utils/utils.dart';
import 'package:wali_project/controllers/auth_controllert.dart';
import 'login_screen.dart';

class SignupScreen extends StatelessWidget {
  final AuthController authController = Get.find();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController waliEmailController = TextEditingController();

  // Validate inputs
  bool _validateInputs() {
    if (nameController.text.trim().isEmpty) {
      Utils.toastMessage(
        'Full Name is required',
      );
      return false;
    }
    if (emailController.text.trim().isEmpty) {
      Utils.toastMessage(
        'Email is required',
      );
      return false;
    }
    if (!GetUtils.isEmail(emailController.text.trim())) {
      Utils.toastMessage(
        'Please enter a valid email',
      );
      return false;
    }
    if (passwordController.text.trim().isEmpty) {
      Utils.toastMessage(
        'Password is required',
      );
      return false;
    }
    if (passwordController.text.trim().length < 6) {
      Utils.toastMessage(
        'Password must be at least 6 characters',
      );
      return false;
    }
    if (waliEmailController.text.trim().isNotEmpty &&
        !GetUtils.isEmail(waliEmailController.text.trim())) {
      Utils.toastMessage(
        'Please enter a valid wali email or leave it empty',
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 400),
          child: Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  SizedBox(height: 24),
                  CustomTextField(
                    hintText: 'Full Name',
                    controller: nameController,
                  ),
                  // TextField(
                  //   controller: nameController,
                  //   decoration: InputDecoration(
                  //     labelText: 'Full Name',
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(8),
                  //     ),
                  //     prefixIcon: Icon(Icons.person),
                  //     errorBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(8),
                  //       borderSide: BorderSide(color: Colors.red),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 16),
                  CustomTextField(
                    hintText: 'Email',
                    controller: emailController,
                  ),
                  // TextField(
                  //   controller: emailController,
                  //   decoration: InputDecoration(
                  //     labelText: 'Email',
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(8),
                  //     ),
                  //     prefixIcon: Icon(Icons.email),
                  //     errorBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(8),
                  //       borderSide: BorderSide(color: Colors.red),
                  //     ),
                  //   ),
                  //   keyboardType: TextInputType.emailAddress,
                  // ),
                  SizedBox(height: 16),
                  CustomTextField(
                    hintText: 'Password',
                    controller: passwordController,
                    obscureText: true,
                  ),
                  // TextField(
                  //   controller: passwordController,
                  //   decoration: InputDecoration(
                  //     labelText: 'Password',
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(8),
                  //     ),
                  //     prefixIcon: Icon(Icons.lock),
                  //     errorBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(8),
                  //       borderSide: BorderSide(color: Colors.red),
                  //     ),
                  //   ),
                  //   obscureText: true,
                  // ),
                  SizedBox(height: 16),
                  CustomTextField(
                    hintText: 'Wali\'s Email (Optional)',
                    controller: waliEmailController,
                  ),
                  // TextField(
                  //   controller: waliEmailController,
                  //   decoration: InputDecoration(
                  //     labelText: 'Wali\'s Email (Optional)',
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(8),
                  //     ),
                  //     prefixIcon: Icon(Icons.email),
                  //     errorBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(8),
                  //       borderSide: BorderSide(color: Colors.red),
                  //     ),
                  //   ),
                  //   keyboardType: TextInputType.emailAddress,
                  // ),
                  SizedBox(height: 24),
                  Obx(() => authController.isLoading.value
                      ? Center(child: CircularProgressIndicator())
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_validateInputs()) {
                                authController.signUp(
                                  nameController.text.trim(),
                                  emailController.text.trim(),
                                  passwordController.text.trim(),
                                  waliEmailController.text.trim(),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              backgroundColor: Colors.blue.shade700,
                            ),
                            child: Text(
                              'Sign Up',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        )),
                  SizedBox(height: 16),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: 'Log In',
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Get.to(() => LoginScreen()),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
