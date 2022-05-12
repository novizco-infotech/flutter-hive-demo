import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../boxes.dart';
import '../models/product.dart';
import 'dialog.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
