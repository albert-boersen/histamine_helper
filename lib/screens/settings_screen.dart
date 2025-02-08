import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import 'donation_button.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  void _clearAllData(BuildContext context) async {
    bool confirmed = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Bevestiging"),
              content: const Text("Weet je zeker dat je alle gegevens wilt wissen? Dit kan niet ongedaan worden."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("Annuleren"),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text("Wis alle gegevens"),
                ),
              ],
            );
          },
        ) ??
        false;

    if (confirmed) {
      await Provider.of<ProductProvider>(context, listen: false).clearAllProducts();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Alle gegevens zijn gewist.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Instellingen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.delete_forever),
              title: const Text("Wis alle gegevens"),
              onTap: () => _clearAllData(context),
            ),
            const Divider(),
            const DonationButton(),  // Hier voeg je de donatieknop toe.
          ],
        ),
      ),
    );
  }
}
