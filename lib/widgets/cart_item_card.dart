import 'package:audio_store/model/cart_item.dart';
import 'package:audio_store/provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CartItemCard extends StatefulWidget {
  const CartItemCard({
    super.key,
    required this.index,
    required this.cartItem,
    required this.onRemove,
    required this.onQtyChange,
  });

  final int index;
  final CartItem cartItem;
  final VoidCallback? onRemove;
  final VoidCallback? onQtyChange;

  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard> {
  late final _qtyController =
      TextEditingController(text: widget.cartItem.qty.toString());

  void updateQtyValue({required int value}) {
    final qty = value;
    context.read<CartProvider>().updateCart(
          cartItem: widget.cartItem
            ..qty = qty
            ..subtotal = qty * widget.cartItem.item.price,
          index: widget.index,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        IconButton(
          onPressed: widget.onRemove,
          icon: const Icon(Icons.close),
        ),
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.network(
                      widget.cartItem.item.imageUrl!,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.cartItem.item.name),
                      Text(widget.cartItem.item.desc),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 64,
                        child: TextFormField(
                          controller: _qtyController,
                          onTapOutside: (_) {
                            FocusScope.of(context).unfocus();
                            if (_qtyController.text.isEmpty) {
                              _qtyController.text = '1';
                            } else if (int.parse(_qtyController.text) <= 0) {
                              widget.onRemove!();
                              return;
                            }
                            updateQtyValue(
                                value: int.parse(_qtyController.text));
                          },
                          onFieldSubmitted: (_) {
                            if (_qtyController.text.isEmpty) {
                              _qtyController.text = '1';
                            } else if (int.parse(_qtyController.text) <= 0) {
                              widget.onRemove!();
                              return;
                            }

                            updateQtyValue(
                                value: int.parse(_qtyController.text));
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text('@ USD ${widget.cartItem.item.price.toString()}'),
                    ],
                  ),
                  Column(
                    children: [
                      const Text('Total'),
                      Text(
                        'USD ${context.watch<CartProvider>().cartItems[widget.index].subtotal}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}
