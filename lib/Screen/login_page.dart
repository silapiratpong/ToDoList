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
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 80),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Welcome Back!",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  "Login to continue",
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
                const SizedBox(height: 32),
                Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      ///Email
                      TextFormField(
                        controller: email,
                        validator: (value) =>
                            ToDoValidator.validateEmail(value),
                        decoration: InputDecoration(
                          labelText: "Email",
                          prefixIcon: const Icon(Iconsax.direct_right),
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

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
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
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
                      const SizedBox(height: 24),

                      ///Signin
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyan,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
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
                          child: Text(
                            "Sign in",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      ///Create Account
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: BorderSide(color: Colors.cyan),
                          ),
                          onPressed: () => Get.to(SignupPage()),
                          child: Text(
                            "Create Account",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.cyan[700],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
