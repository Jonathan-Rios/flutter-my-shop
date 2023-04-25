import 'package:my_shop/models/cart_item.dart';

class Order {
  final String id;
  final double total;
  final List<CartItem> products;
  final DateTime dateTime;

  Order({
    required this.id,
    required this.total,
    required this.products,
    required this.dateTime,
  });
}
