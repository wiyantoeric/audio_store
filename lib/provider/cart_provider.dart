import 'package:audio_store/model/cart_item.dart';
import 'package:flutter/foundation.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  int get totalItems => _cartItems.length;

// add totalPrice getter
  double get totalPrice =>
      _cartItems.fold(0.0, (sum, item) => sum + item.subtotal);

  // void initCart() async {
  //   _cartItems = await _cloudCartItems as List<CartItem>;
  //   if (_cartItems.isNotEmpty)
  //     totalPrice = _cartItems.fold(0.0, (sum, item) => sum + item.subtotal);
  //   // if (cartItems != null && cartItems.isNotEmpty) {
  //   //   _cartItems = cartItems.map((e) => e!).toList();
  //   // }
  //   notifyListeners();
  // }

  void addToCart(CartItem cartItem) {
    _cartItems.add(cartItem);
    // insertCardItem(
    //   itemId: cartItem.item.id,
    //   qty: cartItem.qty,
    //   subtotal: cartItem.subtotal,
    // );
    notifyListeners();
  }

  void removeFromCart({required CartItem cartItem}) {
    _cartItems.remove(cartItem);
    notifyListeners();
  }

  void updateCart({required CartItem cartItem, required int index}) {
    print(_cartItems[index].item.name);
    print(_cartItems[index].subtotal);
    _cartItems[index] = cartItem;
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
