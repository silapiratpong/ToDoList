import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todolist/util/button.dart';
import '../Controller/date_Controller.dart';
import '../Controller/task_Controller.dart';

class DialogBox extends StatelessWidget {
  final DateController dateController;

  final textController;
  VoidCallback onSave;
  VoidCallback onCancel;
  DialogBox({
    super.key,
    required this.textController,
    required this.onSave,
    required this.onCancel,
    required this.dateController,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: Colors.white,
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            const Text(
              "Create New Task",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            // Text field
            TextField(
              controller: textController,
              decoration: InputDecoration(
                labelText: "Task Title",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.task),
              ),
            ),

            const SizedBox(height: 16),

            // Privacy checkbox
            Obx(() => Row(
              children: [
                Checkbox(
                  value: Get.find<TaskController>().isPrivate.value,
                  onChanged: (value) =>
                      Get.find<TaskController>().togglePrivacy(value),
                ),
                const Text(
                  'Private Task',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            )),

            const SizedBox(height: 8),

            // Date Picker section
            GestureDetector(
              onTap: () => dateController.pickDate(context),
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.cyan.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Obx(() {
                  final date = dateController.selectedDate.value;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        date == null
                            ? 'Select a date'
                            : DateFormat('dd MMM yyyy').format(date),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  );
                }),
              ),
            ),

            const SizedBox(height: 20),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Button(
                    text: "Cancel",
                    onPressed: onCancel,
                    backgroundColor: Colors.grey.shade300,
                    textColor: Colors.black,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Button(
                    text: "Save",
                    onPressed: onSave,
                    backgroundColor: Colors.cyan,
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
