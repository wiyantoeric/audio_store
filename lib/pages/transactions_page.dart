import 'package:audio_store/database/supabase_controller.dart';
import 'package:audio_store/model/cart_item.dart';
import 'package:audio_store/model/transaction.dart';
import 'package:flutter/material.dart';
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
              children: [
                ElevatedButton(
                    onPressed: () {
                      getTransactions(
                          uid: Supabase.instance.client.auth.currentUser!.id);
                    },
                    child: Text('Refresh')),
                Expanded(
                  child: FutureBuilder(
                      future: getTransactions(
                          uid: Supabase.instance.client.auth.currentUser!.id),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final transactions = snapshot.data as List;
                          final itemIds = [];
                          for (Transaction t in transactions) {
                            itemIds.addAll(t.itemIds);
                          }

                          return ListView.builder(
                              itemCount: transactions.length,
                              itemBuilder: (context, index) {
                                return;
                              });
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
