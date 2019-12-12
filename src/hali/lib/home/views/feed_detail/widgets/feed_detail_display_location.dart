import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

class FeedDetailDisplayLocation extends StatelessWidget {
  final double lati;
  final double long;
  final String userName;
  GoogleMapController mapController;

  final Set<Marker> _markers = {};

  FeedDetailDisplayLocation({this.lati, this.long, this.userName});

  void _onAddMarkerButtonPressed() {
    _markers.add(Marker(
      // This marker id can be anything that uniquely identifies each marker.
      markerId: MarkerId(Uuid().v4()),
      position: new LatLng(lati, long),
      infoWindow: InfoWindow(
        title: userName,
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));
  }

  @override
  Widget build(BuildContext context) {
    _onAddMarkerButtonPressed();

    return SliverToBoxAdapter(
      child: SizedBox(
          height: 300,
          child: Container(
            margin: EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 16),
            child: GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
              markers: _markers,
              initialCameraPosition: new CameraPosition(
                target: LatLng(lati, long),
              ),
            ),
          )),
    );
  }
}
