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
                      decoration: const InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(Iconsax.direct_right),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Obx(
                      () => TextFormField(
                        controller: password,
                        obscureText: hidePassword.value,
                        validator: (value) =>
                            ToDoValidator.validatePassword(value),
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
                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
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
                          } on FirebaseAuthException catch (e) {
                            String errorMessage;

                            switch (e.code) {
                              case 'user-not-found':
                                errorMessage = 'No user found for that email.';
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
