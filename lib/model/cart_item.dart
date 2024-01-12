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

  CartItem.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        item = Item.fromJson(json['item']),
        qty = json['qty'],
        subtotal = json['subtotal'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'item': item.toJson(),
        'qty': qty,
        'subtotal': subtotal,
      };
}
