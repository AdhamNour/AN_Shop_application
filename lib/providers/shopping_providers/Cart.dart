import 'package:AN_shop_application/models/shopping_models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

import '../../constant_and_enums.dart';
import '../../models/shopping_models/cartItem.dart';

class Cart with ChangeNotifier {
  List<CartItem> _items = [];
  List<CartItem> get items {
    return [..._items];
  }

  void set items(List<CartItem> inItems) {
    _items = inItems;
    notifyListeners();
  }

  void addItem(Product product, {int amount = 1}) async {
    final index =
        _items.indexWhere((element) => element.product.id == product.id);
    await Firebase.initializeApp();

    if (index == -1) {
      _items.add(CartItem(product, amount));
      await FirebaseFirestore.instance
          .collection(UsersCollection)
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection(USER_CART)
          .doc(product.id)
          .set({CART_ITEM_AMOUNT: amount});
    } else {
      _items[index].amount += amount;
      await FirebaseFirestore.instance
          .collection(UsersCollection)
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection(USER_CART)
          .doc(product.id)
          .update({CART_ITEM_AMOUNT: _items[index].amount});
    }
    notifyListeners();
  }

  void removeItem(CartItem item) async {
    _items.remove(item);
    await FirebaseFirestore.instance
        .collection(UsersCollection)
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection(USER_CART)
        .doc(item.product.id)
        .delete();
    notifyListeners();
  }

  double get totalPrice {
    double sum = 0;
    for (int i = 0; i < _items.length; i++) {
      sum += _items[i].amount * _items[i].product.price;
    }
    return sum;
  }

  void decreaseAmountofItem({CartItem cartItem, Product product}) async {
    await Firebase.initializeApp();
    if (cartItem != null && product != null) {
      throw Exception('one of cartItem or Product must be null ');
    }
    final index = cartItem != null
        ? _items.indexOf(cartItem)
        : _items.indexWhere((element) => element.product == product);
    _items[index].amount--;
    final id = _items[index].product.id;
    if (_items[index].amount == 0) {
      _items.removeAt(index);
      await FirebaseFirestore.instance
          .collection(UsersCollection)
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection(USER_CART)
          .doc(id)
          .delete();
    } else {
      await FirebaseFirestore.instance
          .collection(UsersCollection)
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection(USER_CART)
          .doc(id)
          .update({CART_ITEM_AMOUNT: _items[index].amount});
    }
    notifyListeners();
  }

  void increaseAmountOfItem(CartItem cartItem) async {
    final index = _items.indexOf(cartItem);
    _items[index].amount++;
    await FirebaseFirestore.instance
        .collection(UsersCollection)
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection(USER_CART)
        .doc(cartItem.product.id)
        .update({CART_ITEM_AMOUNT: _items[index].amount});
    notifyListeners();
  }

  void clear() async {
    for (int i = 0; i < _items.length; i++) {
      await FirebaseFirestore.instance
          .collection(UsersCollection)
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection(USER_CART)
          .doc(_items[i].product.id)
          .delete();
    }
    _items = [];
    notifyListeners();
  }
}
