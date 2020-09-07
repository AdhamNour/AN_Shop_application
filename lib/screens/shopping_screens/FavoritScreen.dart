import 'package:AN_shop_application/providers/shopping_providers/FavoritesProvider.dart';
import 'package:AN_shop_application/widgets/shopping_widgets/productItemWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatelessWidget {
  static const String routeName = '/FavoritesScreen';
  @override
  Widget build(BuildContext context) {
    final _items = Provider.of<Favorites>(context).items;
    return Scaffold(
      appBar: AppBar(title: Text('Your Favorite')),
      body: _items.length == 0
          ? Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.favorite_border,
                      color: Colors.red,
                      size: 60,
                    ),
                    Text('No Favorites added Yet!')
                  ],
                  mainAxisSize: MainAxisSize.min,
                ),
              )
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 16 / 9,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5),
              itemBuilder: (context, index) =>
                  ProductItemWidget(_items[index], false),
              itemCount: _items.length,
            ),
    );
  }
}
