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
          if (snapshot.data != null && snapshot.data!.isEmpty) {
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "CART IS EMPTY!! ",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black45,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
                  child: Image(
                    image: NetworkImage(
                        'https://i0.wp.com/www.huratips.com/wp-content/uploads/2019/04/empty-cart.png?fit=603%2C288&ssl=1'),
                  ),
                ),
                Text(
                  "EXPLORE PRODUCTS... ",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black45,
                  ),
                ),
              ],
            );
          }
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
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
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
                        Row(
                          children: [
                            IconButton(
                              onPressed: snapshot.data![index].quantity! == 1
                                  ? null
                                  : () {
                                      int quantity = snapshot.data![index].quantity!;
                                      int price = snapshot.data![index].initialPrice!;

                                      quantity--;

                                      dbHandler!
                                          .update(
                                        CartModel(
                                          id: snapshot.data![index].id!,
                                          productId: snapshot.data![index].id!.toString(),
                                          productName: snapshot.data![index].productName!,
                                          initialPrice: snapshot.data![index].initialPrice!,
                                          productPrice: price * quantity,
                                          quantity: quantity,
                                          unitTag: snapshot.data![index].unitTag!,
                                          image: snapshot.data![index].image!,
                                        ),
                                      )
                                          .then((value) {
                                        quantity = 0;

                                        cartProvider.removeCartTotal(snapshot.data![index].initialPrice!.toDouble());
                                      }).onError((error, stackTrace) {
                                        debugPrint(error.toString());
                                        debugPrintStack(stackTrace: stackTrace);
                                      });
                                    },
                              icon: Icon(
                                Icons.remove_circle,
                                color: snapshot.data![index].quantity! == 1 ? Colors.grey : Colors.redAccent,
                              ),
                            ),
                            Text(
                              snapshot.data![index].quantity.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                int quantity = snapshot.data![index].quantity!;
                                int price = snapshot.data![index].initialPrice!;

                                quantity++;

                                dbHandler!
                                    .update(
                                  CartModel(
                                    id: snapshot.data![index].id!,
                                    productId: snapshot.data![index].id!.toString(),
                                    productName: snapshot.data![index].productName!,
                                    initialPrice: snapshot.data![index].initialPrice!,
                                    productPrice: price * quantity,
                                    quantity: quantity,
                                    unitTag: snapshot.data![index].unitTag!,
                                    image: snapshot.data![index].image!,
                                  ),
                                )
                                    .then((value) {
                                  quantity = 0;

                                  cartProvider.addCartTotal(snapshot.data![index].initialPrice!.toDouble());
                                }).onError((error, stackTrace) {
                                  debugPrint(error.toString());
                                  debugPrintStack(stackTrace: stackTrace);
                                });
                              },
                              icon: const Icon(
                                Icons.add_circle,
                                color: Colors.deepPurpleAccent,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                dbHandler!.delete(snapshot.data![index].id!);
                                cartProvider.decrementItemCount();
                                cartProvider.removeCartTotal(snapshot.data![index].productPrice!.toDouble());
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const Text("data");
        },
      ),
      bottomNavigationBar: Visibility(
        visible: cartProvider.getCartTotal() == 0.0 ? false : true,
        child: BottomAppBar(
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
      ),
    );
  }
}
