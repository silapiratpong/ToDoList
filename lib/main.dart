import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/Screen/home_page.dart';
import 'package:todolist/Screen/login_page.dart';
import 'package:firebase_core/firebase_core.dart' ;
import 'data/data.repostory.dart';
import 'firebase_options.dart' ;

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase . initializeApp (options : DefaultFirebaseOptions . currentPlatform ,).then(
      (FirebaseApp value) => Get.put(AuthenticationRepository()),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(stream: FirebaseAuth.instance.idTokenChanges(), builder: (context,snapshot)
      {
        if(snapshot.connectionState == ConnectionState.waiting)
          {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        if(snapshot.data != null)
          {
            return const HomePage();
          }
        return LoginPage();
      }) ,
      //GetMaterialApp(home: LoginPage(),),
      theme: ThemeData(primarySwatch: Colors.grey),
    );
  }
}
