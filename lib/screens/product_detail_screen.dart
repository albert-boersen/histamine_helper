import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../models/product.dart';
import 'edit_product_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  final int productIndex;

  const ProductDetailScreen({
    Key? key,
    required this.productIndex,
  }) : super(key: key);

  Color getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'groen':
        return Colors.green;
      case 'oranje':
        return Colors.orange;
      case 'rood':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        if (productIndex >= productProvider.products.length) {
          return Scaffold(
            appBar: AppBar(title: const Text('Product niet gevonden')),
            body: const Center(child: Text('Dit product bestaat niet meer.')),
          );
        }
        final Product product = productProvider.products[productIndex];

        return Scaffold(
          appBar: AppBar(
            title: Text(product.name),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProductScreen(
                        product: product,
                        productIndex: productIndex,
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  productProvider.deleteProduct(productIndex);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Categorie: ${((product.category ?? '').isNotEmpty ? product.category! : 'Geen categorie')}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text('Beoordeling: ', style: TextStyle(fontSize: 18)),
                    Container(
                      decoration: BoxDecoration(
                        color: getSeverityColor(product.severity),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Text(
                        product.severity.toUpperCase(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text('Notities:', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 5),
                Text(product.notes ?? ''),
                if (product.barcode != null && (product.barcode ?? '').isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text('Barcode: ${product.barcode}'),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
