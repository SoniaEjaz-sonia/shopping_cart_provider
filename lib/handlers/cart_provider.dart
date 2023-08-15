import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_cart_provider/handlers/database_handler.dart';
import 'package:shopping_cart_provider/models/cart_model.dart';

class CartProvider with ChangeNotifier {
  DatabaseHandler? dbHandler = DatabaseHandler();

  int _itemCount = 0;
  int get itemCount => _itemCount;

  double _cartTotal = 0.0;
  double get cartTotal => _cartTotal;

  late Future<List<CartModel>> _cart;
  Future<List<CartModel>> get cart => _cart;

  /// Shared Preferences implementation
  Future<void> _setPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt('items_count', _itemCount);
    prefs.setDouble('cart_total', _cartTotal);

    notifyListeners();
  }

  Future<void> _getPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _itemCount = prefs.getInt('items_count') ?? 0;
    _cartTotal = prefs.getDouble('cart_total') ?? 0.0;

    notifyListeners();
  }

  void incrementItemCount() {
    _itemCount++;
    _setPrefItems();
    notifyListeners();
  }

  void decrementItemCount() {
    _itemCount--;
    _setPrefItems();
    notifyListeners();
  }

  int getItemCount() {
    _getPrefItems();
    return _itemCount;
  }

  void addCartTotal(double cartTotal) {
    _cartTotal = _cartTotal + cartTotal;
    _setPrefItems();
    notifyListeners();
  }

  void removeCartTotal(double cartTotal) {
    _cartTotal = _cartTotal - cartTotal;
    _setPrefItems();
    notifyListeners();
  }

  double getCartTotal() {
    _getPrefItems();
    return _cartTotal;
  }

  /// SQFLite implementation
  //
  // Future<void> _setCartItems() async {
  //   CartTotalModel? cartTotalModel = await dbHandler!.getCartCountTotal();
  //
  //   if (cartTotalModel != null) {
  //     dbHandler!.updateCartTotal(
  //       CartTotalModel(
  //         id: 1,
  //         itemCount: _itemCount,
  //         cartTotal: _cartTotal,
  //       ),
  //     );
  //   } else {
  //     await dbHandler!.insertCartTotal(
  //       CartTotalModel(
  //         id: null,
  //         itemCount: _itemCount,
  //         cartTotal: _cartTotal,
  //       ),
  //     );
  //   }
  //
  //   notifyListeners();
  // }
  //
  // Future<void> _getCartTotalCount() async {
  //   CartTotalModel? cartTotalModel = await dbHandler!.getCartCountTotal();
  //
  //   _itemCount = cartTotalModel?.itemCount ?? 0;
  //   _cartTotal = cartTotalModel?.cartTotal ?? 0.0;
  //
  //   notifyListeners();
  // }
  //
  // void incrementCartCount() {
  //   _itemCount++;
  //   _setCartItems();
  //   notifyListeners();
  // }
  //
  // void decrementCartItemCount() {
  //   _itemCount--;
  //   _setCartItems();
  //   notifyListeners();
  // }
  //
  // int getCartItemCount() {
  //   _getCartTotalCount();
  //   return _itemCount;
  // }
  //
  // void addToCartTotal(double cartTotal) async {
  //   _cartTotal = _cartTotal + cartTotal;
  //   _setCartItems();
  //
  //   notifyListeners();
  // }
  //
  // void removeFromCartTotal(double cartTotal) {
  //   _cartTotal = _cartTotal - cartTotal;
  //   _setCartItems();
  //   notifyListeners();
  // }
  //
  // double getCartTotalP() {
  //   _getCartTotalCount();
  //   return _cartTotal;
  // }

  Future<List<CartModel>> getCartItems() async {
    _cart = dbHandler!.getCartItems();
    return _cart;
  }
}
