import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/message.dart';
import '../models/user_doc.dart';

class FirestoreService {
  final CollectionReference messagesRef =
      FirebaseFirestore.instance.collection('messages');

  void saveMessage(Message message) {
    messagesRef.add(message.toJson());
  }

  Stream<QuerySnapshot> streamMessages() {
    return messagesRef.orderBy('date').limit(20).snapshots();
  }

  Stream<UserDoc> streamUserDoc(String uid) {
    var docRef = FirebaseFirestore.instance.collection('users').doc(uid);
    return docRef.snapshots().map((snapshot) {
      if (snapshot.exists) {
        // print('Document data: ${snapshot.data()}');
        return UserDoc.fromJson(snapshot.data()!);
      } else {
        // print('Document does not exist on the database');
        return UserDoc.fromJson({});
      }
    });
  }
}
