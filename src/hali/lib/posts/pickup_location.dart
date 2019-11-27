import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hali/commons/styles.dart';
import 'package:hali/constatns/constants.dart';
import 'package:hali/models/location_result.dart';
import 'package:hali/utils/color_utils.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hali/utils/loading_builder.dart';
import 'package:hali/utils/location_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class PickupLocationScreen extends StatefulWidget {
  @override
  _PickupLocationState createState() => _PickupLocationState();
}

class _PickupLocationState extends State<PickupLocationScreen> {
  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center =  LatLng(10.779783, 106.6968148);

  final Set<Marker> _markers = {};

  LatLng _lastMapPosition = _center;

  String _address;

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
    LocationProvider.of(context)
        .setLastIdleLocation(_lastMapPosition);
  }

  Future<void> getLocation() async {
    PermissionStatus permissionStatus = await PermissionHandler().checkPermissionStatus(PermissionGroup.location);

    if (permissionStatus == PermissionStatus.denied) {
      await PermissionHandler()
          .requestPermissions([PermissionGroup.locationAlways]);
    }

    var geolocator = Geolocator();
    GeolocationStatus geolocationStatus =
    await geolocator.checkGeolocationPermissionStatus();
    switch (geolocationStatus) {
      case GeolocationStatus.denied:
        print('denied');
        break;
      case GeolocationStatus.disabled:
      case GeolocationStatus.restricted:
        print('restricted');
        break;
      case GeolocationStatus.unknown:
        print('unknown');
        break;
      case GeolocationStatus.granted:
        await Geolocator()
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
            .then((Position _position) {
          if (_position != null) {
            setState((){
              _lastMapPosition = LatLng(_position.latitude, _position.longitude,);
            });
          }
        });
        break;
    }
  }

  void _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        infoWindow: InfoWindow(
          title: 'Really cool place',
          snippet: '5 Star Rating',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }
  
  @override
  void initState() {
    super.initState();
    getLocation();
  }

  Center pin() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.place, size: 56, color: ColorUtils.hexToColor(colorD92c27),),
          Container(
            decoration: ShapeDecoration(
              shadows: [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 4,
                ),
              ],
              shape: CircleBorder(
                side: BorderSide(
                  width: 4,
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
          SizedBox(height: 56),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Pickup Location', style: Styles.getSemiboldStyle(14, Colors.black87),),
          backgroundColor: Colors.white,
          
          leading: IconButton(
              icon: Icon(Icons.close, color: Colors.black87,),
              onPressed: () => Navigator.of(context).pop()
          ),
        ),
        body: Stack(
          children: <Widget>[
            //Google Map
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
              markers: _markers,
              onCameraMove: _onCameraMove,
              onCameraIdle: () async {
                print("onCameraIdle#_lastMapPosition = $_lastMapPosition");
              },
            ),
            pin(),
          ],
        )
      ),
    );
  }

  Future<String> getAddress(LatLng location) async {
    try {
      var endPoint =
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=${location?.latitude},${location?.longitude}&key=${apiKey}';
      var response = jsonDecode((await http.get(endPoint)).body);

      return response['results'][0]['formatted_address'];
    } catch (e) {
      print(e);
    }

    return null;
  }

  Widget locationCard() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Consumer<LocationProvider>(
                builder: (context, locationProvider, _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        flex: 20,
                        child: FutureLoadingBuilder<String>(
                            future: getAddress(locationProvider.lastIdleLocation),
                            mutable: true,
                            loadingIndicator: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                CircularProgressIndicator(),
                              ],
                            ),
                            builder: (context, address) {
                              _address = address;
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    address ?? 'Unnamed place',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ),
                      Spacer(),
                      FloatingActionButton(
                        onPressed: () {
                          Navigator.of(context).pop({
                            'location': LocationResult(
                              latLng: locationProvider.lastIdleLocation,
                              address: _address,
                            )
                          });
                        },
                        child: Icon(Icons.arrow_forward, color: Colors.white),
                      ),
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}