import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../models/message.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';

class MessageField extends StatefulWidget {
  const MessageField({Key? key}) : super(key: key);

  @override
  _MessageFieldState createState() => _MessageFieldState();
}

class _MessageFieldState extends State<MessageField> {
  final TextEditingController _messageController = TextEditingController();
  String? message;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_messageUpdate);
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 16),
        Flexible(
          child: TextField(
            keyboardType: TextInputType.text,
            controller: _messageController,
            autofocus: true,
            onSubmitted: (input) {
              _sendMessage();
            },
            decoration: const InputDecoration(
              hintText: 'Your message...',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(CupertinoIcons.arrow_up_circle),
          color: Colors.blue,
          disabledColor: Colors.grey[400],
          onPressed: _canSendMessage()
              ? () {
                  _sendMessage();
                }
              : null,
        ),
        const SizedBox(width: 6),
      ],
    );
  }

  void _sendMessage() {
    final messages = FirestoreService();
    final auth = AuthService();

    if (_canSendMessage()) {
      final message = Message(
        text: _messageController.text,
        date: DateTime.now(),
        email: auth.email(),
      );
      messages.saveMessage(message);
      _messageController.clear();
      setState(() {});
    }
  }

  void _messageUpdate() {
    setState(() {
      message = _messageController.text;
    });
  }

  bool _canSendMessage() => _messageController.text.isNotEmpty;
}
