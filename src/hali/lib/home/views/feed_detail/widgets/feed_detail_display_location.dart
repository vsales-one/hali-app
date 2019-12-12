import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hali/constants/constants.dart';
import 'package:uuid/uuid.dart';

class FeedDetailDisplayLocation extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String userName;

  FeedDetailDisplayLocation(
      {Key key, this.latitude, this.longitude, this.userName})
      : super(key: key);

  @override
  _FeedDetailDisplayLocationtate createState() =>
      _FeedDetailDisplayLocationtate();
}

class _FeedDetailDisplayLocationtate extends State<FeedDetailDisplayLocation> {
  GoogleMapController mapController;
  final Set<Marker> _markers = {};

  void _onAddMarkerButtonPressed() {
    _markers.add(Marker(
      // This marker id can be anything that uniquely identifies each marker.
      markerId: MarkerId(Uuid().v4()),
      position: LatLng(widget.latitude ?? kDefaultLatitude, widget.longitude ?? kDefaultLongitude),
      infoWindow: InfoWindow(
        title: widget.userName,
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));
  }

  @override
  void initState() {
    super.initState();
    _onAddMarkerButtonPressed();
  }

  @override
  void dispose() {    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              initialCameraPosition: CameraPosition(
                target: LatLng(widget.latitude ?? kDefaultLatitude, widget.longitude ?? kDefaultLongitude),
                zoom: 15
              ),
            ),
          )),
    );
  }
}
