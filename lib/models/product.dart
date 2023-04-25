import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_shop/exceptions/http_exception.dart';
import 'package:my_shop/utils/constants.dart';

class Product with ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void _toggleFavoriteStatus() async {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    _toggleFavoriteStatus();

    final response = await http.patch(
      Uri.parse('${Constants.userFavoritesUrl}/$userId.json?auth=$token'),
      body: jsonEncode({
        id: isFavorite,
      }),
    );

    if (response.statusCode >= 400) {
      _toggleFavoriteStatus();

      throw HttpException(
        message: 'Ocorreu um erro ao adicionar como favorito.',
        statusCode: response.statusCode,
      );
    }
  }
}
