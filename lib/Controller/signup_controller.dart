import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  ///variables
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> signupPageKey = GlobalKey<FormState>();

  ///signup
  Future<void> signUp() async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
          email: email.text.trim(),
          password: password.text.trim(),
        );
    print(userCredential);
  }
}
