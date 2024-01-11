import 'package:audio_store/model/item.dart';

class CartItem {
  Item item;
  int qty;
  double subtotal;

  CartItem({
    required this.item,
    required this.qty,
  }) : subtotal = item.price * qty;
}
