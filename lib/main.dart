import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestoreCrud/editDialog.dart';
import 'package:firestoreCrud/services/database.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ToDoApp());
}

class ToDoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'To-Do List', home: ToDoList());
  }
}

class ToDoList extends StatefulWidget {
  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('To-Do List')),
      body: _getTasks(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayDialog(context),
        tooltip: 'Add Item',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _getTasks() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('tasks')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int index) => Container(
              margin: const EdgeInsets.all(10),
              child: Text(
                snapshot.data.documents[index]['content'],
                style: TextStyle(fontSize: 21),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Future<void> _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return EditDialog(
              title: 'Add Task',
              positiveAction: 'ADD',
              negativeAction: 'CANCEL',
              submit: _handleDialogSubmission);
        });
  }

  void _handleDialogSubmission(String value) {
    var task = <String, dynamic>{
      'content': value,
      'timestamp': DateTime.now().millisecondsSinceEpoch
    };

    Database.addTask(task);
  }
}
