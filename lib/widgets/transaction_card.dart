import 'package:audio_store/model/transaction.dart';
import 'package:flutter/material.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({super.key, required this.transaction});
  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(transaction.itemIds.toString()),
    );
  }
}
