// To parse this JSON data, do
//
//     final modelCart = modelCartFromJson(jsonString);

import 'dart:convert';

ModelCart modelCartFromJson(String str) => ModelCart.fromJson(json.decode(str));

String modelCartToJson(ModelCart data) => json.encode(data.toJson());

class ModelCart {
  List<Item> items;
  int total;

  ModelCart({
    required this.items,
    required this.total,
  });

  factory ModelCart.fromJson(Map<String, dynamic> json) => ModelCart(
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "total": total,
  };
}

class Item {
  int id;
  String name;
  int quantity;
  int price;

  Item({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    name: json["name"],
    quantity: json["quantity"],
    price: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "quantity": quantity,
    "price": price,
  };
}
