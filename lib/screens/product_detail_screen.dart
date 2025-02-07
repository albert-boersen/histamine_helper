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
    // Gebruik Consumer zodat de widget opnieuw opbouwt wanneer de provider wijzigt.
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        // Controleer of de index nog geldig is
        if (productIndex >= productProvider.products.length) {
          return Scaffold(
            appBar: AppBar(title: const Text('Product niet gevonden')),
            body: const Center(child: Text('Dit product bestaat niet meer.')),
          );
        }
        // Haal het meest recente product op uit de provider
        final Product product = productProvider.products[productIndex];

        return Scaffold(
          appBar: AppBar(
            title: Text(product.name),
            actions: [
              // Edit-knop: Navigeer naar het bewerkscherm
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
              // Delete-knop: Verwijder het product en keer terug
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
                // Toon de categorie (of 'Geen categorie' als leeg)
                Text(
                  'Categorie: ${product.category.isNotEmpty ? product.category : 'Geen categorie'}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                // Toon de beoordeling met kleurindicatie
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
                // Toon de notities
                const Text('Notities:', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 5),
                Text(product.notes),
              ],
            ),
          ),
        );
      },
    );
  }
}
