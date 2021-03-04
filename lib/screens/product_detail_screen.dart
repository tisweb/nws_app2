import 'package:flutter/material.dart';

import '../widgets/product_detail_item.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product-detail';

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  var _productId = '';

  @override
  Widget build(BuildContext context) {
    _productId = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text(_productId),
      ),
      body: ProductDetailItem(productId: _productId),
    );
  }
}
