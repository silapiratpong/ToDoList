import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DateController extends GetxController {
  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  void pickDate(BuildContext context) async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (_picked != null) {
      selectedDate.value = _picked;
    }
  }
}
