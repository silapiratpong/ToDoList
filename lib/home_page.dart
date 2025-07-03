import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todolist/data/database.dart';
import 'package:todolist/util/dialog_box.dart';
import 'package:todolist/util/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final _box = Hive.box('box');
  ToDoDatabase db = ToDoDatabase();

  @override
  void initState(){
    if(_box.get("TODOLIST") == null)
      {
        db.createInitialData();
      }
    else{
      db.loadData();
    }

  }
  final _controller = TextEditingController();
  void checkboxChanged(bool? value,int index)
  {
    setState(() {
      db.toDoList[index][1]=!db.toDoList[index][1];
    });
    db.updateDataBase();
  }
void saveNewTask()
{
  setState(()
  {
    if(_controller.text!="")
      {
        db.toDoList.add([_controller.text,false]);
        _controller.clear();
      }
    else
      {
        //snackbar nothing happen
      }

  });
  Navigator.of(context).pop();
  db.updateDataBase();
}
//create new task
void createNewTask()
{
  showDialog(context: context, builder: (context)
  {
    return DialogBox
      (controller: _controller,
      onSave: saveNewTask,
      onCancel: ()=>Navigator.of(context).pop(),);
  });
}
void deleteTask(int index)
{
  setState(() {
    db.toDoList.removeAt(index);
  });
  db.updateDataBase();
}

  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('ToDoList'),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(Icons.add),
      ),
      body: ListView.builder
        (
          itemCount: db.toDoList.length,
          itemBuilder: (context,index){
            return ToDoTile(
                taskName: db.toDoList[index][0],
                taskComplete: db.toDoList[index][1],
                onChanged: (value)=>checkboxChanged(value,index),
                deleteFunction: (context)=> deleteTask(index),
                );
          },
        ),

    );
  }

  }