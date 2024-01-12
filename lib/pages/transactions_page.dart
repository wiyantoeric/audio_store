import 'package:audio_store/database/supabase_controller.dart';
import 'package:flutter/material.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              FutureBuilder(
                  future: getTransactions(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      // final transactions = snapshot.data as List;
                      return Text('hi');
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
