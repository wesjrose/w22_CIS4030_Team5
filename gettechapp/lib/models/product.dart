import 'package:flutter/foundation.dart';

class Product {
  final String name;
  final String price;
  final String manufacturer;
  final String imageURL;
  final String description;
  final List<String> availableStores;
  final String type;
  final int id;

  Product({
    required this.name,
    required this.price,
    required this.manufacturer,
    required this.imageURL,
    required this.description,
    required this.availableStores,
    required this.id,
    required this.type,
  });
}
