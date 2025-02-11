import 'package:geocoding/geocoding.dart'
    show Placemark, placemarkFromCoordinates;
import 'package:wecount/shared/header.dart';
import 'package:wecount/shared/loading_indicator.dart';
import 'package:wecount/utils/service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationView extends StatefulWidget {
  const LocationView({Key? key}) : super(key: key);

  @override
  State<LocationView> createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> {
  late GoogleMapController mapController;
  LatLng? _center;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  late Set<Marker> _markerSet;
  late String _countryCode;

  @override
  void initState() {
    _countryCode = WidgetsBinding.instance.window.locale.countryCode!;
    super.initState();
    getCurrentLocation();
  }

  /// Open up google place search screen. The `_countryCode` is used to query google places.
  ///
  /// Get `lat` and `lng` from the places search.
  /// Move camera and set markers when there is a result.
  ///
  void getPlace() async {
    var location = await GooglePlaceService.instance.showGooglePlaceSearch(
      context,
      country: _countryCode,
    );

    if (location['lat'] != null && location['lng'] != null) {
      var latLng = LatLng(location['lat'], location['lng']);
      _setMarker(latLng);

      setState(() => _center = latLng);

      CameraUpdate cameraUpdate = CameraUpdate.newLatLng(latLng);
      mapController.moveCamera(cameraUpdate);
    }
  }

  /// Get current location with `location` plugin.
  ///
  /// This will request permission in android when it's not granted.
  /// When permission is granted, it will get current location by calling `getLocation`,
  /// and set markers when result is achieved.
  ///
  /// It also fetches current `countryCode` to be used when searching google places.
  ///
  void getCurrentLocation() async {
    LocationData? currentLocation;
    String? error;

    var location = Location();

    try {
      currentLocation = await location.getLocation();
    } catch (e) {
      // if (e.currency == 'PERMISSION_DENIED') {
      //   error = 'Permission denied';
      // }
      currentLocation = null;
    }

    if (error == null && currentLocation != null) {
      final LatLng latLng =
          LatLng(currentLocation.latitude!, currentLocation.longitude!);
      _setMarker(latLng);

      setState(() => _center = latLng);
      return;
    }

    setState(() => _center = const LatLng(0, 0));
  }

  void _setMarker(LatLng latLng) {
    MarkerId markerId = const MarkerId('myMarker');

    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: latLng,
    );

    markers[markerId] = marker;

    setState(() {
      _markerSet = Set<Marker>.of(markers.values);
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onCameraMoved(CameraPosition pos) => _setMarker(pos.target);

  @override
  Widget build(BuildContext context) {
    return _center == null
        ? const LoadingIndicator()
        : Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: renderHeaderClose(
              context: context,
              brightness: Theme.of(context).brightness,
              actions: [
                /// The button that calls `getPlace` method when pressed.
                SizedBox(
                  width: 56.0,
                  child: RawMaterialButton(
                    padding: const EdgeInsets.all(0.0),
                    shape: const CircleBorder(),
                    onPressed: () => getPlace(),
                    child: Icon(
                      Icons.search,
                      color: Theme.of(context).textTheme.headline1!.color,
                    ),
                  ),
                ),

                /// The button that `findAddressesFromCoordinates` when pressed.
                ///
                /// returns `address` and `latlng` and pop current [Screen].
                SizedBox(
                  width: 56.0,
                  child: RawMaterialButton(
                    padding: const EdgeInsets.all(0.0),
                    shape: const CircleBorder(),
                    onPressed: () async {
                      List<Placemark> addresses =
                          await placemarkFromCoordinates(
                        _center!.latitude,
                        _center!.longitude,
                      );
                      Map<String, dynamic> result = {};
                      result['address'] = addresses.first.street;
                      result['latlng'] = _center;

                      // ignore: use_build_context_synchronously
                      Navigator.pop(context, result);
                    },
                    child: Icon(
                      Icons.check,
                      color: Theme.of(context).textTheme.headline1!.color,
                    ),
                  ),
                ),
              ],
            ),
            body: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center!,
                zoom: 11.0,
              ),
              markers: _markerSet,
              onCameraMove: _onCameraMoved,
            ),
          );
  }
}
