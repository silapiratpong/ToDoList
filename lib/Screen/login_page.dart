import 'package:flutter/material.dart';
import 'package:todolist/Screen/home_page.dart';
import 'package:todolist/Screen/signup_page.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

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
                child: Column(
                  children: [
                    ///Email
                    TextFormField(
                      decoration: const InputDecoration(labelText: "Email"),
                    ),
                    const SizedBox(height: 10.0),

                    ///Password
                    TextFormField(
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
                        onPressed: () => Get.to(() => HomePage()),
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
