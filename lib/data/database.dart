import 'package:hive_flutter/hive_flutter.dart';

class ToDoDatabase {
  List toDoList = [];
  final _database = Hive.box('todoDataBase');

  void createInitialData() {
    toDoList = [
      ["Make Tutorial", false],
      ["...", false],
    ];
  }

  void loadData() {
    toDoList = _database.get("TODOLIST");
  }

  void updateDataBase() {
    _database.put("TODOLIST", toDoList);
  }
}
