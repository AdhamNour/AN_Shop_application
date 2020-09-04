import 'package:flutter/material.dart';

import '../../constant_and_enums.dart';

class PaymentChoiceWidget extends StatefulWidget {
  final void Function(PaymentMethod) setChoice;
  PaymentChoiceWidget(this.setChoice);
  @override
  _PaymentChoiceWidgetState createState() => _PaymentChoiceWidgetState();
}

class _PaymentChoiceWidgetState extends State<PaymentChoiceWidget> {
  PaymentMethod selected = PaymentMethod.nochoice;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RadioListTile(
          value: PaymentMethod.payOnDelevery,
          groupValue: selected,
          onChanged: (value) {
            setState(() {
              selected = value;
              widget.setChoice(value);
            });
          },
          title: Text('cash on delviry'),
        ),
        RadioListTile(
          value: PaymentMethod.VISA,
          groupValue: selected,
          onChanged: (value) {
            setState(() {
              selected = value;
              widget.setChoice(value);
            });
          },
          title: Text('VISA'),
        )
      ],
    );
  }
}
