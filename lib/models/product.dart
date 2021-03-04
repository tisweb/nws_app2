import 'dart:ffi';

import 'package:geocoder/geocoder.dart';

class Product {
  String prodId;
  String prodName;
  String catName;
  String prodDes;
  String price;
  String imageUrl;
  String addressLocation;
  double latitude;
  double longitude;

  Product({
    this.prodId,
    this.prodName,
    this.catName,
    this.prodDes,
    this.price,
    this.imageUrl,
    this.addressLocation,
    this.latitude,
    this.longitude,
  });
}

class ProductDistance {
  String prodId;
  String prodName;
  String catName;
  String prodDes;
  String price;
  String imageUrl;
  String addressLocation;
  double latitude;
  double longitude;
  double distance;

  ProductDistance({
    this.prodId,
    this.prodName,
    this.catName,
    this.prodDes,
    this.price,
    this.imageUrl,
    this.addressLocation,
    this.latitude,
    this.longitude,
    this.distance,
  });
}
