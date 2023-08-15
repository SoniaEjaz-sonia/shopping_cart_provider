import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_provider.dart';
import 'product_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      builder: (BuildContext context, Widget? widget) {
        return MaterialApp(
          title: 'Shopping Cart',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              centerTitle: true,
              backgroundColor: Colors.deepPurple,
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
              actionsIconTheme: IconThemeData(color: Colors.white),
            ),
          ),
          home: ProductListScreen(),
        );
      },
    );
  }
}
