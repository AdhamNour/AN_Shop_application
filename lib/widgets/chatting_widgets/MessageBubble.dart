import 'package:AN_shop_application/constant_and_enums.dart';
import 'package:AN_shop_application/providers/chatting_providers/message.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';

class MessageBubble extends StatefulWidget {
  final Message message;
  MessageBubble(this.message , {Key key}):super(key: key);
  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  String imageURL;
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection(UsersCollection)
        .doc(widget.message.sender)
        .get()
        .then((value) => setState(() => imageURL = value.data()[USER_IMAGE]));
  }

  @override
  Widget build(BuildContext context) {
    bool isMe = widget.message.sender == FirebaseAuth.instance.currentUser.uid;

    var x = ChatBubble(
      clipper: ChatBubbleClipper1(
          type: isMe ? BubbleType.sendBubble : BubbleType.receiverBubble),
      child: Text(widget.message.content),
    );
    var y = imageURL != null
        ? CachedNetworkImage(
            imageUrl: imageURL,
            placeholder: (context, url) => CircularProgressIndicator(),
            imageBuilder: (context, imageProvider) => CircleAvatar(
              backgroundImage: imageProvider,
              radius: 25,
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          )
        : Container();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: isMe?MainAxisAlignment.end:MainAxisAlignment.start,
        children: [
          isMe ? x : y,
          isMe ? y : x,
        ],
      ),
    );
  }
}
