import 'package:audio_store/model/cart_item.dart';
import 'package:audio_store/provider/cart_provider.dart';
import 'package:audio_store/widgets/cart_item_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:logger/logger.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late List<CartItem?>? cartItemsState;

  @override
  Widget build(BuildContext context) {
    Logger().i(context.watch<CartProvider>().totalPrice);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      bottomNavigationBar: BottomAppBar(
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              'Total: ${context.watch<CartProvider>().totalPrice}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: IconButton(
                onPressed: () => context.go('/'),
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            Expanded(child:
                Consumer<CartProvider>(builder: (context, cartProvider, child) {
              final cartItems = cartProvider.cartItems;
              return ListView.separated(
                itemCount: cartItems.length,
                separatorBuilder: (context, index) => const Column(
                  children: [
                    SizedBox(height: 16),
                    Divider(),
                    SizedBox(height: 16),
                  ],
                ),
                itemBuilder: (context, index) {
                  final cartItem = cartItems[index];

                  return CartItemCard(
                    index: index,
                    cartItem: cartItem,
                    onRemove: () {
                      // await deleteCartItem(id: cartItem.itemId);
                      context
                          .read<CartProvider>()
                          .removeFromCart(cartItem: cartItem);
                    },
                    onQtyChange: null,
                  );
                },
              );
            })),
          ],
        ),
      ),
    );
  }
}
