// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart_provider/cart_model.dart';
import 'package:shopping_cart_provider/cart_provider.dart';
import 'package:shopping_cart_provider/cart_total_model.dart';
import 'package:shopping_cart_provider/database_handler.dart';

class ProductListScreen extends StatelessWidget {
  ProductListScreen({Key? key}) : super(key: key);

  DatabaseHandler? dbHandler = DatabaseHandler();

  List<Map<String, dynamic>> productsList = [
    {
      'name': 'Mango',
      'unit': 'KG',
      'price': 10,
      'image':
          'https://image.shutterstock.com/image-photo/mango-isolated-on-white-background-600w-610892249.jpg',
    },
    {
      'name': 'Orange',
      'unit': 'Dozen',
      'price': 20,
      'image':
          'https://image.shutterstock.com/image-photo/orange-fruit-slices-leaves-isolated-600w-1386912362.jpg',
    },
    {
      'name': 'Grapes',
      'unit': 'KG',
      'price': 30,
      'image': 'https://image.shutterstock.com/image-photo/green-grape-leaves-isolated-on-600w-533487490.jpg',
    },
    {
      'name': 'Banana',
      'unit': 'Dozen',
      'price': 40,
      'image': 'https://media.istockphoto.com/photos/banana-picture-id1184345169?s=612x612',
    },
    {
      'name': 'Chery',
      'unit': 'KG',
      'price': 50,
      'image':
          'https://media.istockphoto.com/photos/cherry-trio-with-stem-and-leaf-picture-id157428769?s=612x612',
    },
    {
      'name': 'Peach',
      'unit': 'KG',
      'price': 60,
      'image':
          'https://media.istockphoto.com/photos/single-whole-peach-fruit-with-leaf-and-slice-isolated-on-white-picture-id1151868959?s=612x612',
    },
    {
      'name': 'Mixed Fruit Basket',
      'unit': 'KG',
      'price': 70,
      'image': 'https://media.istockphoto.com/photos/fruit-background-picture-id529664572?s=612x612',
    },
  ];

  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Products List"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Badge(
              backgroundColor: Colors.red,
              label: Consumer<CartProvider>(
                builder: (context, value, child) {
                  return Text(value.getCartItemCount().toString());
                },
              ),
              child: const Padding(
                padding: EdgeInsets.all(3.0),
                child: Icon(Icons.shopping_bag_outlined),
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: productsList.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
              leading: CircleAvatar(
                radius: 40,
                foregroundImage: NetworkImage(
                  productsList[index]["image"],
                ),
              ),
              title: Text(
                productsList[index]["name"],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: RichText(
                text: TextSpan(
                  text: productsList[index]["unit"] + " :",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: " \$${productsList[index]["price"]}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () {
                  dbHandler!
                      .insert(
                    CartModel(
                      id: index + 1,
                      productId: (index + 1).toString(),
                      productName: productsList[index]["name"],
                      initialPrice: productsList[index]["price"],
                      productPrice: productsList[index]["price"],
                      quantity: 1,
                      unitTag: productsList[index]["unit"],
                      image: productsList[index]["image"],
                    ),
                  )
                      .then((value) {
                    cartProvider.addToCartTotal(double.parse(productsList[index]["price"].toString()));
                    cartProvider.incrementCartCount();
                    print("added");
                  }).onError((error, stackTrace) {
                    debugPrint(error.toString());
                  });
                },
                child: const Text(
                  "Add to cart",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
