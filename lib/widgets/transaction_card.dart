import 'package:audio_store/database/supabase_controller.dart';
import 'package:audio_store/model/item.dart';
import 'package:audio_store/model/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:logger/logger.dart';

class TransactionCard extends StatefulWidget {
  const TransactionCard({super.key, required this.transaction});
  final Transaction transaction;

  @override
  State<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  late String orderDate;

  @override
  void initState() {
    DateTime dateTime = DateTime.parse(widget.transaction.createdAt!);
    DateFormat outputFormatter = DateFormat("dd MMM yyyy");
    orderDate = outputFormatter.format(dateTime);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(orderDate),
          const SizedBox(height: 16),
          ...widget.transaction.itemIds.asMap().entries.map(
            (e) {
              int idx = e.key;
              int itemId = e.value;
              int qty = widget.transaction.qtys[idx];

              return FutureBuilder<Item?>(
                future: getItem(id: itemId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    final item = snapshot.data as Item;

                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: Image.network(
                                  item.imageUrl!,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 8),
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
                                        'USD${item.price.toString()}',
                                      ),
                                      Text(qty.toString()),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Subtotal : USD${qty * item.price}',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    Logger().e(snapshot.error);
                    return const Text('Error occured');
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              );
            },
          ).toList(),
          Text(
            'Total : USD${widget.transaction.totalPrice}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
