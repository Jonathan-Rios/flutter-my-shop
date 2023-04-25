import 'package:flutter/material.dart';
import 'package:my_shop/models/auth.dart';
import 'package:my_shop/models/cart.dart';
import 'package:my_shop/models/order_list.dart';
import 'package:my_shop/models/product_list.dart';
import 'package:my_shop/pages/auth_or_home_page.dart';
import 'package:my_shop/pages/cart_page.dart';
import 'package:my_shop/pages/order_page.dart';
import 'package:my_shop/pages/product_detail_page.dart';
import 'package:my_shop/pages/product_form_page.dart';
import 'package:my_shop/pages/products_page.dart';
import 'package:my_shop/utils/custom_route.dart';
import 'package:provider/provider.dart';

import 'utils/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductList>(
          create: (_) => ProductList(),
          update: (context, auth, previousProductList) => ProductList(
            auth.token ?? '',
            auth.userId ?? '',
            previousProductList?.items ?? [],
          ),
        ),
        ChangeNotifierProxyProvider<Auth, OrderList>(
          create: (_) => OrderList(),
          update: (context, auth, previousOrderList) => OrderList(
            auth.token ?? '',
            auth.userId ?? '',
            previousOrderList?.items ?? [],
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color.fromARGB(255, 115, 0, 255),
            secondary: const Color.fromARGB(255, 109, 252, 0),
            tertiary: const Color.fromARGB(255, 30, 30, 30),
            inversePrimary: const Color.fromRGBO(230, 230, 230, 1),
            error: const Color.fromARGB(255, 255, 0, 0),
          ),
          canvasColor: const Color.fromRGBO(230, 230, 230, 1),
          fontFamily: 'Lato',
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
              TargetPlatform.iOS: CustomPageTransitionBuilder(),
            },
          ),
        ),
        routes: {
          AppRoutes.authOrHome: (context) => const AuthOrHomePage(),
          AppRoutes.productDetail: (context) => const ProductDetailPage(),
          AppRoutes.cart: (context) => const CartPage(),
          AppRoutes.orders: (context) => const OrdersPage(),
          AppRoutes.products: (context) => const ProductsPage(),
          AppRoutes.productForm: (context) => const ProductFormPage(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
