import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 0)
class Product extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String category;

  @HiveField(2)
  String severity; // bijv. 'groen', 'oranje', 'rood'

  @HiveField(3)
  String notes;

  @HiveField(4)
  String? barcode; // optioneel barcode-veld

  Product({
    required this.name,
    required this.category,
    required this.severity,
    this.notes = '',
    this.barcode,
  });
}
