import 'package:flutter/material.dart';

class ShoppingCartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  final void Function(int itemId) onItemRemoved;

  const ShoppingCartPage({
    super.key,
    required this.cartItems,
    required this.onItemRemoved,
  });

  @override
  State<ShoppingCartPage> createState() => _ShoppingCartPageState();
}


class _ShoppingCartPageState extends State<ShoppingCartPage> {
  late List<Map<String, dynamic>> cartItems;

  @override
  void initState() {
    super.initState();
    cartItems = List.from(widget.cartItems); // copy for mutability
  }

  double getCartTotal() {
    return cartItems.fold(0, (total, item) {
      final product = item['item']; // 👈 fix
      final quantity = item['quantity'];
      final price = double.parse(product['price']);
      return total + (price * quantity);
    });
  }


  void _removeItem(int index) {
    final itemId = cartItems[index]['item']['id'];
    setState(() {
      cartItems.removeAt(index);
    });
    widget.onItemRemoved(itemId);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text('Your cart is empty.'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      final product = item['item'];
                      final total = (double.parse(product['price']) * item['quantity']).toStringAsFixed(2);

                      return ListTile(
                        leading: const Icon(Icons.shopping_cart),
                        title: Text(product['name']),
                        subtitle: Text(
                          'Price: \$${product['price']} x ${item['quantity']} = \$${total}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _removeItem(index),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Total: \$${getCartTotal().toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
    );
  }
}
