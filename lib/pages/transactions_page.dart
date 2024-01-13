import 'package:audio_store/database/supabase_controller.dart';
import 'package:audio_store/model/transaction.dart';
import 'package:audio_store/widgets/transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    context.go('/');
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                Expanded(
                  child: Supabase.instance.client.auth.currentSession == null
                      ? Align(
                          alignment: Alignment.center,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Please login to view your transactions',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 8),
                              FilledButton(
                                onPressed: () => context.go('/login'),
                                child: const Text('Login'),
                              ),
                            ],
                          ),
                        )
                      : FutureBuilder(
                          future: getTransactions(
                              uid: Supabase
                                  .instance.client.auth.currentUser!.id),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final transactions = snapshot.data as List;
                              final itemIds = [];
                              for (Transaction t in transactions) {
                                itemIds.addAll(t.itemIds);
                              }

                              return transactions.isEmpty
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'You have no transaction',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                          const SizedBox(height: 8),
                                          ElevatedButton(
                                            onPressed: () => context.go('/'),
                                            child: const Text('Browse item'),
                                          ),
                                        ],
                                      ),
                                    )
                                  : ListView.separated(
                                      itemCount: transactions.length,
                                      separatorBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            const SizedBox(height: 8),
                                            Divider(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .outline),
                                            const SizedBox(height: 8),
                                          ],
                                        );
                                      },
                                      itemBuilder: (context, index) {
                                        return TransactionCard(
                                          transaction: transactions[index],
                                        );
                                      });
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
