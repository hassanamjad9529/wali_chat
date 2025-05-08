import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wali_project/controllers/auth_controllert.dart';
import '../controllers/wali_controller.dart';
import '../models/user_model.dart';

class DashboardScreen extends StatelessWidget {
  final AuthController authController = Get.find();
  final WaliController waliController = Get.find<WaliController>();
  final TextEditingController waliEmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    UserModel userModel = UserModel.fromFirebaseUser(user!);

    // Get screen width for responsive design
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final maxCardWidth = isMobile ? screenWidth : 1000.0;
    final padding = isMobile ? 12.0 : 16.0;
    final titleFontSize = isMobile ? 22.0 : 24.0;
    final subtitleFontSize = isMobile ? 16.0 : 20.0;
    final listFontSize = isMobile ? 14.0 : 16.0;

    return Scaffold(
      backgroundColor: Color(0xfff0f3f2),
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          'Mini Muslim Dating App',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color(0xff1b60c9),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () => authController.signOut(),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWeb = constraints.maxWidth >= 600;
          final content = ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxCardWidth),
            child: Padding(
              padding: EdgeInsets.all(padding * 1.5),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: padding),
                    Text(
                      'Dashboard',
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff1b60c9),
                      ),
                    ),
                    Text(
                      'Welcome back! Let\'s take a look at your profile.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: padding),
                    Text(
                      '${userModel.name}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${userModel.email}',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 30),
                    Text(
                      'Add Wali',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: isMobile ? 47 : 50,
                      child: TextField(
                        cursorColor: Colors.black,
                        cursorHeight: 15,
                        controller: waliEmailController,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Wali\'s Email',
                          hintStyle: TextStyle(fontSize: 12),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        style: TextStyle(fontSize: listFontSize),
                      ),
                    ),
                    SizedBox(height: padding),
                    ElevatedButton(
                      onPressed: () {
                        final email = waliEmailController.text;
                        if (email.isEmpty) {
                          Get.snackbar(
                            'Error',
                            'Email cannot be empty',
                            snackPosition: SnackPosition.BOTTOM,
                            colorText: Colors.black,
                          );
                        } else if (!GetUtils.isEmail(email)) {
                          Get.snackbar(
                            'Error',
                            'Please enter a valid email address',
                            snackPosition: SnackPosition.BOTTOM,
                            colorText: Colors.black,
                          );
                        } else {
                          waliController.addWali(email);
                          waliEmailController.clear();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: isMobile ? 10 : 14,
                          horizontal: isMobile ? 40 : 30,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundColor: Color(0xff1b60c9),
                      ),
                      child: Text(
                        'Add',
                        style: TextStyle(
                            fontSize: listFontSize, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: padding * 1.5),
                    Text(
                      'My Walis',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: padding * 0.5),
               Obx(() => waliController.walis.isEmpty
    ? Center(
        child: Text(
          'No walis added yet.',
          style: TextStyle(fontSize: listFontSize),
        ),
      )
    : ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: waliController.walis.length,
        itemBuilder: (context, index) {
          final wali = waliController.walis[index];
          return Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              title: Text(
                wali['email'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                'Status: ${wali['status']}',
                style: TextStyle(fontSize: listFontSize - 2),
              ),
              trailing: GestureDetector(
                onTap: () {
                  // Show confirmation dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Confirm Deletion'),
                        content: Text(
                            'Are you sure you want to remove this wali?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              waliController.removeWali(wali['email']);
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text(
                              'Yes',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xffdee5f4),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Remove",
                    style: TextStyle(
                      fontSize: listFontSize - 2,
                      color: Color(0xff1b60c9),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      )),   ],
                ),
              ),
            ),
          );

          return isWeb ? Center(child: content) : content;
        },
      ),
    );
  }
}
