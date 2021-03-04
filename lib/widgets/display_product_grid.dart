import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../screens/product_detail_screen.dart';

class DisplayProductGrid extends StatefulWidget {
  final String inCatName;
  final double inLat;
  final double inLong;
  final String inAddressLocation;

  DisplayProductGrid({
    this.inCatName,
    this.inLat,
    this.inLong,
    this.inAddressLocation,
  });

  String addressLocation = '';
  void _getCurrentPosition() async {
    final coordinates = Coordinates(inLat, inLong);
    final address =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    final first = address.first;

    addressLocation = "${first.subAdminArea}";
  }

  @override
  _DisplayProductGridState createState() => _DisplayProductGridState();
}

// @override
// void initState() {
//   _getCurrentPosition();
//   super.initState();
// }

class _DisplayProductGridState extends State<DisplayProductGrid> {
  @override
  Widget build(BuildContext context) {
    ProductDistance prodDis = ProductDistance();
    List<Product> products = Provider.of<List<Product>>(context);
    List<ProductDistance> productDistance = [];

    print(widget.inCatName);
    if (products != null) {
      products = products.where((e) => e.catName == widget.inCatName).toList();

      for (var i = 0; i < products.length; i++) {
        ProductDistance prodDis = ProductDistance();
        print('check11');

        double distance = Geolocator.distanceBetween(widget.inLat,
                widget.inLong, products[i].latitude, products[i].longitude) /
            1000.round();
        print('check12');

        prodDis.prodId = products[i].prodId;
        prodDis.prodName = products[i].prodName;
        prodDis.catName = products[i].catName;
        prodDis.prodDes = products[i].prodDes;
        prodDis.price = products[i].price;
        prodDis.imageUrl = products[i].imageUrl;
        prodDis.addressLocation = products[i].addressLocation;
        prodDis.latitude = products[i].latitude;
        prodDis.longitude = products[i].longitude;
        prodDis.distance = distance;

        productDistance.add(prodDis);
        print('Name $i- ${productDistance[i].prodName}');
      }
      print(productDistance.length);
    } else {
      Text("Loading");
    }

    print('lenght - ${productDistance.length}');
    // print('Name 0 - ${productDistance[0].prodName}');
    // print('Name 1 - ${productDistance[1].prodName}');

    productDistance.sort((a, b) {
      var aDistance = a.distance;
      var bDistance = b.distance;
      return aDistance.compareTo(bDistance);
    });

    return (productDistance != null)
        ? GridView.builder(
            padding: const EdgeInsets.all(10.0),
            // itemCount: prodByCat == null ? 0 : prodByCat.length,
            itemCount: productDistance.length,
            itemBuilder: (BuildContext context, int j) {
              return Column(
                children: [
                  Expanded(
                    flex: 9,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            ProductDetailScreen.routeName,
                            arguments: productDistance[j].prodId);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        child: Image.network(productDistance[j].imageUrl,
                            fit: BoxFit.fill),
                      ),
                    ),
                  ),
                  Expanded(flex: 2, child: Text(productDistance[j].prodName)),
                  Expanded(flex: 2, child: Text(widget.addressLocation)),
                  // Expanded(
                  //     flex: 2,
                  //     child: Text(productDistance[j].latitude.toString())),
                  // Expanded(
                  //     flex: 2,
                  //     child: Text(productDistance[j].longitude.toString())),
                  Expanded(
                    flex: 2,
                    child: Text(
                      (Geolocator.distanceBetween(
                                  widget.inLat,
                                  widget.inLong,
                                  productDistance[j].latitude,
                                  productDistance[j].longitude) /
                              1000)
                          .round()
                          .toString(),
                    ),
                  ),
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
            // child: Text(
            //   'Products being added in this category! Please visit again later!',
            //   style: TextStyle(
            //     color: Theme.of(context).primaryColor,
            //     fontSize: 20,
            //   ),
            //   textAlign: TextAlign.center,
            // ),
            child: CircularProgressIndicator(),
          );
  }
}
