import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:wali_project/components/utils/utils.dart';

class WaliController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var walis = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(milliseconds: 100), fetchWalis);
  }

  Future<void> initializeUser(String waliEmail) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();
      List<Map<String, dynamic>> initialWalis = [];
      if (waliEmail.isNotEmpty) {
        initialWalis.add({
          'email': waliEmail,
          'status': 'pending',
        });
      }
      if (!doc.exists) {
        await _firestore.collection('users').doc(userId).set({
          'walis': initialWalis,
        });
        walis.value = initialWalis;
      } else {
        await fetchWalis();
      }
    } catch (e) {
       Utils.toastMessage(
        
        'Failed to initialize user: $e',
        
      );
    }
  }

  Future<void> fetchWalis() async {
    try {
      var currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return;
      }
      String userId = currentUser.uid;
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();

      if (doc.exists) {
        var walisData = doc['walis'] ?? [];
        walis.value = (walisData as List)
            .where((item) => item is Map<String, dynamic>)
            .map((item) => Map<String, dynamic>.from(item))
            .toList();
      } else {
        await _firestore.collection('users').doc(userId).set({'walis': []});
        walis.value = [];
      }
    } catch (e) {
       Utils.toastMessage(
        
        e.toString(),
       
      );
    }
  }

  Future<void> addWali(String waliEmail) async {
    try {
      var currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
         Utils.toastMessage(

          'User not logged in',
         
        );
        return;
      }
      String userId = currentUser.uid;

      Map<String, dynamic> waliData = {
        'email': waliEmail,
        'status': 'pending',
      };

      DocumentReference userDocRef = _firestore.collection('users').doc(userId);
      DocumentSnapshot doc = await userDocRef.get();

      if (!doc.exists) {
        await userDocRef.set({'walis': []});
      }

      await userDocRef.update({
        'walis': FieldValue.arrayUnion([waliData]),
      });

      await fetchWalis();
      await sendWaliInvitationEmail(waliEmail);
       Utils.toastMessage(
        
        'Wali added and invitation sent.',
       
      );
    } catch (e) {
       Utils.toastMessage(

        e.toString(),
       
      );
    }
  }

  Future<void> removeWali(String waliEmail) async {
    try {
      var currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
         Utils.toastMessage(

          'User not logged in',
         
        );
        return;
      }
      String userId = currentUser.uid;
      var waliToRemove =
          walis.firstWhereOrNull((wali) => wali['email'] == waliEmail);
      if (waliToRemove == null) {
         Utils.toastMessage(
          
          'Wali not found',
        
        );
        return;
      }

      await _firestore.collection('users').doc(userId).update({
        'walis': FieldValue.arrayRemove([waliToRemove])
      });
      walis.removeWhere((wali) => wali['email'] == waliEmail);
       Utils.toastMessage(

        'Wali removed',
       
      );
    } catch (e) {
       Utils.toastMessage(
        
        e.toString(),
      
      );
    }
  }

  void clearWalis() {
    walis.clear();
  }

  Future<void> sendWaliInvitationEmail(String recipientEmail) async {
    String username = 'hassanamjadyousafzai@gmail.com';
    String password = 'aznp hbbn dyof wjkv';

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'Mini Muslim App')
      ..recipients.add(recipientEmail)
      ..subject = 'Invitation to Join as a Wali'
      ..text =
          'You have been invited to join Mini Muslim App as a wali. Please sign up or log in to view your responsibilities.';

    try {
      final sendReport = await send(message, smtpServer);
      print('Email sent: ${sendReport.toString()}');
       Utils.toastMessage(
        
        'Invitation sent to $recipientEmail',
       
      );
    } on MailerException catch (e) {
      print('Email sending failed: $e');
       Utils.toastMessage(

        'Could not send invitation email.',
      
      );
    }
  }
}
