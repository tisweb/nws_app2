import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../screens/create_ad.dart';

class DisplayCategoryGrid extends StatefulWidget {
  @override
  _DisplayCategoryGridState createState() => _DisplayCategoryGridState();
}

class _DisplayCategoryGridState extends State<DisplayCategoryGrid> {
  @override
  Widget build(BuildContext context) {
    List<Category> categories = Provider.of<List<Category>>(context);

    return (categories != null)
        ? GridView.builder(
            padding: const EdgeInsets.all(10.0),
            // itemCount: categories == null ? 0 : categories.length,
            itemCount: categories.length,
            itemBuilder: (BuildContext context, int i) {
              return Column(
                children: [
                  Expanded(
                    flex: 9,
                    child: GridTile(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            CreateAd.routeName,
                            arguments: categories[i].catName,
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          child: Image.network(categories[i].imageUrl,
                              fit: BoxFit.fill),
                        ),
                      ),
                    ),
                  ),
                  Expanded(flex: 2, child: Text(categories[i].catName)),
                ],
              );
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 4 / 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
          )
        : Center(
            child: Text(
            'Categories being added! Please visit again later!',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ));
  }
}
