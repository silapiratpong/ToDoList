import 'package:hive_flutter/hive_flutter.dart';

class ToDoDatabase{

  List toDoList = [];
  final _box = Hive.box('box');

  void createInitialData(){
    toDoList = [
      ["Make Tutorial",false],
      ["...",false],
    ];
  }

  void loadData(){
    toDoList = _box.get("TODOLIST");
  }

  void updateDataBase(){
    _box.put("TODOLIST",toDoList);
  }
}