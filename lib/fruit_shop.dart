import 'package:flutter/material.dart';

class FruitShopHomePage extends StatefulWidget {
  const FruitShopHomePage({super.key});

  @override
  State<FruitShopHomePage> createState() => _FruitShopHomePageState();
}

class _FruitShopHomePageState extends State<FruitShopHomePage> {
  final List<Fruit> _availableFruits = [
    Fruit(name: 'Apple', price: 1.99, emoji: '🍎'),
    Fruit(name: 'Banana', price: 0.99, emoji: '🍌'),
    Fruit(name: 'Orange', price: 1.49, emoji: '🍊'),
    Fruit(name: 'Grapes', price: 2.99, emoji: '🍇'),
    Fruit(name: 'Watermelon', price: 4.99, emoji: '🍉'),
    Fruit(name: 'Strawberry', price: 3.49, emoji: '🍓'),
  ];

  List<CartItem> _cartItems = [];

  void _addToCart(Fruit fruit) {
    setState(() {
      final existingIndex = _cartItems.indexWhere((item) => item.fruit.name == fruit.name);
      if (existingIndex >= 0) {
        _cartItems[existingIndex] = CartItem(
          fruit: fruit,
          quantity: _cartItems[existingIndex].quantity + 1,
        );
      } else {
        _cartItems.add(CartItem(fruit: fruit, quantity: 1));
      }
    });
  }

  void _updateCart(List<CartItem> updatedCart) {
    setState(() {
      _cartItems = updatedCart;
    });
  }

  double _calculateTotal() {
    return _cartItems.fold(0, (double total, item) => total + (item.fruit.price * item.quantity));
  }

  int _totalItemCount() {
    return _cartItems.fold(0, (int count, item) => count + item.quantity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fruit Shop'),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(
                    cartItems: _cartItems,
                    onUpdateCart: _updateCart,
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.shopping_cart),
                  if (_cartItems.isNotEmpty)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          _totalItemCount().toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        itemCount: _availableFruits.length,
        itemBuilder: (context, index) {
          final fruit = _availableFruits[index];
          return FruitItemCard(
            fruit: fruit,
            onAddToCart: () => _addToCart(fruit),
          );
        },
      ),
    );
  }
}

class Fruit {
  final String name;
  final double price;
  final String emoji;

  const Fruit({
    required this.name,
    required this.price,
    required this.emoji,
  });
}

class CartItem {
  final Fruit fruit;
  final int quantity;

  const CartItem({
    required this.fruit,
    required this.quantity,
  });
}

class FruitItemCard extends StatelessWidget {
  final Fruit fruit;
  final VoidCallback onAddToCart;

  const FruitItemCard({
    super.key,
    required this.fruit,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              fruit.emoji,
              style: const TextStyle(fontSize: 50),
            ),
            Column(
              children: [
                Text(
                  fruit.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${fruit.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: onAddToCart,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 40),
              ),
              child: const Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}

class CartScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  final Function(List<CartItem>) onUpdateCart;

  const CartScreen({
    super.key,
    required this.cartItems,
    required this.onUpdateCart,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<CartItem> _currentCartItems;

  @override
  void initState() {
    super.initState();
    _currentCartItems = List.from(widget.cartItems);
  }

  void _removeItem(CartItem item) {
    setState(() {
      final itemIndex = _currentCartItems.indexWhere((i) => i.fruit.name == item.fruit.name);
      if (itemIndex != -1) {
        if (_currentCartItems[itemIndex].quantity > 1) {
          _currentCartItems[itemIndex] = CartItem(
            fruit: item.fruit,
            quantity: _currentCartItems[itemIndex].quantity - 1,
          );
        } else {
          _currentCartItems.removeAt(itemIndex);
        }
      }
    });
    widget.onUpdateCart(_currentCartItems);
  }

  double _calculateTotal() {
    return _currentCartItems.fold(0, (double total, item) => total + (item.fruit.price * item.quantity));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _currentCartItems.isEmpty
                ? const Center(
                    child: Text(
                      'Your cart is empty',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: _currentCartItems.length,
                    itemBuilder: (context, index) {
                      final item = _currentCartItems[index];
                      return ListTile(
                        key: Key('${item.fruit.name}_$index'),
                        leading: Text(
                          item.fruit.emoji,
                          style: const TextStyle(fontSize: 30),
                        ),
                        title: Text(item.fruit.name),
                        subtitle: Text(
                          '${item.quantity} × \$${item.fruit.price.toStringAsFixed(2)} = \$${(item.fruit.price * item.quantity).toStringAsFixed(2)}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                          onPressed: () => _removeItem(item),
                        ),
                      );
                    },
                  ),
          ),
          if (_currentCartItems.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Items:',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        _currentCartItems.fold(0, (int sum, item) => sum + item.quantity).toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Price:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${_calculateTotal().toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}