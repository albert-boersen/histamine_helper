// lib/screens/add_product_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../models/product.dart';
import 'barcode_scanner_screen.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String? category; // kan null zijn tijdens invoer
  String severity = 'groen';
  String? notes; // kan null zijn tijdens invoer
  final TextEditingController _barcodeController = TextEditingController();

  @override
  void dispose() {
    _barcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text('Voeg Product Toe')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Product Naam'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Vul een naam in' : null,
                onSaved: (value) => name = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Categorie (optioneel)',
                  hintText: 'Laat leeg als niet van toepassing',
                ),
                onSaved: (value) => category = value?.trim(),
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Beoordeling'),
                value: severity,
                items: const [
                  DropdownMenuItem(child: Text('Groen'), value: 'groen'),
                  DropdownMenuItem(child: Text('Oranje'), value: 'oranje'),
                  DropdownMenuItem(child: Text('Rood'), value: 'rood'),
                ],
                onChanged: (value) {
                  setState(() {
                    severity = value!;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Notities (optioneel)'),
                maxLines: 3,
                onSaved: (value) => notes = value?.trim(),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _barcodeController,
                      decoration: const InputDecoration(
                        labelText: 'Barcode (optioneel)',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: () async {
                      // Open de BarcodeScannerScreen en wacht op het resultaat
                      final scannedBarcode = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BarcodeScannerScreen(),
                        ),
                      );
                      if (scannedBarcode != null) {
                        setState(() {
                          _barcodeController.text = scannedBarcode;
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Gebruik '??' om null te vervangen door lege string
                    Product newProduct = Product(
                      name: name,
                      category: category ?? '',
                      severity: severity,
                      notes: notes ?? '',
                      barcode: _barcodeController.text.isNotEmpty ? _barcodeController.text : null,
                    );
                    productProvider.addProduct(newProduct);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Opslaan'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
