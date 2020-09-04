import 'package:AN_shop_application/constant_and_enums.dart';
import 'package:AN_shop_application/models/shopping_models/cartItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../models/shopping_models/Order.dart';

class Orders with ChangeNotifier {
  List<Order> _items = [];
  List<Order> get items {
    return [..._items];
  }
  void set items(List<Order> inItems){
    _items=inItems;
    notifyListeners();
  }

  void addOrder(List<CartItem> cartItems, PaymentMethod paymentMethod,
      DateTime requestDate, double totalPrice) {
    FirebaseFirestore.instance
        .collection(UsersCollection)
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection(USER_ORDERS)
        .add({
      USER_OREDER_ITEMS: Map<String, int>.fromIterable(
        cartItems,
        key: (element) => element.product.id,
        value: (element) => element.amount,
      ),
      USER_ORDER_TOTAL_PRICE : totalPrice,
      USER_ORDER_PAYMENT_METHOD:paymentMethod.index,
      USER_ORDER_DATE : requestDate.toIso8601String(),

    });
    _items.add(Order(cartItems, paymentMethod, requestDate, totalPrice));
    notifyListeners();
    
  }
}
