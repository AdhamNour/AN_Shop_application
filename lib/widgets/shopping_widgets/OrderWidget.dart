import 'package:AN_shop_application/constant_and_enums.dart';
import 'package:AN_shop_application/models/shopping_models/Order.dart';
import 'package:AN_shop_application/widgets/shopping_widgets/cartItemWidget.dart';
import 'package:flutter/material.dart';

class OrderWidget extends StatefulWidget {
  final Order order;
  OrderWidget(this.order);
  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  bool _expanding = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Text('\$${widget.order.totalPrice}'),
          leading: Icon(widget.order.paymentMethod == PaymentMethod.VISA
              ? Icons.payment
              : Icons.attach_money),
          subtitle: Text(widget.order.requestDate.toString()),
          trailing: IconButton(
              icon: Icon(_expanding ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanding = !_expanding;
                });
              }),
        ),
        if (_expanding)
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.only(left: 50),
            height: 210,
            child: ListView.builder(
              itemBuilder: (context, index) => CartItemWidget(
                widget.order.orderdItems[index],
                allowamountchange: false,
              ),
              itemCount: widget.order.orderdItems.length,
            ),
          )
      ],
    );
  }
}
