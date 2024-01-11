import 'package:audio_store/database/supabase_controller.dart';
import 'package:audio_store/model/item.dart';
import 'package:audio_store/widgets/item_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    isLoggedIn = supabase.auth.currentSession != null;
    profileHandler =
        isLoggedIn ? () => context.go('/settings') : () => context.go('/login');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: profileHandler,
                    child: FittedBox(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
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
                                  Text("You have not logged in"),
                                  Icon(
                                    Icons.arrow_right,
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.go('/transactions'),
                    icon: Icon(Icons.receipt),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
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

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: ItemCard(
                            item: item,
                            onClick: () => context.goNamed(
                              'item',
                              pathParameters: {'id': item.id.toString()},
                            ),
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
    );
  }
}
