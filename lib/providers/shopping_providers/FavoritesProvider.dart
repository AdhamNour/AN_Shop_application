import 'package:AN_shop_application/constant_and_enums.dart';
import 'package:AN_shop_application/models/shopping_models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Favorites with ChangeNotifier {
  List<Product> _items = [];
  List<Product> get items {
    return [..._items];
  }

  void set items(List<Product> inItems) {
    _items = inItems;
    notifyListeners();
  }

  void toggleItem(Product item) {
    final wasExist = _items.remove(item);
    if (!wasExist) {
      _items.add(item);
    }
    FirebaseFirestore.instance
        .collection(UsersCollection)
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({
      USER_FAVORITE: [..._items.map((e) => e.id).toList()]
    });
    notifyListeners();
  }
}
