import 'package:AN_shop_application/constant_and_enums.dart';
import 'package:AN_shop_application/models/shopping_models/product.dart';
import 'package:AN_shop_application/providers/shopping_providers/Cart.dart';
import 'package:AN_shop_application/providers/shopping_providers/FavoritesProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Consumer<Favorites> buildConsumer(BuildContext ctx, Product product) {
  return Consumer<Favorites>(
    builder: (__, value, _) => IconButton(
      icon: Icon(value.items.contains(product)
          ? Icons.favorite
          : Icons.favorite_border),
      onPressed: () {
        value.toggleItem(product);
        Scaffold.of(ctx).removeCurrentSnackBar();
        Scaffold.of(ctx).showSnackBar(SnackBar(
          content: Text(
              '${product.name} has been ${value.items.contains(product) ? 'added' : 'removed'} to your favorits'),
          action: SnackBarAction(
              label: 'UNDO', onPressed: () => value.toggleItem(product)),
        ));
      },
    ),
  );
}

void addToCart(BuildContext ctx, Product product) async {
  Provider.of<Cart>(ctx, listen: false).addItem(product);
  Scaffold.of(ctx).removeCurrentSnackBar();
  Scaffold.of(ctx).showSnackBar(SnackBar(
    content: Text('${product.name} has been added to your cart'),
    action: SnackBarAction(
        label: 'UNDO',
        onPressed: () => Provider.of<Cart>(ctx, listen: false)
            .decreaseAmountofItem(product: product)),
  ));
}
