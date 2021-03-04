import 'package:flutter/material.dart';
import 'package:nws_app2/screens/explore_screen.dart';

import 'package:provider/provider.dart';

import './screens/tabs_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/select_location.dart';
import './services/database.dart';
import './screens/create_ad.dart';
import './models/category.dart';
import './models/product.dart';
import './provider/locations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<List<Product>>.value(value: Database().products),
        StreamProvider<List<Category>>.value(value: Database().categories),
        ChangeNotifierProvider(
          create: (context) => SelectCLocations(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Colors.white,
        ),
        // home: MyHomePage(title: 'Flutter Demo Home Page'),
        initialRoute: '/',
        routes: {
          '/': (ctx) => TabsScreen(),
          CreateAd.routeName: (ctx) => CreateAd(),
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          SelectLocation.routeName: (ctx) => SelectLocation(),
          ExploreScreen.routeName: (ctx) => ExploreScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
