// GENERATED CODE - HANDMADE ADAPTER

part of 'product.dart';

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final int typeId = 0;
  
  @override
  Product read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Product(
      name: fields[0] as String,
      category: fields[1] as String,
      severity: fields[2] as String,
      notes: fields[3] as String,
      barcode: fields[4] as String?,
    );
  }
  
  @override
  void write(BinaryWriter writer, Product obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.severity)
      ..writeByte(3)
      ..write(obj.notes)
      ..writeByte(4)
      ..write(obj.barcode);
  }
}
