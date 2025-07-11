import 'package:flutter/material.dart';
import 'package:get/get.dart';

theSnackBar(context, String message) {
  return SnackBar(
    duration: Duration(seconds: 2),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 260.0,
          child: Text(message, overflow: TextOverflow.fade, softWrap: false),
        ),
      ],
    ),
    backgroundColor: Colors.greenAccent,
  );
}

successSnackBar() {
  return GetSnackBar(message: 'Success', duration: const Duration(seconds: 3));
}

errorSnackBar({required String message}) {
  return GetSnackBar(
    title: "Error",
    message: message,
    duration: const Duration(seconds: 3),
    backgroundColor: Colors.red,
    snackPosition: SnackPosition.BOTTOM,
  );
}
