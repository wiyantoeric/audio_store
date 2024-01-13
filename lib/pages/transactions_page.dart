import 'package:audio_store/database/supabase_controller.dart';
import 'package:audio_store/model/cart_item.dart';
import 'package:audio_store/model/transaction.dart';
import 'package:audio_store/widgets/transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart';

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
                      ? Column(
                          children: [
                            FilledButton(
                              onPressed: () => context.go('/login'),
                              child: Text('Login'),
                            ),
                            Text('Please login to view transactions'),
                          ],
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

                              return ListView.separated(
                                  itemCount: transactions.length,
                                  separatorBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        SizedBox(height: 8),
                                        Divider(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline),
                                        SizedBox(height: 8),
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
