import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todolist/data/database.dart';
import 'package:todolist/util/dialog_box.dart';
import 'package:todolist/util/snackBar.dart';
import 'package:todolist/util/todo_tile.dart';
import 'package:uuid/uuid.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _db = FirebaseFirestore.instance;
  /*final _database = Hive.box(
    'todoDataBase',
  ); //ตั้งชื่อให้ตัวเองหรือคนอื่นอ่านรู้เรื่อง
  ToDoDatabase db = ToDoDatabase();*/
  final _controller = TextEditingController(); //อ่านยาก จัดให้เป็นระเบียบ
  @override

  void checkboxChanged(String id,bool value) {
    /*(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataBase();*/
    _db.collection("tasks").doc(id).update({"check": !value,});
  }
  
  Future<void> uploadListToDb() async {
    try{
      final id = const Uuid().v4();
        await _db.collection("tasks").doc(id).set({
          "title":_controller.text,
          "check": false,
          "creator" : FirebaseAuth.instance.currentUser!.uid,
      });
    }catch(e){
      print(e);
    }
  }
  void saveNewTask() {
    /*setState(() {
      if (_controller.text != "") {
        db.toDoList.add([_controller.text, false]);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(theSnackBar(context, "Created Task Success"));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(theSnackBar(context, "error"));
      }
    });*/
    uploadListToDb();
    _controller.clear();
    Navigator.of(context).pop();
  }

  //create new task
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void deleteTask(String id) {
    /*setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(theSnackBar(context, "Task Delete"));*/
    _db.collection("tasks").doc(id).delete();
  }

  void logOut() {
    FirebaseAuth.instance.signOut();
  }

  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('ToDoList'), elevation: 0,
        actions: <Widget>[
          TextButton(onPressed: logOut, child: Text("Logout"))
        ],),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: _db.collection("tasks").where('creator',isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots(),
        builder: (context,snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting)
            {
              return const Center(child: CircularProgressIndicator(),);
            }
          if(!snapshot.hasData)
            {
              return const Text('no data');
            }
          return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return ToDoTile(
              taskName: snapshot.data!.docs[index].data()['title'],
              taskComplete: snapshot.data!.docs[index].data()['check'],
              onChanged: (value) => checkboxChanged(snapshot.data!.docs[index].id,snapshot.data!.docs[index].data()['check']),
              deleteFunction: (context) => deleteTask(snapshot.data!.docs[index].id),
            );
          },
        );
        },
      ),
    );
  }
}
