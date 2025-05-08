import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class WaliController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var walis = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchWalis(); // Optionally fetch walis on initialization
  }

  Future<void> fetchWalis() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();

      if (doc.exists) {
        // Get the 'walis' field from Firestore document
        var walisData = doc['walis'] ?? [];

        // Ensure it's safely converted to List<Map<String, dynamic>>
        walis.value = (walisData as List)
            .where((item) => item is Map<String, dynamic>)
            .map((item) => Map<String, dynamic>.from(item))
            .toList();
      } else {
        // If document doesn't exist, create it with empty walis list
        await _firestore.collection('users').doc(userId).set({'walis': []});
        walis.value = [];
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

 Future<void> addWali(String waliEmail) async {
  try {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    Map<String, dynamic> waliData = {
      'email': waliEmail,
      'status': 'pending',
    };

    DocumentReference userDocRef = _firestore.collection('users').doc(userId);
    DocumentSnapshot doc = await userDocRef.get();

    if (!doc.exists) {
      // If user doc doesn't exist, create it with an empty walis list
      await userDocRef.set({'walis': []});
    }

    // Now safely update the document
    await userDocRef.update({
      'walis': FieldValue.arrayUnion([waliData]),
    });

    await fetchWalis(); // Refresh list
    await sendWaliInvitationEmail(waliEmail);
    print("Wali added successfully");
    Get.snackbar('Success', 'Wali added and invitation sent.');
  } catch (e) {
    Get.snackbar('Error', e.toString());
  }
}


  Future<void> removeWali(Map<String, dynamic> wali) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      await _firestore.collection('users').doc(userId).update({
        'walis': FieldValue.arrayRemove([wali])
      });
      walis.remove(wali);
      Get.snackbar('Success', 'Wali removed');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void clearWalis() {
    walis.clear();
  }
  Future<void> sendWaliInvitationEmail(String recipientEmail) async {
    // ⚠️ WARNING: Never hardcode your credentials in production!
    String username = 'hassanamjadyousafzai@gmail.com'; // use your email
    String password = "aznp hbbn dyof wjkv";

    final smtpServer = gmail(username, password);

    // Email content
    final message = Message()
      ..from = Address(username, 'Mini Muslim App')
      ..recipients.add(recipientEmail)
      ..subject = 'Invitation to Join as a Wali'
      ..text =
          'You have been invited to join Mini Muslim App as a wali. Please sign up or log in to view your responsibilities.';

    try {
      final sendReport = await send(message, smtpServer);
      print('Email sent: ${sendReport.toString()}');
      Get.snackbar('Email Sent', 'Invitation sent to $recipientEmail');
    } on MailerException catch (e) {
      print('Email sending failed: $e');
      Get.snackbar('Email Error', 'Could not send invitation email.');
    }
  }

}
