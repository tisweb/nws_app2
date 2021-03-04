import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:search_map_place/search_map_place.dart';
import 'package:tflite/tflite.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/category.dart';
import '../models/product.dart';

// import 'package:simple_color_picker/simple_color_picker.dart';
// import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import '../widgets/color_selector.dart';

// import 'package:path_provider/path_provider.dart';

class CreateAd extends StatefulWidget {
  static const routeName = '/create-ad';

  @override
  _CreateAdState createState() => _CreateAdState();
}

class _CreateAdState extends State<CreateAd> {
  final _controller = new TextEditingController();
  final _form = GlobalKey<FormState>();
  HSVColor color = HSVColor.fromColor(Colors.cyan);
  void onChanged(HSVColor value) => this.color = value;
  int group = 1;

  File pickedImage;
  List _output;
  var _prodId = '';
  var _prodName = '';
  var _catName = '';
  // var _color = '';
  var _prodDes = '';
  var _price = '';
  var _imageUrl = '';
  // var _locationCoordinates = '';
  var _categoryName = '';

  Color colorres;

  String _addressLocation = '';

  double _latitude;
  double _longitude;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final imageFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      pickedImage = File(imageFile.path);
    });
    runModelOnImage();

    // findLabels();
  }

  runModelOnImage() async {
    var output = await Tflite.runModelOnImage(
      path: pickedImage.path,
      imageMean: 127.5,
      imageStd: 127.5,
      numResults: 2,
      threshold: 0.8,
    );
    setState(() {
      _output = output;
      print('output $output');
      print('lenght ${output.length}');
    });
  }

  Future<void> findLabels() async {
    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(pickedImage);

    final ImageLabeler labeler = FirebaseVision.instance
        .imageLabeler(ImageLabelerOptions(confidenceThreshold: 0.95));

    final List<ImageLabel> labels = await labeler.processImage(visionImage);

    for (ImageLabel label in labels) {
      final String text = label.text;
      setState(() {
        _imageUrl = text;
      });

      print('image label : $text');
      return;
    }
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }

  Future<void> _postAds() async {
    final isValid = _form.currentState.validate();
    // FocusScope.of(context).unfocus();
    // final user = await FirebaseAuth.instance.currentUser();
    // final userData =
    //     await Firestore.instance.collection('users').document(user.uid).get();

    if (!isValid) {
      return;
    }
    _form.currentState.save();

    final ref = FirebaseStorage.instance
        .ref()
        .child('product_images')
        .child(_prodId + _prodName + _categoryName + '.jpg');

    await ref.putFile(pickedImage).onComplete;

    final urlImage = await ref.getDownloadURL();

    Firestore.instance.collection('products').add({
      'prodId': _prodId,
      'prodName': _prodName,
      'catName': _categoryName,
      'prodDes': _prodDes,
      'price': _price,
      'imageUrl': urlImage,
      'addressLocation': _addressLocation,
      'latitude': _latitude,
      'longitude': _longitude,

      // 'https://www.drivespark.com/images/2020-05/bmw-8-series-gran-coupe-exterior-11.jpg',
    });
    _controller.clear();
  }

  void _getCurrentPosition() async {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final coordinates = Coordinates(position.latitude, position.longitude);
    final address =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    final first = address.first;

    print(position);
    print(coordinates);
    print('${first.addressLine}');

    setState(() {
      _addressLocation = "${first.addressLine}";
      _latitude = position.latitude;
      _longitude = position.longitude;
    });
  }

  @override
  Widget build(BuildContext context) {
    _categoryName = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Ad'),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              RaisedButton(
                child: Text(
                  'Take Picture',
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
                onPressed: _pickImage,
                elevation: 2,
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 220,
                width: 100,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.grey,
                  ),
                ),
                child: pickedImage != null
                    ? FittedBox(
                        child: Image.file(pickedImage),
                        fit: BoxFit.cover,
                      )
                    : Align(
                        child: Text('Pick an Image to sell!'),
                        alignment: Alignment.center,
                      ),
              ),
              if (pickedImage != null)
                Container(
                  margin: EdgeInsets.all(10),
                  width: double.infinity,
                  child: Column(
                    children: [
                      _output == null
                          ? Text(" Select an Image to detect!")
                          : Text("${_output[0]["label"]}"),
                      // Text(_imageName),
                      Card(
                        child: SingleChildScrollView(
                          child: Form(
                            key: _form,
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  key: ValueKey('prodId'),
                                  decoration:
                                      InputDecoration(labelText: 'Product ID'),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter product id';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _prodId = value;
                                    print(_prodId);
                                  },
                                ),
                                TextFormField(
                                  key: ValueKey('prodName'),
                                  decoration: InputDecoration(
                                      labelText: 'Product Name'),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter product name';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _prodName = value;
                                  },
                                ),
                                // TextFormField(
                                //   key: ValueKey('catName'),
                                //   decoration: InputDecoration(
                                //       labelText: 'Category Name'),
                                //   validator: (value) {
                                //     if (value.isEmpty) {
                                //       return 'Please enter Category name';
                                //     }
                                //     return null;
                                //   },
                                //   onSaved: (value) {
                                //     _catName = value;
                                //     print(_catName);
                                //   },
                                // ),

                                // TextFormField(
                                //   key: ValueKey('color'),
                                //   decoration:
                                //       InputDecoration(labelText: 'Color'),
                                //   validator: (value) {
                                //     if (value.isEmpty) {
                                //       return 'Please enter color';
                                //     }
                                //     return null;
                                //   },
                                //   onSaved: (value) {
                                //     _color = value;
                                //   },
                                // ),

                                // CustomRadioButton(
                                //   elevation: 0,
                                //   absoluteZeroSpacing: true,
                                //   unSelectedColor: Theme.of(context).canvasColor,
                                //   buttonLables: [
                                //     '',
                                //     '',
                                //     '',
                                //   ],
                                //   buttonValues: [
                                //     "Red",
                                //     "Green",
                                //     "Blue",
                                //   ],
                                //   // buttonTextStyle: ButtonTextStyle(
                                //   //   selectedColor: Colors.white,
                                //   //   unSelectedColor: Colors.black,
                                //   //   textStyle: TextStyle(fontSize: 16),
                                //   // ),
                                //   radioButtonValue: (value) {
                                //     print(value);
                                //   },
                                //   selectedColor: Theme.of(context).accentColor,
                                //   customShape: RoundedRectangleBorder(
                                //       borderRadius: BorderRadius.circular(10)),
                                // ),

                                // SimpleColorPicker(
                                //     color: this.color,
                                //     onChanged: (value) => super.setState(
                                //           () => this.onChanged(value),
                                //         )),
                                // ColorSelector(colorres),

                                // Row(
                                //   children: <Widget>[
                                //     Radio(
                                //       value: 1,
                                //       groupValue: group,
                                //       focusColor: Colors.blue,
                                //       onChanged: (value) {
                                //         print(value);
                                //         setState(() {
                                //           group = value;
                                //         });
                                //       },
                                //       activeColor: Colors.red,
                                //     ),
                                //     Radio(
                                //       value: 2,
                                //       groupValue: group,
                                //       onChanged: (value) {
                                //         print(value);
                                //         setState(() {
                                //           group = value;
                                //         });
                                //       },
                                //     ),
                                //     Radio(
                                //       value: 3,
                                //       groupValue: group,
                                //       onChanged: (value) {
                                //         print(value);
                                //         setState(() {
                                //           group = value;
                                //         });
                                //       },
                                //     ),
                                //   ],
                                // ),

                                TextFormField(
                                  key: ValueKey('prodDes'),
                                  decoration: InputDecoration(
                                      labelText: 'Product Description'),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter product description';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _prodDes = value;
                                  },
                                ),
                                TextFormField(
                                  key: ValueKey('price'),
                                  decoration:
                                      InputDecoration(labelText: 'Price'),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter price';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _price = value;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SearchMapPlaceWidget(
                        hasClearButton: true,
                        placeType: PlaceType.address,
                        placeholder: 'Enter the location',
                        apiKey: 'AIzaSyDwFVe6XKdwtIx-3hxVM3F2eD8mbrkhoQs',
                        onSelected: (Place place) async {
                          Geolocation geolocation = await place.geolocation;
                          LatLng latLng = geolocation.coordinates;

                          setState(() {
                            _addressLocation = place.description;
                            _latitude = latLng.latitude;
                            _longitude = latLng.longitude;
                          });

                          print(place.description);

                          print(geolocation.coordinates);
                          print(latLng.latitude);
                          print(latLng.longitude);
                          // mapController.animateCamera(
                          //     CameraUpdate.newLatLng(geolocation.coordinates));

                          // mapController.animateCamera(
                          //     CameraUpdate.newLatLngBounds(geolocation.bounds, 0));
                        },
                      ),
                      FlatButton.icon(
                        onPressed: () {
                          _getCurrentPosition();
                        },
                        icon: Icon(Icons.my_location),
                        label: Text("Pick a location"),
                      ),
                      Text(_addressLocation),
                      RaisedButton(
                        onPressed: () {
                          // print(_catName);
                          _postAds();
                          Navigator.of(context).pop();
                        },
                        child: Text('Post Ad!'),
                      )
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
