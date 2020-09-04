import 'package:AN_shop_application/providers/shopping_providers/ProductsProviders.dart';
import 'package:AN_shop_application/screens/shopping_screens/CartScreen.dart';
import 'package:AN_shop_application/screens/shopping_screens/FavoritScreen.dart';
import 'package:AN_shop_application/widgets/shopping_widgets/drawer.dart';
import 'package:AN_shop_application/widgets/shopping_widgets/productItemWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class ProductsScreen extends StatelessWidget {
  static const String routeName = '/ProductsScreen';
  @override
  Widget build(BuildContext context) {
    final _products = Provider.of<Products>(context);
    final _items = _products.items;
    return Scaffold(
      drawer: ANAppDrawer(),
      appBar: AppBar(
        title: Text('Product Screen'),
        actions: [
          Builder(
            builder: (context) => IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                          'search feature would be implemented , stay tuned')));
                }),
          ),
          IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () {
                Navigator.of(context).pushNamed(FavoritesScreen.routeName);
              }),
          IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              })
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => ProductItemWidget(_items[index], true),
        itemCount: _items.length,
      ),
    );
  }
}
