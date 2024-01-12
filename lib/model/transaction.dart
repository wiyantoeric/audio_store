class Transaction {
  String? createdAt;
  double totalPrice;
  List<int> itemIds;
  List<int> qtys;

  Transaction({
    required this.createdAt,
    required this.totalPrice,
    required this.itemIds,
    required this.qtys,
  });

  Transaction.fromJson(Map<String, dynamic> json)
      : createdAt = json['created_at'],
        totalPrice = json['price'],
        itemIds = json['item_ids'].cast<int>(),
        qtys = json['qtys'].cast<int>();

  Map<String, dynamic> toJson() => {
        'created_at': createdAt,
        'price': totalPrice,
        'item_ids': itemIds,
        'qtys': qtys,
      };
}
