import 'package:flutter/material.dart';

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


