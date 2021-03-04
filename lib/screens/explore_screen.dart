import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import '../provider/locations.dart';
import '../widgets/display_product_grid.dart';

import 'package:provider/provider.dart';

import '../models/category.dart';
import '../models/product.dart';
import '../screens/select_location.dart';

class ExploreScreen extends StatefulWidget {
  static const routeName = '/explore-screen';

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  List<Widget> containers = [
    Container(
      // child: DisplayProductGrid(),
      color: Colors.amber,
    ),
    Container(
      color: Colors.yellow,
    ),
    Container(
      color: Colors.pink,
    ),
    Container(
      color: Colors.purple,
    ),
    Container(
      color: Colors.cyan,
    ),
    Container(
      color: Colors.blueGrey,
    ),
    Container(
      color: Colors.indigo,
    ),
  ];

  String _addressLocations = '';
  String _cCoordinates = '';
  double _lat;
  double _long;

  bool _disposed = false;

  void _getCurrentPosition() async {
    final cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final cCoordinates = Coordinates(cPosition.latitude, cPosition.longitude);
    final address =
        await Geocoder.local.findAddressesFromCoordinates(cCoordinates);
    final first = address.first;

    print(cPosition);
    print(cCoordinates);
    print('${first.addressLine}');

    if (!_disposed) {
      setState(() {
        _addressLocations = "${first.subAdminArea}";
        _cCoordinates = cCoordinates.toString();
        _lat = cPosition.latitude;
        _long = cPosition.longitude;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = Provider.of<SelectCLocations>(context);
    List<Category> categoryList = [];
    categoryList = Provider.of<List<Category>>(context);

    // if (categoryList.isNotEmpty) {}
    // List<String> catNameList = categoryList.map((e) => e.catName).toList();

    // if (catNameList != null) {
    //   for (final categorys in catNameList) {
    //     print(categorys);
    //   }
    // }
    return DefaultTabController(
      length: categoryList == null ? 0 : categoryList.length,
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  // width: 500,
                  child: FlatButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushNamed(SelectLocation.routeName);
                    },
                    icon: Icon(Icons.location_on),
                    label: Text(loc.addressLocation),
                  ),
                ),
                SizedBox(
                  // width: 200,
                  child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(24.0)),
                    child: FlatButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.search),
                      label: Text(''),
                    ),
                  ),
                )
                // Container(
                //   // margin: EdgeInsets.all(10),
                //   width: double.infinity,
                //   height: 35,
                //   // color: Colors.white,
                //   decoration: BoxDecoration(
                //     color: Colors.grey[200],
                //     borderRadius: BorderRadius.circular(24.0),
                //   ),
                //   child: FlatButton.icon(
                //     onPressed: () {},
                //     icon: Icon(Icons.search),
                //     label: Text(
                //       'Search',
                //       style: TextStyle(color: Colors.grey[800]),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          bottom: TabBar(
            // tabs: [
            // for (final categories in categoryList)
            //   Tab(
            //     text: categories.catName,
            //   )

            //   Tab(
            //     text: '1',
            //   ),
            //   Tab(
            //     text: '1',
            //   ),
            //   Tab(
            //     text: '1',
            //   ),
            //   Tab(
            //     text: '1',
            //   ),
            //   Tab(
            //     text: '1',
            //   ),
            //   Tab(
            //     text: '1',
            //   ),
            //   Tab(
            //     text: '1',
            //   ),
            // ],
            tabs: List<Widget>.generate(
                categoryList == null ? 0 : categoryList.length, (index) {
              return Tab(
                text: categoryList[index].catName,
              );
            }),
            isScrollable: true,
            indicatorColor: Colors.blue[800],
            labelColor: Colors.blue[800],
            unselectedLabelColor: Colors.grey,
          ),
        ),
        body: TabBarView(
          // children: containers,
          children: List<Widget>.generate(
              categoryList == null ? 0 : categoryList.length, (index) {
            return Container(
              color: Colors.white,
              // child: Center(
              //   child: Text(categoryList[index].catName),
              // ),
              child: DisplayProductGrid(
                inCatName: categoryList[index].catName,
                inLat: _lat,
                inLong: _long,
                inAddressLocation: _addressLocations,
              ),
            );
          }),
        ),
      ),
    );
  }
}
