import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_shop/models/order.dart';

class OrderItem extends StatefulWidget {
  final Order order;

  const OrderItem({
    required this.order,
    super.key,
  });

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final itemsHeight = (widget.order.products.length * 25.0) + 20;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _expanded ? itemsHeight + 80 : 80,
      child: Card(
          child: Column(
        children: [
          ListTile(
            title:
                Text('\$ ${num.parse(widget.order.total.toStringAsFixed(2))}'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _expanded ? itemsHeight : 0,
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 4,
            ),
            child: ListView(
              children: widget.order.products
                  .map(
                    (item) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${item.quantity}x \$ ${num.parse(item.price.toStringAsFixed(2))}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          )
        ],
      )),
    );
  }
}
