import 'package:flutter/material.dart';

import 'package:my_shop/components/app_drawer.dart';
import 'package:my_shop/components/order_item.dart';
import 'package:my_shop/models/order_list.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: FutureBuilder(
        // FutureBuilder allow use a stateless widget and also be able to mutate the state depending of situation
        future: Provider.of<OrderList>(context, listen: false).loadOrders(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.error != null) {
              // ...
              // Do error handling stuff
              return const Center(
                child: Text('An error occurred!'),
              );
            } else {
              return Consumer<OrderList>(
                builder: (ctx, orders, child) => ListView.builder(
                  itemCount: orders.itemsCount,
                  itemBuilder: (ctx, i) => OrderItem(order: orders.items[i]),
                ),
              );
            }
          }
        },
      ),
      drawer: const AppDrawer(),
    );
  }
}
