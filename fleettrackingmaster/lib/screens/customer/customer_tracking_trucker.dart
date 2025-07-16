// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../services/firestore.dart';

class DriverLocation extends StatefulWidget {
  String driverEmail, status;
  DriverLocation({required this.driverEmail, this.status="active"});

  @override
  _DriverLocationState createState() {
    return _DriverLocationState();
  }
}

class _DriverLocationState extends State<DriverLocation> {


  late GoogleMapController mapController;

  double _originLatitude = 33.6844, _originLongitude = 73.0479;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyC_v_vd68YlACpkKbLHgTQqNYC-OZY41_k";
  double zoom = 14;

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getInitials();
  }

  Future<void> getInitials() async {
    List<GeoPoint> geopoints = await FirestoreService().getInitials(email: widget.driverEmail,);
    GeoPoint? start = geopoints[0];
    GeoPoint? end = geopoints[1];
    GeoPoint? current = geopoints[2];

    /// origin marker
    _addMarker(LatLng(start.latitude, start.longitude), "origin",
        BitmapDescriptor.defaultMarkerWithHue(45));

    /// destination marker
    _addMarker(LatLng(end.latitude, end.longitude), "destination",
        BitmapDescriptor.defaultMarkerWithHue(90));

    BitmapDescriptor img = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(100, 100)), 'images/img_1.png');

    _addMarker(LatLng(current.latitude, current.longitude), "current", img);

    _getPolyline(start, end);
    setState(() {
      _originLatitude = current.latitude;
      _originLongitude = current.longitude;
    });
    getActiveLocation();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                  target: LatLng(_originLatitude, _originLongitude), zoom: 15),
              myLocationEnabled: true,
              tiltGesturesEnabled: false,
              compassEnabled: true,
              scrollGesturesEnabled: true,
              zoomGesturesEnabled: true,
              onMapCreated: _onMapCreated,
              markers: Set<Marker>.of(markers.values),
              polylines: Set<Polyline>.of(polylines.values),
              onCameraMove: (CameraPosition cameraPosition) {
                zoom = cameraPosition.zoom;
              },
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.deepPurple,
                      Colors.blueAccent.shade200,
                    ],
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage("images/img.png"),
                        radius: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.star_border_outlined,
                              color: Colors.white, size: 50),
                          Column(
                            children: [
                              Text(
                                "Status: ${widget.status}",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                          Icon(
                            Icons.star_border_outlined,
                            color: Colors.white,
                            size: 50,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.lightBlueAccent,
        points: polylineCoordinates,
        width: 8 );
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline(GeoPoint s, GeoPoint e) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(s.latitude, s.longitude),
      PointLatLng(e.latitude, e.longitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }

  void getActiveLocation() async {
    final docRef =
        FirebaseFirestore.instance.collection("active").doc(widget.driverEmail);
    GeoPoint? current;
    MarkerId markerId = MarkerId("current");
    docRef.snapshots().listen(
      (event) {
        //log("current data: ${event.data()}");
        Map<String, dynamic>? data = event.data();
        data?.forEach((k, v) {
          //log("$k  $v");
          if (k.toString() == "currentLocation") {
            current = v as GeoPoint?;
          }
        });
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: zoom,
              target: LatLng(
                current!.latitude,
                current!.longitude,
              ),
            ),
          ),
        );
        setState(() {
          markers[markerId] = markers[markerId]!.copyWith(
              positionParam: LatLng(current!.latitude, current!.longitude));
        });
      },
      onError: (error) => log("Listen failed: $error"),
    );
  }
}
