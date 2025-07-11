import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
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
    final hidePassword = true.obs;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: Colors.cyan,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              children: [
                const Text(
                  "Create Your Account",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  "Join us by signing up below",
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
                const SizedBox(height: 32),

                Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      // Email field
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
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),

                      // Password field
                      Obx(
                        () => TextFormField(
                          controller: password,
                          obscureText: hidePassword.value,
                          validator: (value) =>
                              ToDoValidator.validatePassword(value),
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
                      const SizedBox(height: 32),

                      // Create Account Button
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
                                        .createUserWithEmailAndPassword(
                                          email: email.text.trim(),
                                          password: password.text.trim(),
                                        );
                                print(userCredential);
                                Get.offAll(() => LoginPage());
                                Get.showSnackbar(successSnackBar());
                              }
                            } on FirebaseAuthException catch (e) {
                              String errorMessage;

                              switch (e.code) {
                                case 'email-already-in-use':
                                  errorMessage =
                                      'This email is already in use.';
                                  break;
                                case 'invalid-email':
                                  errorMessage = 'Invalid email format.';
                                  break;
                                case 'operation-not-allowed':
                                  errorMessage = 'Operation not allowed.';
                                  break;
                                case 'weak-password':
                                  errorMessage = 'The password is too weak.';
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
                          child: const Text(
                            "Create Account",
                            style: TextStyle(fontSize: 16),
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
