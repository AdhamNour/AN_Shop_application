import 'package:AN_shop_application/constant_and_enums.dart';
import 'package:AN_shop_application/providers/chatting_providers/message.dart';
import 'package:AN_shop_application/widgets/Seller.dart';
import 'package:AN_shop_application/widgets/chatting_widgets/MessageBubble.dart';
import 'package:AN_shop_application/widgets/chatting_widgets/MessageEditing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessagesScreen extends StatelessWidget {
  static const String routeName = '/MessageScreen';
  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: SellerWidget(data),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(UsersCollection)
                .doc(FirebaseAuth.instance.currentUser.uid)
                .collection(USER_MESSAGES).orderBy(MESSAGE_TIMESTAMP)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text('loading');
              }
              if (snapshot.hasError) {
                return Text('error');
              }
              List<Message> ourMessages =
                  List<Message>.generate(snapshot.data.docs.length, (index) {
                if (snapshot.data.docs[index].data()[MESSAGE_RECIVER_ID] ==
                        data ||
                    snapshot.data.docs[index].data()[MESSAGE_SENDER_ID] ==
                        data) {
                  return Message(
                      snapshot.data.docs[index].data()[MESSAGE_SENDER_ID],
                      snapshot.data.docs[index].data()[MESSAGE_RECIVER_ID],
                      snapshot.data.docs[index].data()[MESSAGE_CONTENT]);
                }
                return null;
              });

              return ListView.builder(
                itemBuilder: (context, index) {
                  if (ourMessages[index] == null) {
                    return Container();
                  }
                  var isMe = ourMessages[index].sender ==
                      FirebaseAuth.instance.currentUser.uid;
                  print(ourMessages[index].content);
                  print(ourMessages[index].sender);
                  print(FirebaseAuth.instance.currentUser.uid);
                  print(isMe);


                  

                  return MessageBubble(ourMessages[index],key: GlobalKey(),) ;
                },
                itemCount: ourMessages.length,
              );
            },
          )),
          MessageTyping(data: data)
        ],
      ),
    );
  }
}
