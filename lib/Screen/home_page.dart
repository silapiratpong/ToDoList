import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/util/dialog_box.dart';
import 'package:todolist/util/snackBar.dart';
import 'package:todolist/util/todo_tile.dart';
import 'package:uuid/uuid.dart';
import '../Controller/date_Controller.dart';
import '../Controller/task_Controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _db = FirebaseFirestore.instance;
  final _controller = TextEditingController();
  final DateController _dateController = Get.put(
    DateController(),
  ); //อ่านยาก จัดให้เป็นระเบียบ
  final TaskController _taskController = Get.put(TaskController());
  void checkboxChanged(String id, bool value) {
    _db.collection("tasks").doc(id).update({"check": !value});
  }

  Future<void> uploadListToDb() async {
    try {
      final id = const Uuid().v4();
      await _db.collection("tasks").doc(id).set({
        "title": _controller.text,
        "check": false,
        "creator": FirebaseAuth.instance.currentUser!.uid,
        "Date": _dateController.selectedDate.value != null
            ? Timestamp.fromDate(_dateController.selectedDate.value!)
            : null,
        "isPrivate": _taskController.isPrivate.value,
      });
    } catch (e) {
      print(e);
    }
  }

  void saveNewTask() {
    if (_controller.text != "") {
      uploadListToDb();
      _controller.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(theSnackBar(context, "error"));
    }
    Navigator.of(context).pop();
  }

  void saveEditTask(String id) {
    _db.collection("tasks").doc(id).update({"title": _controller.text});
    _db.collection("tasks").doc(id).update({
      "Date": _dateController.selectedDate.value != null
          ? Timestamp.fromDate(_dateController.selectedDate.value!)
          : null,
    });
    _db.collection("tasks").doc(id).update({
      "isPrivate": _taskController.isPrivate.value,
    });
    _controller.clear();
    Navigator.of(context).pop();
  }

  //create new task
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          textController: _controller,
          onSave: saveNewTask,
          onCancel: () {
            Navigator.of(context).pop();
            _controller.clear();
            _taskController.reset();
            _dateController.selectedDate.value = null;
            _taskController.reset();
          },
          dateController: _dateController,
        );
      },
    );
  }

  void editTask(String id) async {
    final doc = await _db.collection("tasks").doc(id).get();
    final data = doc.data();
    if (data != null) {
      final rawDate = data['Date'];
      _dateController.selectedDate.value = rawDate != null
          ? (rawDate as Timestamp).toDate()
          : null;
      _controller.text = data['title'];
      Get.find<TaskController>().isPrivate.value = data['isPrivate'] ?? false;
    }
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          textController: _controller,
          onSave: () => saveEditTask(id),
          onCancel: () {
            Navigator.of(context).pop();
            _controller.clear();
            _taskController.reset();
            _dateController.selectedDate.value = null;
            _taskController.reset();
          },
          dateController: _dateController,
        );
      },
    );
  }

  void deleteTask(String id) {
    _db.collection("tasks").doc(id).delete();
  }

  void logOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('ToDoList'),
        elevation: 0,
        actions: <Widget>[TextButton(onPressed: logOut, child: Text("Logout"))],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: _db.collection("tasks").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Text('no data');
          }
          final docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              if (doc['isPrivate'] == false) {
                return ToDoTile(
                  taskName: doc['title'],
                  taskComplete: doc['check'],
                  onChanged: (value) => checkboxChanged(doc.id, doc['check']),
                  deleteFunction: (context) => deleteTask(doc.id),
                  editFunction: (context) => editTask(doc.id),
                  dateTime: doc['Date'],
                );
              } else if (doc['creator'] ==
                      FirebaseAuth.instance.currentUser!.uid &&
                  doc['isPrivate'] == true) {
                return ToDoTile(
                  taskName: doc['title'],
                  taskComplete: doc['check'],
                  onChanged: (value) => checkboxChanged(doc.id, doc['check']),
                  deleteFunction: (context) => deleteTask(doc.id),
                  editFunction: (context) => editTask(doc.id),
                  dateTime: doc['Date'],
                );
              } else {
                return const SizedBox.shrink(); // return empty widget instead of null
              }
            },
          );
        },
      ),
    );
  }
}
