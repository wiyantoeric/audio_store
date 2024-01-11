class Item {
  int id;
  String name;
  String desc;
  double price;
  int? qty;
  String? type;
  String? imageUrl;

  Item({
    required this.id,
    required this.name,
    required this.desc,
    required this.price,
    this.qty,
    this.type,
    this.imageUrl,
  });

  static Item fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'] as String,
      desc: json['desc'] as String,
      price: json['price'] as double,
      qty: json['qty'] as int,
      type: json['type'] as String,
      imageUrl: json['image_url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'desc': desc,
      'price': price,
      'qty': qty == -1 ? null : qty,
      'type': type == 'null' ? null : type,
      'image_url': imageUrl == 'null' ? null : imageUrl,
    };
  }
}
