import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class Product {
  String name, id, description, imageURL, ownerID;
  double price;
  Product(
      {@required this.name,
      @required this.imageURL,
      @required this.id,
      @required this.description,
      @required this.price,
      @required this.ownerID});
}
