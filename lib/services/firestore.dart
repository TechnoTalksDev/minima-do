import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');
  
  String getCurrentUserUid() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      throw Exception('User not authenticated');
    }
  }

  //create
  Future<void> addTask(String task) {
    String uid = getCurrentUserUid();
    return tasks.add({
      'task': task,
      'timestamp': Timestamp.now(),
      'completed': false,
      'uid': uid
    });
  }
  //read
  Stream<QuerySnapshot> getTasksStream() {
    String uid = getCurrentUserUid();
    print(uid);
    return tasks.where('uid', isEqualTo: uid).orderBy('completed', descending: false).snapshots();
  }

  //update
  Future<void> updateTask(String docID, String newTask) {
    String uid = getCurrentUserUid();
    return tasks.doc(docID).update({
      'task': newTask,
      'timestamp': Timestamp.now(),
      'uid': uid  // Ensure the UID is included for authentication
    });
  }

  Future<void> completeTask(String docID) {
    return tasks.doc(docID).update({
      'completed': true
    });
  }

  Future<void> unCompleteTask(String docID) {
    return tasks.doc(docID).update({
      'completed': false
    });
  }

  //delete
  Future<void> deleteTask(String docID) {
    return tasks.doc(docID).delete();
  }
}