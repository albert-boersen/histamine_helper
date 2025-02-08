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
  bool _hasReturned = false; // Zorgt ervoor dat Navigator.pop maar 1 keer wordt aangeroepen.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Barcode'),
      ),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              onDetect: (BarcodeCapture barcodeCapture) {
                final List<Barcode> barcodes = barcodeCapture.barcodes;
                if (barcodes.isNotEmpty && !_hasReturned) {
                  scannedBarcode = barcodes.first.rawValue;
                  _hasReturned = true;
                  // Geef de gescande barcode direct terug aan de vorige pagina.
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
