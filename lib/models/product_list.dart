import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_shop/exceptions/http_exception.dart';
import 'package:my_shop/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:my_shop/utils/constants.dart';

class ProductList with ChangeNotifier {
  final String _token;
  final String _userId;

  List<Product> _items = [];

  // ? "Clonando" com spread para não permitir alterar o original.
  List<Product> get items => [..._items];

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  ProductList([
    this._token = '',
    this._userId = '',
    this._items = const [],
  ]);

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadProducts() async {
    _items.clear();

    final response = await http.get(
      Uri.parse(
        '${Constants.productsBaseUrl}.json?auth=$_token',
      ),
    );

    if (response.body == 'null') {
      _items.clear();
      notifyListeners();
      return Future.value();
    }

    Map<String, dynamic> data = jsonDecode(response.body);

    final favoritesResponse = await http.get(
      Uri.parse(
        '${Constants.userFavoritesUrl}/$_userId.json?auth=$_token',
      ),
    );

    Map<String, dynamic> favoritesData = favoritesResponse.body == 'null'
        ? {}
        : jsonDecode(favoritesResponse.body);

    data.forEach((productId, productData) {
      final isFavorite = favoritesData[productId] ?? false;

      _items.add(Product(
        id: productId,
        name: productData['name'],
        price: productData['price'],
        description: productData['description'],
        imageUrl: productData['imageUrl'],
        isFavorite: isFavorite,
      ));
    });

    notifyListeners();
  }

  Future<void> saveProduct(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final product = Product(
      id: hasId ? data['id'] as String : DateTime.now().toString(),
      name: data['name'] as String,
      price: data['price'] as double,
      description: data['description'] as String,
      imageUrl: data['imageUrl'] as String,
    );

    if (hasId) {
      return updateProduct(product);
    } else {
      return addProduct(product);
    }
  }

  Future<void> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse('${Constants.productsBaseUrl}.json?auth=$_token'),
      body: jsonEncode({
        'name': product.name,
        'price': product.price,
        'description': product.description,
        'imageUrl': product.imageUrl,
      }),
    );

    final id = jsonDecode(response.body)['name'];

    _items.add(Product(
      id: id,
      name: product.name,
      price: product.price,
      description: product.description,
      imageUrl: product.imageUrl,
    ));

    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    final index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      await http
          .patch(
        Uri.parse(
            '${Constants.productsBaseUrl}/${product.id}.json?auth=$_token'),
        body: jsonEncode({
          'name': product.name,
          'price': product.price,
          'description': product.description,
          'imageUrl': product.imageUrl,
        }),
      )
          .then((_) {
        _items[index] = product;
        notifyListeners();
      });
    }
  }

  Future<void> removeProduct(Product product) async {
    final index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      final product = _items[index];
      _items.remove(product);
      notifyListeners();

      final response = await http.delete(
        Uri.parse(
            '${Constants.productsBaseUrl}/${product.id}.json?auth=$_token'),
      );

      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();

        throw HttpException(
          message: 'Ocorreu um erro ao excluir o produto.',
          statusCode: response.statusCode,
        );
      }
    }
  }
}
