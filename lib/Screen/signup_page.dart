import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/Controller/Validator.dart';
import 'package:todolist/Controller/signup_controller.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                child: Column(
                  children: [
                    TextFormField(
                      controller: controller.email,
                      validator: (value) => ToDoValidator.validateEmail(value),
                      decoration: const InputDecoration(labelText: "Email"),
                    ),
                    const SizedBox(height: 25),
                    TextFormField(
                      controller: controller.password,
                      onSaved: (String? value){},
                      validator: (value) {
                        return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
                      }/*=>ToDoValidator.validatePassword(value)*/,
                      decoration: const InputDecoration(labelText: "Password"),
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
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
