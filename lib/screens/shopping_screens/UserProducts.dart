import 'package:AN_shop_application/providers/shopping_providers/ProductsProviders.dart';
import 'package:AN_shop_application/screens/shopping_screens/EditingProductScreen.dart';
import 'package:AN_shop_application/widgets/shopping_widgets/OwnedByUserProductItemWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const String routename = '/UsersProductsScreen';
  @override
  Widget build(BuildContext context) {
    final _products = Provider.of<Products>(context);
    final _items = _products.items
        .where((element) =>
            element.ownerID == FirebaseAuth.instance.currentUser.uid)
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('My Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () =>
                Navigator.of(context).pushNamed(EditProductScreen.routeName),
          )
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) =>
            OwnedByUserProductItemWidget(_items[index]),
        itemCount: _items.length,
      ),
    );
  }
}
