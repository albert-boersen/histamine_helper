import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 0)
class Product extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String category; // Niet nullable, standaard lege string

  @HiveField(2)
  String severity;

  @HiveField(3)
  String notes; // Niet nullable, standaard lege string

  @HiveField(4)
  String? barcode; // Barcode kan nullable blijven

  Product({
    required this.name,
    this.category = '',
    required this.severity,
    this.notes = '',
    this.barcode,
  });
}
