import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nws_app2/screens/explore_screen.dart';
import 'package:provider/provider.dart';
import 'package:search_map_place/search_map_place.dart';

import '../provider/locations.dart';

class SelectLocation extends StatefulWidget {
  static const routeName = '/select-location';

  const SelectLocation({Key key}) : super(key: key);

  @override
  _SelectLocationState createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  String _addressLocation = '';
  String _cCoordinates = '';
  double _lat;
  double _long;
  int i = 0;
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

    setState(() {
      _addressLocation = "${first.subAdminArea}";
      _cCoordinates = cCoordinates.toString();
      _lat = cPosition.latitude;
      _long = cPosition.longitude;
    });
  }

  // @override
  // void didChangeDependencies() {
  //   Provider.of<SelectCLocations>(context).getCurrentPosition();
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    print('check1 - ${i + 1}');

    // Provider.of<SelectCLocations>(context, listen: true).getCurrent();
    final getLocation =
        Provider.of<SelectCLocations>(context).getCurrentPosition();

    final loc = Provider.of<SelectCLocations>(context);

    print('selectlocation ${loc.addressLocation}');

    return Scaffold(
        appBar: AppBar(
          title: Text('Location Selector'),
        ),
        body: Container(
          padding: EdgeInsets.only(top: 50.0),
          child: Column(
            children: [
              FlatButton.icon(
                onPressed: () {
                  // _getCurrentPosition();
                  loc.getCurrentPosition();
                  Navigator.pop(context);
                },
                icon: Icon(Icons.location_on),
                label: Text(_addressLocation),
              ),
              Divider(),
              SearchMapPlaceWidget(
                hasClearButton: true,
                placeType: PlaceType.address,
                placeholder: 'Enter the location',
                apiKey: 'AIzaSyDwFVe6XKdwtIx-3hxVM3F2eD8mbrkhoQs',
                onSelected: (Place place) async {
                  Geolocation geolocation = await place.geolocation;
                  LatLng latLng = geolocation.coordinates;

                  loc.setSelectedLocation = place.description;

                  setState(() {
                    _addressLocation = place.description;
                    _lat = latLng.latitude;
                    _long = latLng.longitude;
                  });

                  print(place.description);

                  print(geolocation.coordinates);
                  print(latLng.latitude);
                  print(latLng.longitude);
                  // Navigator.pop(context);
                  // mapController.animateCamera(
                  //     CameraUpdate.newLatLng(geolocation.coordinates));

                  // mapController.animateCamera(
                  //     CameraUpdate.newLatLngBounds(geolocation.bounds, 0));
                },
              ),
              Divider(),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text(loc.addressLocation.toString()),
              ),
            ],
          ),
        ));
  }
}
