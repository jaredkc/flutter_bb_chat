// TODO: Add autoDispose
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firestore_service.dart';

final userProvider = StreamProvider<User?>(
  (ref) => FirebaseAuth.instance.authStateChanges(),
);

final dataProvider = StreamProvider<Map?>((ref) {
  final userStream = ref.watch(userProvider);

  var user = userStream.value;
  if (user != null) {
    return FirestoreService().streamUserDoc(user.uid);
  } else {
    return const Stream.empty();
  }
});
