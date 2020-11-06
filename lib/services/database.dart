import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> addTask(Map<String, dynamic> task) async {
    await _db.collection('tasks').doc().set(task).catchError((e) {
      print(e);
    });
    return true;
  }

  static Future<void> updateTask(String id, Map<String, dynamic> task) async {
    await _db.collection('tasks').doc(id).update(task).catchError((e) {
      print(e);
    });
    return true;
  }

  static Future<void> deleteTask(String id) async {
    await _db.collection('tasks').doc(id).delete().catchError((e) {
      print(e);
    });
    return true;
  }
}
