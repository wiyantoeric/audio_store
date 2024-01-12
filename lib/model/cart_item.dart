import 'package:audio_store/model/item.dart';

class CartItem {
  int? id;
  Item item;
  int qty;
  double subtotal;

  CartItem({
    required this.item,
    required this.qty,
    required this.subtotal,
  });
}
