import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  static final Firestore _db = Firestore.instance;

  static Future<void> addTask(Map<String, dynamic> task) async {
    await _db.collection('tasks').document().setData(task);
  }
}
