import 'package:AN_shop_application/constant_and_enums.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class SellerWidget extends StatefulWidget {
  final String id;
  final Function onTap;
  SellerWidget(this.id, {this.onTap});

  @override
  _SellerWidgetState createState() => _SellerWidgetState();
}

class _SellerWidgetState extends State<SellerWidget> {
  String userName='', imageURL ;

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection(UsersCollection)
        .doc(widget.id)
        .get()
        .then((value) {
      userName = value.data()[UserName];
      imageURL = value.data()[USER_IMAGE];
      setState(() {
        
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: 50,
        width: 50,
        child: imageURL != null
            ? CachedNetworkImage(
                imageUrl: imageURL,
                height: 50,
                width: 50,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                imageBuilder: (context, imageProvider) => CircleAvatar(
                  backgroundImage: imageProvider,
                  radius: 50,
                ),

              )
            : Container(),
      ),
          title: Text(userName),
          onTap: widget.onTap,
    );
  }
}
