import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  ///variables
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> signupPageKey = GlobalKey<FormState>();

  ///signup
  Future<void> signup() async {
    try {
      if (!signupPageKey.currentState!.validate()) {}
    } finally {}
  }
}
