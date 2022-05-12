import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hiveflutter/models/product.dart';
import 'package:hiveflutter/widgets/dialog.dart';
import 'package:intl/intl.dart';

import '../boxes.dart';

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
                      builder: (context) => const ProductDialog(
                        onClickedDone: addProduct,
                      ),
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
        return buildProduct(context, product);
      },
    );
  }
}

Widget buildProduct(
  BuildContext context,
  Product product,
) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    elevation: 20,
    color: Colors.white,
    child: ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 26, vertical: 6),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textSection("Name : ${product.name}"),
          textSection("Amount : ${product.amount}"),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Date : ${DateFormat("dd-MM-yyyy").format(product.date)}"),
          Wrap(
            children: product.specs
                .map((e) => Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Chip(
                        label: Text(e),
                        elevation: 5,
                        labelStyle: const TextStyle(color: Colors.white),
                        backgroundColor: Colors.indigo,
                      ),
                    ))
                .toList(),
          )
        ],
      ),
      children: [
        buildButtons(context, product),
      ],
    ),
  );
}

Widget buildButtons(BuildContext context, Product product) => Row(
      children: [
        Expanded(
          child: TextButton.icon(
            label: const Text('Edit'),
            icon: const Icon(Icons.edit),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => ProductDialog(
                product: product,
                onClickedDone: (name, amount, date, specs) =>
                    editTransaction(product, name, amount, date, specs),
              ),
            ),
          ),
        ),
        Expanded(
          child: TextButton.icon(
            label: const Text('Delete'),
            icon: const Icon(Icons.delete),
            onPressed: () => deleteTransaction(product),
          ),
        )
      ],
    );

Future addProduct(String name, double amount, DateTime date, List specs) async {
  final product = Product()
    ..name = name
    ..amount = amount
    ..date = date
    ..specs = specs;
  final box = Boxes.getProducts();
  box.add(product);
}

void editTransaction(Product product, String newName, double newAmt,
    DateTime newDate, List newSpecs) {
  product.name = newName;
  product.amount = newAmt;
  product.date = newDate;
  product.specs = newSpecs;
  product.save();
}

void deleteTransaction(Product product) {
  final box = Boxes.getProducts();
  box.delete(product.key);
}

Text textSection(String text) {
  return Text(
    text,
    maxLines: 2,
    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
  );
}
