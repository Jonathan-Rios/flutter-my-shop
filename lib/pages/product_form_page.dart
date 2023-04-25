import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:my_shop/models/product.dart';
import 'package:my_shop/models/product_list.dart';
import 'package:provider/provider.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();

  final _imageUrlController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        final product = arg as Product;

        _formData['id'] = product.id;
        _formData['name'] = product.name;
        _formData['price'] = product.price;
        _formData['description'] = product.description;
        _formData['imageUrl'] = product.imageUrl;

        _imageUrlController.text = product.imageUrl;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  bool isValidImageUrl(String url) {
    bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;

    bool endsWithFile = url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.jpeg') ||
        url.toLowerCase().endsWith('.gif');

    return isValidUrl && endsWithFile;
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();

    setState(() => _isLoading = true);

    try {
      // ? If you're outside of build method, you need to use Provider.of(context, listen: false)
      await Provider.of<ProductList>(
        context,
        listen: false,
      ).saveProduct(_formData);

      Navigator.of(context).pop();
    } catch (error) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('An error occurred!'),
          content: const Text('Something went wrong, try again later.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Product Form'),
          actions: [
            IconButton(
              onPressed: _submitForm,
              icon: const Icon(Icons.save),
            ),
          ],
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: _formData['name']?.toString(),
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                        ),
                        onSaved: (name) {
                          _formData['name'] = name ?? '';
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            // ? Trim to remove spaces, so if type "  " is invalid.
                            return 'Invalid title';
                          }

                          if (value.trim().length < 3) {
                            return 'Title must be at least 3 characters long';
                          }

                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _formData['price']?.toString(),
                        textInputAction: TextInputAction.next,
                        focusNode: _priceFocusNode,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Price',
                        ),
                        onSaved: (price) {
                          _formData['price'] = double.parse(price ?? '0');
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        validator: (value) {
                          final priceString = value ?? '';
                          final price = double.tryParse(priceString) ?? -1;

                          if (price <= 0) {
                            return 'Invalid price';
                          }

                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _formData['description']?.toString(),
                        textInputAction: TextInputAction.next,
                        focusNode: _descriptionFocusNode,
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                        ),
                        onSaved: (description) {
                          _formData['description'] = description ?? '';
                        },
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            // ? Trim to remove spaces, so if type "  " is invalid.
                            return 'Invalid description';
                          }

                          if (value.trim().length < 10) {
                            return 'Description must be at least 10 characters long';
                          }

                          return null;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Image URL',
                              ),
                              textInputAction: TextInputAction.done,
                              focusNode: _imageUrlFocusNode,
                              keyboardType: TextInputType.url,
                              controller: _imageUrlController,
                              onSaved: (imageUrl) {
                                _formData['imageUrl'] = imageUrl ?? '';
                              },
                              onFieldSubmitted: (_) => _submitForm(),
                              validator: (value) {
                                final imageUrl = value ?? '';

                                if (!isValidImageUrl(imageUrl)) {
                                  return 'Invalid Image URL';
                                }

                                return null;
                              },
                            ),
                          ),
                          Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.only(top: 8, left: 10),
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(width: 1, color: Colors.grey),
                                left: BorderSide(width: 1, color: Colors.grey),
                                right: BorderSide(width: 1, color: Colors.grey),
                                bottom:
                                    BorderSide(width: 1, color: Colors.grey),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: _imageUrlController.text.isEmpty ||
                                    !isValidImageUrl(_imageUrlController.text)
                                ? Text(
                                    _imageUrlController.text.isNotEmpty &&
                                            !isValidImageUrl(
                                                _imageUrlController.text)
                                        ? 'Invalid Image URL'
                                        : 'No Image Selected',
                                    textAlign: TextAlign.center,
                                  )
                                : Image.network(_imageUrlController.text),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ));
  }
}
