// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart_provider/handlers/cart_provider.dart';
import 'package:shopping_cart_provider/handlers/database_handler.dart';
import 'package:shopping_cart_provider/models/cart_model.dart';

class CartScreen extends StatelessWidget {
  CartScreen({Key? key}) : super(key: key);

  DatabaseHandler? dbHandler = DatabaseHandler();

  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart Items"),
      ),
      body: FutureBuilder(
        future: cartProvider.getCartItems(),
        builder: (BuildContext context, AsyncSnapshot<List<CartModel>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
                    leading: CircleAvatar(
                      radius: 40,
                      foregroundImage: NetworkImage(
                        snapshot.data![index].image!,
                      ),
                    ),
                    title: Text(
                      snapshot.data![index].productName!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: RichText(
                      text: TextSpan(
                        text: "${snapshot.data![index].unitTag!} :",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: " \$${snapshot.data![index].productPrice!}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        dbHandler!.delete(snapshot.data![index].id!);
                        cartProvider.decrementItemCount();
                        cartProvider.removeCartTotal(snapshot.data![index].productPrice!.toDouble());
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ),
                );
              },
            );
          }

          return const Text("data");
        },
      ),
      bottomNavigationBar: BottomAppBar(
        height: 60,
        surfaceTintColor: Colors.white,
        child: Text(
          "Total    :    ${cartProvider.getCartTotal().toStringAsFixed(2)}",
          textAlign: TextAlign.end,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
