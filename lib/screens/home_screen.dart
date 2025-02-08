import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import 'add_product_screen.dart';
import 'product_detail_screen.dart';
import '../models/product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = '';

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
    final productProvider = Provider.of<ProductProvider>(context);
    // Zoek op naam, categorie en barcode:
    final products = productProvider.products.where((product) =>
        product.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
        product.category.toLowerCase().contains(searchQuery.toLowerCase()) ||
        (product.barcode?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false)
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histamine Tracker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Zoeken',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: products.isEmpty
                  ? const Center(child: Text('Geen producten gevonden'))
                  : ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        Product product = products[index];
                        return Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                            subtitle: Text(product.category.isNotEmpty ? product.category : 'Geen categorie'),
                            trailing: CircleAvatar(
                              backgroundColor: getSeverityColor(product.severity),
                              child: Text(
                                product.severity.substring(0, 1).toUpperCase(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            onTap: () {
                              int indexInOriginal = productProvider.products.indexOf(product);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(productIndex: indexInOriginal),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddProductScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
