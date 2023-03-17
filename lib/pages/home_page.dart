import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../components/dialog_box.dart';
import '../data/database.dart';
import '../components/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _myBox = Hive.box('mybox');
  final _controller = TextEditingController();
  ToDoDataBase dataBase = ToDoDataBase();

  @override
  void initState() {
    if (_myBox.get('TODOLIST') == null) {
      dataBase.createInitialData();
    } else {
      dataBase.loadData();
    }
    super.initState();
  }

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      dataBase.toDoList[index][1] = !dataBase.toDoList[index][1];
    });
    dataBase.uptadeDataBase();
  }

  void saveNewTask() {
    setState(() {
      dataBase.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    dataBase.uptadeDataBase();
  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) => DialogBox(
        controller: _controller,
        onSave: saveNewTask,
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }

  void deleteTask(int index) {
    setState(() {
      dataBase.toDoList.removeAt(index);
    });
    dataBase.uptadeDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[200],
      appBar: AppBar(
        centerTitle: true,
        title: const Text('TO DO'),
        elevation: 0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: dataBase.toDoList.length,
        itemBuilder: (context, index) => ToDoTile(
          taskName: dataBase.toDoList[index][0],
          taskCompleted: dataBase.toDoList[index][1],
          onChanged: (value) => checkBoxChanged(value, index),
          deleteFunction: (context) => deleteTask(index),
        ),
      ),
    );
  }
}
