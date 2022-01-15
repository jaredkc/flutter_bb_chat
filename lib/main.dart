import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'auth/sign_in.dart';
import 'messages/message_list.dart';
import 'shared/error_screen.dart';
import 'shared/loading_screen.dart';

// TODO: Add autoDispose
final userProvider = StreamProvider<User?>(
  (ref) => FirebaseAuth.instance.authStateChanges(),
);

final dataProvider = StreamProvider<Map?>((ref) {
  final userStream = ref.watch(userProvider);

  var user = userStream.value;
  if (user != null) {
    // User is logged in, now get the user doc from Firestore.
    var docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    return docRef.snapshots().map((snapshot) => snapshot.data());
  } else {
    return const Stream.empty();
  }
});

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const LandingScreen(),
      theme: ThemeData(brightness: Brightness.light),
    );
  }
}

class LandingScreen extends ConsumerWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return user.when(
      data: (user) {
        return user == null ? const SignIn() : const MessageList();
      },
      error: (error, stackTrace) => ErrorScreen(error: error),
      loading: () => const LoadingScreen(),
    );
  }
}

class AccountDetails extends ConsumerWidget {
  const AccountDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(dataProvider);

    return data.when(
      data: (account) {
        return Text(account?['displayName'] ?? 'No account');
      },
      error: (error, stackTrace) => Text('$error'),
      loading: () => const Text('waiting...'),
    );
  }
}
