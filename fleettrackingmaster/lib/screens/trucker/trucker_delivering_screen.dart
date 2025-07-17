// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:fleettrackingmaster/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fleettrackingmaster/services/auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TruckerDeliveryScreen extends StatefulWidget {
  TruckerDeliveryScreen(
      {this.originLatitude = 33.6844, this.originLongitude = 73.0479});
  double? originLatitude, originLongitude;

  @override
  _TruckerDeliveryScreenState createState() => _TruckerDeliveryScreenState();
}

class _TruckerDeliveryScreenState extends State<TruckerDeliveryScreen> {
  late GoogleMapController mapController;

  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "YOUR_API_KEY";

  LocationData? currentLocation;

  double zoom = 14;

  @override
  void initState() {
    super.initState();
    getInitials();
    getCurrentLocation();
    updateLocationFireStore();
  }

  Future<void> getInitials() async {
    List<GeoPoint> geopoints = await FirestoreService().getInitials(email: AuthService().user!.email!);
    GeoPoint? start = geopoints[0];
    GeoPoint? end = geopoints[1];

    /// origin marker
    _addMarker(LatLng(start!.latitude, start!.longitude), "origin",
        BitmapDescriptor.defaultMarkerWithHue(45));

    /// destination marker
    _addMarker(LatLng(end!.latitude, end!.longitude), "destination",
        BitmapDescriptor.defaultMarkerWithHue(90));

    _getPolyline(start!, end!);
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //getInitials();

    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                    target:
                        LatLng(widget.originLatitude!, widget.originLongitude!),
                    zoom: 15),
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
              FloatingActionButton(
                backgroundColor: Colors.blueAccent.shade100,
                onPressed: endTask,
                child: Icon(Icons.close),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 220,
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
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
                                  "Status: Active",
                                  style: TextStyle(
                                      fontSize: 25,
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
        width: 8);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline(GeoPoint s, GeoPoint e) async {
    log('Fetching polyline for coordinates: (${s.latitude}, ${s.longitude}) to (${e.latitude}, ${e.longitude})');
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(s.latitude, s.longitude),
      PointLatLng(e.latitude, e.longitude),
      travelMode: TravelMode.driving,
    );
    log('Polyline API Result: ${result.status}');
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();

  }

  void getCurrentLocation() async {
    Location location = Location();
    location.getLocation().then(
      (location) {
        currentLocation = location;
        _addMarker(
            LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
            "current",
            BitmapDescriptor.defaultMarkerWithHue(0));
      },
    );

    //GoogleMapController googleMapController = await _controller.future;
    location.onLocationChanged.listen(
      (newLoc) {
        //log(newLoc.toString());
        currentLocation = newLoc;
        _addMarker(
            LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
            "current",
            BitmapDescriptor.defaultMarkerWithHue(0));
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: zoom,
              target: LatLng(
                newLoc.latitude!,
                newLoc.longitude!,
              ),
            ),
          ),
        );
        setState(() {});
      },
    );
  }

  void updateLocationFireStore() {
    log("before timer loop function");
    final ref = FirebaseFirestore.instance
        .collection('active')
        .doc(AuthService().user?.email);

    Timer? mytimer = Timer.periodic(Duration(seconds: 15), (timer) async {
      log(timer.tick.toString());
      log("Inside timer function");
      var docSnapshot = await ref.get();
      Map<String, dynamic>? data = docSnapshot.data();
      //d.log(data.toString());
      if (data!["status"] == "inactive") {
        timer.cancel();
        log("timer has been cancelled");
      }else{
        FirestoreService().updateLocationFireStore(
            currentLocation!.latitude!, currentLocation!.longitude!);
      }

    });
  }

  Future<void> endTask() async {
    await FirestoreService().endTask();
    Navigator.pushNamedAndRemoveUntil(context, '/check', (route) => false);
  }
}
