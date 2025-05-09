import 'package:flutter/material.dart';
import 'fruit_shop.dart';

void main() {
  runApp(const FruitShopApp());
}

class FruitShopApp extends StatelessWidget {
  const FruitShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fruit Shop',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const FruitShopHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}