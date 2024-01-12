import 'package:audio_store/database/supabase_controller.dart';
import 'package:audio_store/model/cart_item.dart';
import 'package:audio_store/model/user_profile.dart';
import 'package:audio_store/provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  void initState() {
    if (Supabase.instance.client.auth.currentSession == null) {
      context.go('/login');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = context.read<CartProvider>().cartItems;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (context.read<CartProvider>().cartItems.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Cart is empty'),
              ),
            );
            return;
          }
          insertTransaction(
            uid: Supabase.instance.client.auth.currentUser!.id,
            itemIds:
                cartItems.map((CartItem cartItem) => cartItem.item.id).toList(),
            totalPrice: context.read<CartProvider>().totalPrice,
            qtys: cartItems.map((CartItem cartItem) => cartItem.qty).toList(),
          );
          context.read<CartProvider>().clearCart();
          context.go('/transaction/success');
        },
        label: const Text('Checkout'),
        icon: const Icon(Icons.shopping_cart),
      ),
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => context.go('/cart'),
                icon: Icon(Icons.arrow_back_outlined),
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: cartItems.length,
                  separatorBuilder: (context, index) => const Column(
                    children: [
                      SizedBox(height: 8),
                      Divider(),
                      SizedBox(height: 8),
                    ],
                  ),
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: Image.network(
                                    cartItems[index].item.imageUrl!),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cartItems[index].item.name,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Price',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge),
                                      Text('Qty',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'USD${cartItems[index].item.price.toString()}',
                                      ),
                                      Text(cartItems[index].qty.toString()),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Subtotal : USD${cartItems[index].subtotal}',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 8),
              Divider(),
              SizedBox(height: 8),
              // Shipping address
              InkWell(
                onTap: () => context.go('/settings'),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Shipping Address',
                              style: Theme.of(context).textTheme.labelLarge,
                              overflow: TextOverflow.ellipsis,
                            ),
                            FutureBuilder<UserProfile?>(
                              future: getUserProfile(
                                  uid: Supabase
                                      .instance.client.auth.currentUser!.id),
                              builder: (context, snapshot) {
                                if (ConnectionState.done ==
                                    snapshot.connectionState) {
                                  final userProfile =
                                      snapshot.data as UserProfile;
                                  if (userProfile.address == null ||
                                      userProfile.address == '') {
                                    return Text('No address');
                                  }

                                  return Text(userProfile.address!);
                                } else {
                                  return Text('Loading...');
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12),
              // Payment method (not implemented)
              InkWell(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).colorScheme.surface,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Payment Method',
                              style: Theme.of(context).textTheme.labelLarge,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Master Card'),
                                Text(
                                  '4544********',
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
