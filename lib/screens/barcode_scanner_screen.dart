// lib/screens/barcode_scanner_screen.dart
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({Key? key}) : super(key: key);

  @override
  _BarcodeScannerScreenState createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  String? scannedBarcode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Barcode')),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              onDetect: (BarcodeCapture barcodeCapture) {
                final List<Barcode> barcodes = barcodeCapture.barcodes;
                if (barcodes.isNotEmpty) {
                  setState(() {
                    scannedBarcode = barcodes.first.rawValue;
                  });
                  // Keer direct terug met de gescande barcode.
                  Navigator.pop(context, scannedBarcode);
                }
              },
            ),
          ),
          if (scannedBarcode != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Gescande barcode: $scannedBarcode',
                style: const TextStyle(fontSize: 18),
              ),
            ),
        ],
      ),
    );
  }
}
