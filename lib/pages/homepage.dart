import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hiveflutter/models/product.dart';
import 'package:hiveflutter/widgets/dialog.dart';
import 'package:hiveflutter/widgets/productcard.dart';

import '../utils.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Hive App'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () => showDialog(
                      context: context,
                      builder: (context) => const ProductDialog(),
                    ),
                icon: const Icon(Icons.add))
          ],
        ),
        body: ValueListenableBuilder<Box<Product>>(
          valueListenable: Boxes.getProducts().listenable(),
          builder: (context, box, _) {
            final products = box.values.toList().cast<Product>();
            return viewSection(products);
          },
        ),
      );

  Widget viewSection(List<Product> products) {
    if (products.isEmpty) {
      return const Center(
        child: Text(
          'Empty...',
          style: TextStyle(fontSize: 24),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: products.length,
      itemBuilder: (BuildContext context, int index) {
        final product = products[index];
        return ProductCard(product: product);
      },
    );
  }
}
