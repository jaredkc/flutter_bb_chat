import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../services/auth_service.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget(this.message, this.date, this.email, {Key? key})
      : super(key: key);

  final String message;
  final DateTime date;
  final String? email;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final authDao = Provider.of<AuthService>(context, listen: false);
    final myEmail = authDao.email();

    final isMe = email != null && email == myEmail;

    return ListTile(
      dense: true,
      minVerticalPadding: 16,
      leading: !isMe
          ? CircleAvatar(
              backgroundColor: Colors.blue[500],
              child: Text('${email?.substring(0, 2).toUpperCase()}'),
            )
          : null,
      trailing: isMe
          ? CircleAvatar(
              backgroundColor: Colors.blue[50],
              child: Text('${myEmail?.substring(0, 2).toUpperCase()}'),
            )
          : null,
      title: Column(
        children: [
          Container(
              width: double.infinity,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey[350]!,
                      blurRadius: 2.0,
                      offset: const Offset(0, 1.0))
                ],
                borderRadius: BorderRadius.circular(8.0),
                color: isMe ? Colors.blue[50] : Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Wrap(
                  children: <Widget>[Text(message)],
                ),
              )),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (!isMe) ...[
                Text(
                  email!,
                  style: textTheme.caption,
                ),
              ],
              const Spacer(),
              Text(
                timeago.format(date),
                style: textTheme.caption,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
