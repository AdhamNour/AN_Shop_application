import 'package:AN_shop_application/providers/shopping_providers/OrdersProvider.dart';
import 'package:AN_shop_application/widgets/shopping_widgets/OrderWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  static const String routeName = '/OrderScreen';
  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);
    final oredersItems = orders.items;

    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        body: oredersItems.isEmpty
            ? Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.warning,
                      color: Colors.red,
                      size: 60,
                    ),
                    Text('No Orders Yet!')
                  ],
                  mainAxisSize: MainAxisSize.min,
                ),
              )
            : ListView.builder(
                itemBuilder: (context, index) =>
                    OrderWidget(oredersItems[index]),
                itemCount: oredersItems.length,
              ));
  }
}
