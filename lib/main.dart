import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firestoreCrud/editDialog.dart';
import 'package:firestoreCrud/services/database.dart';
import 'package:firestoreCrud/task.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ToDoApp());
}

class ToDoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Container();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(title: 'To-Do List', home: ToDoList());
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Container();
      },
    );
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
      stream: FirebaseFirestore.instance
          .collection('tasks')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: snapshot.data.docs.length,
            itemBuilder: (BuildContext context, int index) => Task(
                content: snapshot.data.docs[index]['content'],
                id: snapshot.data.docs[index].id,
                update: _updateTask,
                delete: _deleteTask),
          );
        } else {
          return Container();
        }
      },
    );
  }

  void _updateTask(String updatedValue, String id) {
    var task = <String, dynamic>{
      'content': updatedValue,
      'timestamp': DateTime.now().millisecondsSinceEpoch
    };

    Database.updateTask(id, task);
  }

  void _deleteTask(String id) {
    Database.deleteTask(id);
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
