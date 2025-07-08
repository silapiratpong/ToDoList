import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogInController extends GetxController {
  static LogInController get instance => Get.find();
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginPageKey = GlobalKey<FormState>();

}