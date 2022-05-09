import 'package:hive/hive.dart';
import 'package:hiveflutter/models/product.dart';
class Boxes {
  static Box<Product> getProducts() =>
      Hive.box<Product>('productbox');  
}