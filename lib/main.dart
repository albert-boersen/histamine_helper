import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/product.dart';
import 'providers/product_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ProductAdapter());
  var productBox = await Hive.openBox<Product>('products');
  runApp(MyApp(productBox: productBox));
}

class MyApp extends StatelessWidget {
  final Box<Product> productBox;
  MyApp({Key? key, Box<Product>? productBox})
      : productBox = productBox ?? Hive.box<Product>('products'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductProvider(productBox),
      child: MaterialApp(
        title: 'Histamine Tracker',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          textTheme: ThemeData.light().textTheme,
          scaffoldBackgroundColor: Colors.grey[100],
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 2,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
