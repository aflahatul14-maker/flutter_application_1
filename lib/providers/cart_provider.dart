import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/produk.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(Produk produk) {
    if (_items.containsKey(produk.id)) {
      _items.update(
        produk.id,
        (existing) => CartItem(
          id: existing.id,
          title: existing.title,
          price: existing.price,
          imagePath: existing.imagePath,
          quantity: existing.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        produk.id,
        () => CartItem(
          id: produk.id,
          title: produk.name,
          price: produk.price,
          imagePath: produk.imagePath,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  // Mengurangi kuantitas 1 persatu, jika tinggal 1 lalu dikurangi maka hapus item
  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return;

    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (existing) => CartItem(
          id: existing.id,
          title: existing.title,
          price: existing.price,
          imagePath: existing.imagePath,
          quantity: existing.quantity - 1,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}