import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_shop/models/cart.dart';
import 'package:my_shop/models/cart_item.dart';
import 'package:my_shop/models/order.dart';

import 'package:http/http.dart' as http;
import 'package:my_shop/utils/constants.dart';

class OrderList with ChangeNotifier {
  final String _userId;
  final String _token;

  List<Order> _items = [];

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  OrderList([
    this._token = '',
    this._userId = '',
    this._items = const [],
  ]);

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();

    final response = await http.post(
      Uri.parse('${Constants.ordersBaseUrl}/$_userId.json?auth=$_token'),
      body: jsonEncode({
        'total': cart.totalAmount,
        'dateTime': date.toIso8601String(),
        'products': cart.items.values
            .map((cartItem) => {
                  'id': cartItem.id,
                  'productId': cartItem.productId,
                  'name': cartItem.name,
                  'quantity': cartItem.quantity,
                  'price': cartItem.price,
                })
            .toList(),
      }),
    );

    final id = jsonDecode(response.body)['name'];

    _items.insert(
      0,
      Order(
        id: DateTime.now().toString(),
        total: cart.totalAmount,
        dateTime: date,
        products: cart.items.values.toList(),
      ),
    );

    notifyListeners();
  }

  Future<void> loadOrders() async {
    List<Order> items = [];

    final response = await http.get(
        Uri.parse('${Constants.ordersBaseUrl}/$_userId.json?auth=$_token'));

    if (response.body == 'null') {
      return;
    }

    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((orderId, orderData) {
      items.add(Order(
        id: orderId,
        total: orderData['total'],
        dateTime: DateTime.parse(orderData['dateTime']),
        products: (orderData['products'] as List<dynamic>)
            .map(
              (item) => CartItem(
                id: item['id'],
                productId: item['productId'],
                name: item['name'],
                quantity: item['quantity'],
                price: item['price'] as double,
              ),
            )
            .toList(),
      ));
    });

    _items = items.reversed.toList();
    notifyListeners();
  }
}
