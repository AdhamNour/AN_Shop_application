import 'package:AN_shop_application/models/shopping_models/product.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  void set items(List<Product> inProducts) {
    _items = inProducts;
    notifyListeners();
  }

  Product getProductByID(String id) {
    return _items.firstWhere((element) => element.id == id);
  }
}
