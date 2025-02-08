import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DonationButton extends StatelessWidget {
  const DonationButton({Key? key}) : super(key: key);

  Future<void> _launchDonationURL() async {
    final Uri url = Uri.parse('https://buymeacoffee.com/albertboursin');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.coffee, color: Colors.brown),
      title: const Text('Koop een kopje koffie voor mij'),
      onTap: _launchDonationURL,
    );
  }
}
