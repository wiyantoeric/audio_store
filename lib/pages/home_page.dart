import 'package:audio_store/database/supabase_controller.dart';
import 'package:audio_store/model/item.dart';
import 'package:audio_store/provider/cart_provider.dart';
import 'package:audio_store/widgets/item_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bool isLoggedIn;
  late VoidCallback profileHandler;
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    isLoggedIn = supabase.auth.currentSession != null &&
        supabase.auth.currentUser != null;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      profileHandler = isLoggedIn
          ? () => context.go('/settings')
          : () => context.go('/login');
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Column(
            children: [
              // Header
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Profile chip
                    InkWell(
                      onTap: () {
                        Logger().i(isLoggedIn);
                        profileHandler();
                      },
                      child: FittedBox(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: isLoggedIn
                              ? Row(
                                  children: [
                                    Text(supabase.auth.currentUser!.email!),
                                    const Icon(
                                      Icons.arrow_right,
                                    ),
                                  ],
                                )
                              : const Row(
                                  children: [
                                    Text("You are not logged in"),
                                    Icon(Icons.arrow_right),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    // Go to TransactionPage
                    Row(
                      children: [
                        // Cart
                        Badge(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          label: Text(
                            context
                                .watch<CartProvider>()
                                .cartItems
                                .length
                                .toString(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                          child: IconButton(
                            onPressed: () => context.go('/cart'),
                            icon: const Icon(Icons.shopping_cart),
                          ),
                        ),
                        IconButton(
                          onPressed: () => context.go('/transactions'),
                          icon: const Icon(Icons.receipt),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                flex: 8,
                child: FutureBuilder<List<Item?>?>(
                  future: getItems(),
                  builder: (context, snapshot) {
                    print(snapshot.data);
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            snapshot.error.toString(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        );
                      }

                      final items = snapshot.data as List<Item?>;

                      return ListView.separated(
                        itemCount: items.length,
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 24,
                        ),
                        itemBuilder: (context, index) {
                          final item = items[index]!;

                          return ItemCard(
                            item: item,
                            onClick: () => context.goNamed(
                              'item',
                              pathParameters: {'id': item.id.toString()},
                            ),
                          );
                        },
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
