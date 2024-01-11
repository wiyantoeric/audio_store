import 'package:audio_store/database/supabase_controller.dart';
import 'package:audio_store/model/cart.dart';
import 'package:audio_store/model/item.dart';
import 'package:audio_store/provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddToCart extends StatefulWidget {
  const AddToCart({super.key, required this.id});

  final int id;

  @override
  State<AddToCart> createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {
  late final Item item;
  final _supabase = Supabase.instance.client;
  final _qtyController = TextEditingController(text: '1');

  @override
  void initState() {
    // if (_supabase.auth.currentSession == null) {
    //   context.go('/login');
    // }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<Item?>(
          future: getItem(id: widget.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              item = snapshot.data!;
              return ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: IconButton(
                          onPressed: () => context.go('/'),
                          icon: const Icon(Icons.arrow_back),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: 24,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(36),
                                child: Image.network(
                                  item.imageUrl!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'USD ${item.price.toString()}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                    SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            controller: _qtyController,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              labelText: 'Quantity',
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        FilledButton(
                                          onPressed: () {
                                            // Add item(s) into cart
                                            context
                                                .read<CartProvider>()
                                                .addToCart(
                                                  CartItem(
                                                    item: item,
                                                    qty: int.parse(
                                                      _qtyController.text,
                                                    ),
                                                  ),
                                                );

                                            // Go to CartPage
                                            context.go('/cart');
                                          },
                                          child: Text('Add to Cart'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                      SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Item Summary',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Name',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          Text(item.name),
                          SizedBox(height: 8),
                          Text(
                            'Price',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          Text('USD ${item.price.toString()}'),
                          SizedBox(height: 8),
                          Text(item.desc),
                        ],
                      ),
                      SizedBox(height: 16),
                      Divider(),
                    ],
                  ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
