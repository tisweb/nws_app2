import 'package:flutter/material.dart';
import 'package:nws_app2/widgets/display_category_grid.dart';

class SellScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category'),
      ),
      body: DisplayCategoryGrid(),
    );
  }
}
