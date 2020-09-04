import 'package:AN_shop_application/providers/shopping_providers/Cart.dart';
import 'package:AN_shop_application/models/shopping_models/cartItem.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  bool allowAmountChange;
  CartItemWidget(this.item, {bool allowamountchange}) {
    if (allowamountchange == null) {
      allowAmountChange = true;
      return;
    }
    allowAmountChange = allowamountchange;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      key: GlobalKey(),
      elevation: 6,
      child: Row(
        children: [
          Container(
            width: 70,
            child: CachedNetworkImage(
                  imageUrl: item.product.imageURL,
                  fit: BoxFit.fill,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error)),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  item.product.name,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Text('${item.amount} X ${item.product.price}\$'),
                SizedBox(
                  height: 5,
                ),
                Text(
                    'total price is ${(item.amount * item.product.price).toStringAsFixed(2)}')
              ],
            ),
          ),
          if (allowAmountChange)
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_left),
                  onPressed: () {
                    Provider.of<Cart>(context, listen: false)
                        .decreaseAmountofItem(cartItem: item);
                  },
                ),
                Text(item.amount.toString()),
                IconButton(
                  icon: Icon(Icons.arrow_right),
                  onPressed: () {
                    Provider.of<Cart>(context, listen: false)
                        .increaseAmountOfItem(item);
                  },
                )
              ],
            )
        ],
      ),
    );
  }
}
