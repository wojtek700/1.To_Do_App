import 'package:hive/hive.dart';

class ToDoDataBase {
  List toDoList = [];

  final _myBox = Hive.box('mybox');

  void createInitialData() {
    toDoList = [
      ['Make a bed', false],
      ['Do Exercise', false],
    ];
  }

  void loadData() {
    toDoList = _myBox.get('TODOLIST');
  }

  void uptadeDataBase() {
    _myBox.put('TODOLIST', toDoList);
  }
}
