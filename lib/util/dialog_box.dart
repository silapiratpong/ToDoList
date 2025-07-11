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
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      backgroundColor: Colors.white,
      content: Container(
        height: 400,
        width: double.infinity,
        child: Column(
          children: [
            TextField(
              controller: textController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Add Text",
              ),
            ),
            Row(
              children: [
                Obx(
                  () => Checkbox(
                    value: Get.find<TaskController>().isPrivate.value,
                    onChanged: (value) =>
                        Get.find<TaskController>().togglePrivacy(value),
                  ),
                ),
                Text('Private Task'),
                //Checkbox(value: taskPrivate, onChanged: onChanged),
              ],
            ),

            GestureDetector(
              onTap: () => dateController.pickDate(context),
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(20),
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Obx(() {
                        final date = dateController.selectedDate.value;
                        return Text(
                          date == null
                              ? 'No date selected.'
                              : DateFormat('dd MMM yyyy').format(date),
                        );
                      }),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: 80,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade100,
                      ),
                      child: Center(child: Text("Time")),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                //save
                Button(text: "Save", onPressed: onSave),
                const SizedBox(width: 8),
                //cancel
                Button(text: "Cancel", onPressed: onCancel),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
