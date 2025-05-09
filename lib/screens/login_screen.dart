import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wali_project/components/reuseable_widgets/custom_textfield.dart';
import 'package:wali_project/components/utils/utils.dart';
import 'package:wali_project/controllers/auth_controllert.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  final AuthController authController = Get.find();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Validate inputs
  bool _validateInputs() {
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
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  SizedBox(height: 24),
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
                  SizedBox(height: 24),
                  Obx(() => authController.isLoading.value
                      ? Center(child: CircularProgressIndicator())
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_validateInputs()) {
                                authController.login(
                                  emailController.text.trim(),
                                  passwordController.text.trim(),
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
                              'Log In',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        )),
                  SizedBox(height: 16),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Don’t have an account? ',
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: 'Sign Up',
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Get.to(() => SignupScreen()),
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
