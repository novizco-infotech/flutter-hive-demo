import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hiveflutter/models/product.dart';

import 'widgets/dialog.dart';

class Boxes {
  static Box<Product> getProducts() => Hive.box<Product>('productbox');
}

Color maincolor = Colors.indigo;

