import 'package:audio_store/database/supabase_controller.dart';
import 'package:audio_store/model/item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ItemPage extends StatelessWidget {
  const ItemPage({required this.id, super.key});
  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          FutureBuilder(
            future: getItem(id: id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final item = snapshot.data as Item;
                return Column(
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
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'USD ${item.price.toString()}',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                const SizedBox(height: 8),
                                Text(item.desc,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge),
                              ],
                            ),
                          ),
                          FilledButton.tonal(
                            onPressed: () {
                              context.goNamed('add_to_cart', pathParameters: {
                                'id': item.id.toString(),
                              });
                            },
                            child: const Text('Order now'),
                          ),
                        ],
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(72),
                      child: Image.network(
                        snapshot.data!.imageUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
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
        ],
      ),
    ));
  }
}
