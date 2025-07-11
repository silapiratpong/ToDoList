import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:todolist/Controller/Validator.dart';
import 'package:todolist/Screen/signup_page.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todolist/util/snackBar.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final email = TextEditingController();
  final password = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final hidePassword = true.obs;
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      ///Email
                      TextFormField(
                        controller: email,
                        validator: (value) =>
                            ToDoValidator.validateEmail(value),
                        decoration: const InputDecoration(
                          labelText: "Email",
                          prefixIcon: Icon(Iconsax.direct_right),
                        ),
                      ),
                      const SizedBox(height: 10.0),

                      ///Password
                      Obx(
                        () => TextFormField(
                          controller: password,
                          obscureText: hidePassword.value,
                          validator: (value) => ToDoValidator.validateEmptyText(
                            'Password',
                            value,
                          ),
                          decoration: InputDecoration(
                            labelText: "Password",
                            prefixIcon: const Icon(Iconsax.password_check),
                            suffixIcon: IconButton(
                              onPressed: () =>
                                  hidePassword.value = !hidePassword.value,
                              icon: Icon(
                                hidePassword.value
                                    ? Iconsax.eye_slash
                                    : Iconsax.eye,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5.0),

                      ///Signin
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              if (_formkey.currentState!.validate()) {
                                UserCredential userCredential =
                                    await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                          email: email.text.trim(),
                                          password: password.text.trim(),
                                        );
                                print(userCredential);
                                Get.showSnackbar(successSnackBar());
                              }
                            } on FirebaseAuthException catch (e) {
                              String errorMessage;

                              switch (e.code) {
                                case 'user-not-found':
                                  errorMessage =
                                      'No user found for that email.';
                                  break;
                                case 'wrong-password':
                                  errorMessage = 'Wrong password provided.';
                                  break;
                                case 'invalid-email':
                                  errorMessage = 'Invalid email format.';
                                  break;
                                case 'user-disabled':
                                  errorMessage =
                                      'This user account has been disabled.';
                                  break;
                                default:
                                  errorMessage =
                                      e.message ?? 'Authentication failed.';
                              }
                              Get.showSnackbar(
                                errorSnackBar(message: errorMessage),
                              );
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
