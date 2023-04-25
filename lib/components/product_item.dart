import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_shop/models/product.dart';
import 'package:my_shop/models/product_list.dart';
import 'package:my_shop/utils/app_routes.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
          leading: CircleAvatar(
            backgroundColor: const Color.fromARGB(255, 231, 231, 231),
            backgroundImage: NetworkImage(product.imageUrl),
          ),
          title: Text(product.name),
          subtitle: Text('\$ ${product.price.toStringAsFixed(2)}'),
          trailing: SizedBox(
            width: 100,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      AppRoutes.productForm,
                      arguments: product,
                    );
                  },
                  color: Theme.of(context).colorScheme.primary,
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Are you sure?'),
                        content: const Text(
                            'If you confirm, the product will be deleted.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    ).then((confirmed) async {
                      if (confirmed) {
                        try {
                          await Provider.of<ProductList>(
                            context,
                            listen: false,
                          ).removeProduct(product);
                        } on HttpException catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(error.toString()),
                            ),
                          );
                        }
                      }
                    });
                  },
                  color: Theme.of(context).colorScheme.error,
                ),
              ],
            ),
          )),
    );
  }
}
