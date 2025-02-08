import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:histamine_helper/main.dart';

void main() {
  testWidgets('Widget test example', (WidgetTester tester) async {
    // Build our app zonder expliciete productBox (aangenomen dat Hive al geopend is in de test)
    await tester.pumpWidget(MyApp());

    // Voeg hier je tests toe...
  });
}
