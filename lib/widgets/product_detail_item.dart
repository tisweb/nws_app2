import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';

class ProductDetailItem extends StatefulWidget {
  final String productId;

  ProductDetailItem({this.productId});

  @override
  _ProductDetailItemState createState() => _ProductDetailItemState();
}

class _ProductDetailItemState extends State<ProductDetailItem> {
  @override
  Widget build(BuildContext context) {
    List<Product> products = Provider.of<List<Product>>(context);
    print(widget.productId);
    if (products != null) {
      products = products.where((e) => e.prodId == widget.productId).toList();
    } else {
      Text("Loading");
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 300,
            width: double.infinity,
            child: Image.network(
              products[0].imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
