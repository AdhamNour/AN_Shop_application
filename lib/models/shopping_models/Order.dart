import '../../constant_and_enums.dart';
import 'cartItem.dart';

class Order {
  List<CartItem> orderdItems;
  PaymentMethod paymentMethod;
  DateTime requestDate;
  double totalPrice;
  Order(
      this.orderdItems, this.paymentMethod, this.requestDate, this.totalPrice);
}
