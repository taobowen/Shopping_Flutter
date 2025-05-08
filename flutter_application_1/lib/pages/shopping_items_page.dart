import 'dart:math';
import 'package:flutter/material.dart';
import './shopping_cart_page.dart';

class ShoppingItemsPage extends StatefulWidget {
  const ShoppingItemsPage({super.key});

  @override
  State<ShoppingItemsPage> createState() => _ShoppingItemsPageState();
}

class _ShoppingItemsPageState extends State<ShoppingItemsPage> {
  final random = Random();

  // Map item name -> { item details, quantity }
  final Map<int, Map<String, dynamic>> _cart = {};

  late final List<Map<String, dynamic>> _items;

  final sampleNames = [
    'T-Shirt',
    'Sneakers',
    'Jeans',
    'Backpack',
    'Watch',
    'Jacket',
    'Sunglasses',
    'Laptop Bag',
    'Headphones',
    'Water Bottle',
  ];

// late final List<Map<String, dynamic>> _items;

void _handleItemRemoved(int itemId) {
  setState(() {
    _cart.remove(itemId); // 👈 remove from original cart
  });
}


@override
void initState() {
  super.initState();
  _items = List.generate(10, (index) {
    final name = sampleNames[random.nextInt(sampleNames.length)];
    final price = (10 + random.nextInt(90)) + random.nextDouble();
    return {
      'id': index, // ✅ unique ID
      'name': name,
      'price': price.toStringAsFixed(2),
      'image': Icons.shopping_bag_outlined,
    };
  });
}


  void _addToCart(Map<String, dynamic> item) {
    final int itemId = item['id'];

    setState(() {
      if (_cart.containsKey(itemId)) {
        _cart[itemId]!['quantity'] += 1;
      } else {
        _cart[itemId] = {
          'item': item,
          'quantity': 1,
        };
      }
    });

    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('${item['name']} added to cart')),
    // );
  }


  int _getItemCount(int itemId) {
    return _cart[itemId]?['quantity'] ?? 0;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products (${_cart.values.fold<int>(0, (sum, entry) => sum + entry['quantity'] as int)})'),
      ),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          final int id = item['id'];
          final int quantity = _getItemCount(id); // ✅ now using item ID

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: Icon(item['image'] as IconData, size: 30),
              title: Text(item['name']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('\$${item['price']}'),
                  if (quantity > 0)
                    Text('Added: $quantity', style: const TextStyle(color: Colors.green)),
                ],
              ),
              trailing: ElevatedButton(
                onPressed: () => _addToCart(item),
                child: const Text('Add'),
              ),
            ),
          );
        }

      ),
      floatingActionButton: Stack(
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ShoppingCartPage(
                    cartItems: _cart.values.toList(),
                    onItemRemoved: _handleItemRemoved, // 👈 handle sync
                  ),
                ),
              );
            },
            child: const Icon(Icons.shopping_cart),
          ),


          if (_cart.isNotEmpty)
            Positioned(
              right: 0,
              top: 0,
              child: CircleAvatar(
                radius: 10,
                backgroundColor: Colors.red,
                child: Text(
                  '${_cart.values.fold<int>(0, (sum, entry) => sum + (entry['quantity'] as int))}', // ✅ total count
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
