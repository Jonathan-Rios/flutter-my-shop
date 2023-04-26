class Constants {
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: '',
  );

  static const String webApiKey = String.fromEnvironment(
    'WEB_API_KEY',
    defaultValue: '',
  );

  static const String productsBaseUrl = '$baseUrl/products';
  static const String userFavoritesUrl = '$baseUrl/userFavorites';
  static const String ordersBaseUrl = '$baseUrl/orders';
}
