import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import 'add_product_screen.dart';
import 'product_detail_screen.dart';
import 'settings_screen.dart';
import 'barcode_scanner_screen.dart';
import '../models/product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

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
  void initState() {
    super.initState();
    // Zorg dat de controller initieel leeg is.
    _searchController.text = searchQuery;
    _searchController.addListener(() {
      setState(() {
        searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    // Zorg dat eventuele null-waarden als lege string worden behandeld.
    final products = productProvider.products.where((product) =>
        product.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
        (product.category ?? '').toLowerCase().contains(searchQuery.toLowerCase()) ||
        (product.barcode ?? '').toLowerCase().contains(searchQuery.toLowerCase())
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histamine Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Zoekbalk met barcode-scan knop en clear-knop
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Zoeken',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  searchQuery = '';
                                });
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: () async {
                    final scannedBarcode = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BarcodeScannerScreen(),
                      ),
                    );
                    if (scannedBarcode != null) {
                      // Zet de gescande barcode zowel in de variabele als in de controller.
                      setState(() {
                        searchQuery = scannedBarcode;
                        _searchController.text = scannedBarcode;
                      });
                    }
                  },
                ),
              ],
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
                            title: Text(
                              product.name,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              ((product.category ?? '').isNotEmpty ? product.category! : 'Geen categorie'),
                            ),
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
