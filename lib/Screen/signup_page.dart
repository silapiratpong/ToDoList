import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/Controller/Validator.dart';
import 'package:todolist/Controller/signup_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todolist/Screen/login_page.dart';
import 'package:todolist/util/snackBar.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final email = TextEditingController();
    final password = TextEditingController();
    final _formkey = GlobalKey<FormState>();
    final controller = Get.put(SignupController());
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            children: [
              Text("Sign Up"),
              const SizedBox(height: 25),
              Form(
                key: _formkey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: email,
                      validator: (value) => ToDoValidator.validateEmail(value),
                      decoration: const InputDecoration(labelText: "Email"),
                    ),
                    const SizedBox(height: 25),
                    TextFormField(
                      controller: password,
                      validator: (value) =>
                          ToDoValidator.validatePassword(value),
                      decoration: const InputDecoration(labelText: "Password"),
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          try{
                            if (_formkey.currentState!.validate()) {
                              UserCredential userCredential = await FirebaseAuth
                                  .instance
                                  .createUserWithEmailAndPassword(
                                email: email.text.trim(),
                                password: password.text.trim(),
                              );
                              print(userCredential);
                              Get.to(LoginPage());
                              Get.showSnackbar(successSnackBar());
                            }
                          }catch(e){
                            print(e);
                            //Get.showSnackbar(errorSnackBar(e));
                          }
                          //await SignupController().signUp();
                        },
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
