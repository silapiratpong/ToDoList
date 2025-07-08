import 'package:flutter/material.dart';
import 'package:todolist/Controller/Validator.dart';
import 'package:todolist/Screen/home_page.dart';
import 'package:todolist/Screen/signup_page.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final email = TextEditingController();
  final password = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: 56.0,
            left: 24.0,
            bottom: 24.0,
            right: 24.0,
          ),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text("Login Title")],
              ),
              Form(
                key: _formkey,
                child: Column(
                  children: [
                    ///Email
                    TextFormField(
                      controller: email,
                      validator: (value) => ToDoValidator.validateEmail(value),
                      decoration: const InputDecoration(labelText: "Email"),
                    ),
                    const SizedBox(height: 10.0),

                    ///Password
                    TextFormField(
                      controller: password,
                      validator: (value) =>
                          ToDoValidator.validatePassword(value),
                      decoration: const InputDecoration(labelText: "Password"),
                    ),
                    const SizedBox(height: 5.0),

                    ///Forget pw
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: const Text("Forget Password?"),
                        ),
                      ],
                    ),

                    ///Signin
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            UserCredential userCredential = await FirebaseAuth
                                .instance
                                .signInWithEmailAndPassword(
                                  email: email.text.trim(),
                                  password: password.text.trim(),
                                );
                            print(userCredential);
                          }
                        },
                        child: Text("Sign in"),
                      ),
                    ),
                    const SizedBox(height: 10.0),

                    ///Create Account
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Get.to(SignupPage()),
                        child: Text("Create Account"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
