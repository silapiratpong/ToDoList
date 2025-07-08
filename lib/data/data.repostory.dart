import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthenticationRepository extends GetxController{
  static AuthenticationRepository get instance => Get.find();

  final deviceStorage = GetStorage();
  //final _auth = FirebaseAuth.instance;

/*Future<UserCredential> registerWithEmailAndPassword(String email,String password) async{
  try{

  }
}*/
}