import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'auth/sign_in.dart';
import 'messages/message_list.dart';
import 'shared/error_screen.dart';
import 'shared/loading_screen.dart';

final userProvider = StreamProvider<User?>(
  (ref) => FirebaseAuth.instance.authStateChanges(),
);

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
