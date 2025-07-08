import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:todolist/Screen/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todolist/Screen/login_page.dart';
import 'package:firebase_core/firebase_core.dart' ;
import 'data/data.repostory.dart';
import 'firebase_options.dart' ;

void main() async {
  await Hive.initFlutter();

  var database = await Hive.openBox('todoDataBase');
  /*await Firebase . initializeApp (options : DefaultFirebaseOptions . currentPlatform ,).then(
      (FirebaseApp value) => Get.put(AuthenticationRepository()),
  );*/
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GetMaterialApp(home: LoginPage(),),
      theme: ThemeData(primarySwatch: Colors.grey),
    );
  }
}
