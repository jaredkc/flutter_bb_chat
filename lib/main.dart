import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/auth_service.dart';
import 'services/message_service.dart';
import 'auth/login.dart';
import 'messages/message_list.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(
          lazy: false,
          create: (_) => AuthService(),
        ),
        Provider<MessageService>(
          lazy: false,
          create: (_) => MessageService(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BB Chat',
        theme: ThemeData(primaryColor: const Color(0xFF191B2D)),
        home: Consumer<AuthService>(
          builder: (context, user, child) {
            return user.isLoggedIn() ? const MessageList() : const Login();
          },
        ),
      ),
    );
  }
}
