import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:search_map_place/search_map_place.dart';

class SelectCLocations with ChangeNotifier {
  String _addressLocation = '';
  String _coordinates = '';
  double _latitude;
  double _longitude;

  String get addressLocation => _addressLocation;
  String get coordinates => _coordinates;
  double get latitude => _latitude;
  double get longitude => _longitude;

  void getCurrentPosition() async {
    final cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final cCoordinates = Coordinates(cPosition.latitude, cPosition.longitude);
    final address =
        await Geocoder.local.findAddressesFromCoordinates(cCoordinates);
    final first = address.first;

    _addressLocation = "${first.subAdminArea}";
    _coordinates = cCoordinates.toString();
    _latitude = cPosition.latitude;
    _longitude = cPosition.longitude;
    print('location $_addressLocation');
    // notifyListeners();
  }

  set setSelectedLocation(String address) {
    _addressLocation = address;
    print('checker $_addressLocation');
  }
}
