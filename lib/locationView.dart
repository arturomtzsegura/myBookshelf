import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class LocationView extends StatefulWidget {
  final double latitude;
  final double longitude;

  LocationView({required this.latitude, required this.longitude});

  @override
  _LocationViewState createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> {

  late GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location'),
        backgroundColor: Colors.brown,
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.latitude, widget.longitude),
          zoom: 16.0,
        ),
        markers: {
          Marker(
            markerId: MarkerId('locationMarker'),
            position: LatLng(widget.latitude, widget.longitude),
          ),
          Marker(
            markerId: MarkerId('locationMarker1'),
            position: LatLng(22.144339,-101.015452),
          ),
        },
      ),
    );
  }
}
