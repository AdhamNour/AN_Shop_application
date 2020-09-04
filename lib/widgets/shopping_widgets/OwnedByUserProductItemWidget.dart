import 'package:AN_shop_application/constant_and_enums.dart';
import 'package:AN_shop_application/models/shopping_models/product.dart';
import 'package:AN_shop_application/screens/shopping_screens/EditingProductScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class OwnedByUserProductItemWidget extends StatelessWidget {
  final Product product;
  OwnedByUserProductItemWidget(this.product);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(product.imageURL),
          radius: 30,
        ),
        title: Text(product.name),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.cyan,
              ),
              onPressed: () => Navigator.of(context)
                  .pushNamed(EditProductScreen.routeName, arguments: product),
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () => FirebaseFirestore.instance
                  .collection(PRODUCTS)
                  .doc(product.id)
                  .delete(),
            )
          ],
        ),
      ),
    );
  }
}
