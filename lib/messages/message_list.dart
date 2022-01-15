import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/message_service.dart';
import '../models/message.dart';
import '../services/auth_service.dart';
import 'message_field.dart';
import 'message_widget.dart';

class MessageList extends StatefulWidget {
  const MessageList({Key? key}) : super(key: key);

  @override
  MessageListState createState() => MessageListState();
}

class MessageListState extends State<MessageList> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) => _scrollToBottom());

    final messages = MessageService();
    final auth = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('BBChat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.login),
            onPressed: () {
              auth.signOut();
            },
          ),
        ],
      ),
      bottomNavigationBar: const BottomAppBar(
        child: Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: MessageField(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _getMessageList(messages),
          ],
        ),
      ),
    );
  }

  Widget _getMessageList(MessageService messages) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
          stream: messages.streamMessages(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return _buildList(context, snapshot.data!.docs);
          }),
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot>? snapshot) {
    return ListView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot!.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
    final message = Message.fromSnapshot(snapshot);

    return MessageWidget(
      message.text,
      message.date,
      message.email,
    );
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }
}
