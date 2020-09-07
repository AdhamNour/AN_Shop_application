import 'package:AN_shop_application/constant_and_enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageTyping extends StatelessWidget {
  const MessageTyping({
    Key key,
    @required this.data,
  }) : super(key: key);

  final String data;

  @override
  Widget build(BuildContext context) {
    final _controller = TextEditingController();
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(hintText: 'your message'),
            controller: _controller,
          ),
        ),
        IconButton(
            icon: Icon(Icons.send),
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection(UsersCollection)
                  .doc(FirebaseAuth.instance.currentUser.uid)
                  .collection(USER_MESSAGES)
                  .add({
                MESSAGE_SENDER_ID: FirebaseAuth.instance.currentUser.uid,
                MESSAGE_RECIVER_ID: data,
                MESSAGE_CONTENT: _controller.text,
                MESSAGE_TIMESTAMP: DateTime.now().toIso8601String(),
              });
              await FirebaseFirestore.instance
                  .collection(UsersCollection)
                  .doc(data)
                  .collection(USER_MESSAGES)
                  .add({
                MESSAGE_SENDER_ID: FirebaseAuth.instance.currentUser.uid,
                MESSAGE_RECIVER_ID: data,
                MESSAGE_CONTENT: _controller.text,
                MESSAGE_TIMESTAMP: DateTime.now().toIso8601String(),
              });
              _controller.text = '';
            })
      ],
    );
  }
}
