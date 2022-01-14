import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/message.dart';

class MessageService {
  final CollectionReference messagesRef =
      FirebaseFirestore.instance.collection('messages');

  void saveMessage(Message message) {
    messagesRef.add(message.toJson());
  }

  Stream<QuerySnapshot> streamMessages() {
    return messagesRef.orderBy('date').limit(20).snapshots();
  }
}
