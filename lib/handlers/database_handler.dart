import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shopping_cart_provider/models/cart_model.dart';
import 'package:shopping_cart_provider/models/cart_total_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHandler {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }

    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "cart.db");

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE cart (id INTEGER PRIMARY KEY , productId VARCHAR UNIQUE, productName TEXT, "
        "initialPrice INTEGER, productPrice INTEGER , quantity INTEGER, unitTag TEXT , image TEXT )");

    await db.execute("CREATE TABLE total (id INTEGER PRIMARY KEY , itemCount INTEGER, cartTotal DOUBLE)");
  }

  Future<CartModel> insert(CartModel cartModel) async {
    var dbClient = await db;
    await dbClient!.insert("cart", cartModel.toMap());

    return cartModel;
  }

  Future<List<CartModel>> getCartItems() async {
    var dbClient = await db;

    final List<Map<dynamic, dynamic>> queryResult = await dbClient!.query("cart");
    List<CartModel>? cartItems = queryResult.map((e) => CartModel.fromJson(e)).toList();

    return cartItems;
  }

  Future<CartTotalModel> updateCartTotal(CartTotalModel cartTotalModel) async {
    var dbClient = await db;
    await dbClient!.update("total", cartTotalModel.toMap());

    return cartTotalModel;
  }

  Future<CartTotalModel?> getCartCountTotal() async {
    var dbClient = await db;

    final List<Map<String, dynamic>> queryResult = await dbClient!.query("total");
    CartTotalModel? cartTotalModel;

    if (queryResult.isNotEmpty) {
      cartTotalModel = CartTotalModel.fromJson(queryResult.first);
    }

    return cartTotalModel;
  }
}
