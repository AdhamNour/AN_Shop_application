import 'package:AN_shop_application/screens/messagesScreen.dart';
import 'package:AN_shop_application/widgets/Seller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constant_and_enums.dart';

class ChatScreen extends StatelessWidget {
  static const String routeName = '/ChatScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Chats'),
      ),
      body: StreamBuilder(
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          Set<String> reciverIDs = new Set();
          snapshot.data.docs.forEach((element) {
            reciverIDs.add(element.data()[MESSAGE_RECIVER_ID]);
            reciverIDs.add(element.data()[MESSAGE_SENDER_ID]);
          });
          reciverIDs.remove(FirebaseAuth.instance.currentUser.uid);
          var reciverIDsList = reciverIDs.toList();
          return ListView.builder(
            itemBuilder: (context, index) =>
                SellerWidget(reciverIDsList[index],onTap: () => Navigator.of(context).pushNamed(MessagesScreen.routeName,arguments: reciverIDsList[index]),),
            itemCount: reciverIDsList.length,
          );
        },
        stream: FirebaseFirestore.instance
            .collection(UsersCollection)
            .doc(FirebaseAuth.instance.currentUser.uid)
            .collection(USER_MESSAGES)
            .orderBy(MESSAGE_TIMESTAMP)
            .snapshots(),
      ),
    );
  }
}
