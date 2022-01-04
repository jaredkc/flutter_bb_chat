import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../data/message.dart';
import '../data/message_dao.dart';
import '../data/user_dao.dart';

class MessageField extends StatefulWidget {
  const MessageField({Key? key}) : super(key: key);

  @override
  _MessageFieldState createState() => _MessageFieldState();
}

class _MessageFieldState extends State<MessageField> {
  final TextEditingController _messageController = TextEditingController();
  String? email;
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
    final messageDao = Provider.of<MessageDao>(context, listen: false);
    final userDao = Provider.of<UserDao>(context, listen: false);
    email = userDao.email();

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
              _sendMessage(messageDao);
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
                  _sendMessage(messageDao);
                }
              : null,
        ),
        const SizedBox(width: 6),
      ],
    );
  }

  void _sendMessage(MessageDao messageDao) {
    if (_canSendMessage()) {
      final message = Message(
        text: _messageController.text,
        date: DateTime.now(),
        email: email,
      );
      messageDao.saveMessage(message);
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
