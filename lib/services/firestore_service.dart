import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/message.dart';

class FirestoreService {
  final CollectionReference messagesRef =
      FirebaseFirestore.instance.collection('messages');

  void saveMessage(Message message) {
    messagesRef.add(message.toJson());
  }

  Stream<QuerySnapshot> streamMessages() {
    return messagesRef.orderBy('date').limit(20).snapshots();
  }

  Stream<Map?> streamUserDoc(String uid) {
    var docRef = FirebaseFirestore.instance.collection('users').doc(uid);
    return docRef.snapshots().map((snapshot) => snapshot.data());
  }
}
