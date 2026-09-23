import 'package:flutter/foundation.dart';
import '../models/produk.dart';
import '../db_helper.dart';

class ProductProvider with ChangeNotifier {
  List<Produk> _products = [];

  List<Produk> get products => [..._products];

  Future<void> fetchProducts() async {
    final dataList = await DBHelper.getProducts();

    // 4 Produk Bawaan menggunakan gambar dari folder assets/images
    List<Produk> defaultProducts = [
      Produk(
        id: 'default_1',
        name: 'BerryPop Bracelet',
        price: 25000,
        description: 'Gelang cantik BerryPop',
        imagePath: 'assets/images/berrypop bracelet.jpg',
      ),
      Produk(
        id: 'default_2',
        name: 'Starlight Earrings',
        price: 35000,
        description: 'Anting Starlight',
        imagePath: 'assets/images/starlight earings.jpg',
      ),
      Produk(
        id: 'default_3',
        name: 'BerryGlaze Ring',
        price: 15000,
        description: 'Cincin BerryGlaze',
        imagePath: 'assets/images/berryglaze ring.jpg',
      ),
      Produk(
        id: 'default_4',
        name: 'Violet Necklaces',
        price: 40000,
        description: 'Kalung Violet',
        imagePath: 'assets/images/violet necklaces.jpg',
      ),
    ];

    _products = [...defaultProducts];

    if (dataList.isNotEmpty) {
      final userProducts = dataList
          .map((item) => Produk.fromMap(item))
          .where((prod) => !prod.imagePath.startsWith('assets/'))
          .toList();
      _products.addAll(userProducts);
    }

    notifyListeners();
  }

  Future<void> addProduct(String name, double price, String description, String imagePath) async {
    final newProduct = Produk(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      price: price,
      description: description,
      imagePath: imagePath,
    );
    
    await DBHelper.insertProduct(newProduct.toMap());
    _products.add(newProduct);
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    await DBHelper.deleteProduct(id);
    _products.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}