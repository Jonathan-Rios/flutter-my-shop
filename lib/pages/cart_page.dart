import 'package:flutter/material.dart';
import 'package:my_shop/components/cart_item.dart';
import 'package:my_shop/models/cart.dart';
import 'package:my_shop/models/order_list.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of<Cart>(context);
    final items = cart.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Column(children: [
        Card(
          margin: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 25,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 10),
                Chip(
                  label: Text(
                    '\$ ${double.parse((cart.totalAmount).toStringAsFixed(2))}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
                const Spacer(),
                CartButton(cart: cart),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return CartItemWidget(items[index]);
              }),
        ),
        const SizedBox(height: 10),
      ]),
    );
  }
}

class CartButton extends StatefulWidget {
  const CartButton({
    super.key,
    required this.cart,
  });

  final Cart cart;

  @override
  State<CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const CircularProgressIndicator()
        : OutlinedButton(
            onPressed: widget.cart.itemsCount == 0
                ? null
                : () async {
                    setState(() {
                      _isLoading = true;
                    });

                    await Provider.of<OrderList>(
                      context,
                      listen: false,
                    ).addOrder(widget.cart);

                    setState(() {
                      _isLoading = false;
                    });
                    widget.cart.clear();
                  },
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                width: 2,
                color: widget.cart.itemsCount == 0
                    ? Colors.grey
                    : Theme.of(context).colorScheme.primary,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            child: Text(
              'BUY',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: widget.cart.itemsCount == 0
                    ? Colors.grey
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
          );
  }
}
