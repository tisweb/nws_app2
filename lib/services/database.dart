import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/category.dart';
import '../models/product.dart';

class Database {
  final Firestore _fireStore = Firestore.instance;

  Stream<List<Product>> get products {
    return _fireStore
        .collection('products')
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.documents
            .map((DocumentSnapshot documentSnapshot) => Product(
                  prodId: documentSnapshot.data["prodId"],
                  prodName: documentSnapshot.data["prodName"],
                  catName: documentSnapshot.data["catName"],
                  prodDes: documentSnapshot.data["prodDes"],
                  price: documentSnapshot.data["price"],
                  imageUrl: documentSnapshot.data["imageUrl"],
                  addressLocation: documentSnapshot.data["addressLocation"],
                  latitude: documentSnapshot.data["latitude"],
                  longitude: documentSnapshot.data["longitude"],
                ))
            .toList());
  }

  Stream<List<Category>> get categories {
    return _fireStore
        .collection('categories')
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.documents
            .map((DocumentSnapshot documentSnapshot) => Category(
                  catId: documentSnapshot.data["catId"],
                  catName: documentSnapshot.data["catName"],
                  imageUrl: documentSnapshot.data["imageUrl"],
                ))
            .toList());
  }
}
