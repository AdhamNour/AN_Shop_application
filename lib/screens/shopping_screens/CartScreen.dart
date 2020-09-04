import 'package:AN_shop_application/models/shopping_models/cartItem.dart';
import 'package:AN_shop_application/providers/shopping_providers/OrdersProvider.dart';
import 'package:AN_shop_application/widgets/shopping_widgets/PaymentChoiceWidget.dart';
import 'package:AN_shop_application/widgets/shopping_widgets/cartItemWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/shopping_providers/Cart.dart';
import '../../constant_and_enums.dart';

class CartScreen extends StatelessWidget {
  static const String routeName = '/CartScreen';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final items = cart.items;
    final totalPrice = cart.totalPrice;

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: items.length < 1
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    radius: 50,
                    child: Icon(
                      Icons.shopping_basket,
                      size: 70,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('empty cart! start shopping'),
                  )
                ],
              ),
            )
          : CartScreenContent(
              items: items,
              totalPrice: totalPrice,
            ),
    );
  }
}

class CartScreenContent extends StatelessWidget {
  const CartScreenContent({
    Key key,
    @required this.items,
    @required this.totalPrice,
  }) : super(key: key);

  final List<CartItem> items;
  final double totalPrice;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return CartItemWidget(items[index]);
            },
            itemCount: items.length,
          ),
        ),
        Row(
          children: [
            Expanded(child: Text('Total Price:')),
            Chip(label: Text(totalPrice.toStringAsFixed(2)))
          ],
        ),
        RaisedButton.icon(
            onPressed: () {
              PaymentMethod selected = PaymentMethod.nochoice;
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('please choose your payment method'),
                  content: PaymentChoiceWidget((x) => selected = x),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          if (selected == PaymentMethod.nochoice) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('select a payment method plese'),
                                actions: [
                                  FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('O.K.'))
                                ],
                              ),
                            );
                            return;
                          }
                          Navigator.of(context).pop(selected);
                        },
                        child: Text('submet'))
                  ],
                ),
              ).then((value) {
                if (value == PaymentMethod.nochoice || value == null) {
                  return;
                }
                Provider.of<Orders>(context, listen: false)
                    .addOrder(items, value, DateTime.now(), totalPrice);
                Provider.of<Cart>(context, listen: false).clear();
              });
            },
            icon: Icon(Icons.shopping_cart),
            label: Text('proceed to check out'))
      ],
    );
  }
}
