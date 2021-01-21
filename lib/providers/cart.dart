import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  List<CartItem> get itemsList {
    return items.values.toList();
  }

  List<String> get keysList {
    return items.keys.toList();
  }

  void addItem(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (CartItem existingCI) => CartItem(
          id: existingCI.id,
          title: existingCI.title,
          quantity: existingCI.quantity + 1,
          price: existingCI.price,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
            id: DateTime.now().toString(),
            title: title,
            quantity: 1,
            price: price),
      );
    }
    notifyListeners();
  }

  remove(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return;
    _items[productId].quantity > 1
        ? _items.update(
            productId,
            (value) => CartItem(
                id: value.id,
                price: value.price,
                quantity: value.quantity - 1,
                title: value.title))
        : _items.remove(productId);
    notifyListeners();
  }

  clear() {
    _items = {};
    notifyListeners();
  }
}
