import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fleettrackingmaster/shared/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:fleettrackingmaster/services/auth.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../services/firestore.dart';
import '../trucker/trucker_delivering_screen.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:location/location.dart';

class DeliveryScreen extends StatefulWidget {
  static const id = "Delivery_Details";
  const DeliveryScreen({Key? key}) : super(key: key);

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  TextEditingController _loc1Controller = TextEditingController();
  TextEditingController _loc2Controller = TextEditingController();
  TextEditingController timeInput = TextEditingController();
  String? sLong = "73.0059214";
  String? sLat = "33.6777844";
  String? eLat = "33.7138";
  String? eLong = "73.0247";

  @override
  void initState() {
    timeInput.text = ""; // set the initial value of the text field
    super.initState();
    getStartingLocation();
    checkIfActive();
  }

  void getStartingLocation() {
    Location location = Location();
    location.getLocation().then((value) {
      sLat = value.latitude.toString();
      sLong = value.longitude.toString();

      setState(() {
        _loc1Controller.text = sLat!;
        _loc2Controller.text = sLong!;
      });
    });
  }

  Future<void> checkIfActive() async {
    int isActive = await FirestoreService().checkIfActive(AuthService().user!.email!);
    if (isActive == 1) {
      Navigator.pushNamed(context, '/trucker');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Ensure Scaffold background is white
      body: SafeArea(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter Trip Details',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 30,
                  ),
                ),
                SizedBox(height: 25),
                TextField(
                  onChanged: (value) {
                    sLat = value;
                  },
                  controller: _loc1Controller,
                  decoration: InputDecoration(
                    hintText: "Current Location Latitude",
                    labelText: "Your Latitude",
                    suffixIcon: IconButton(
                      onPressed: () async {},
                      icon: const Icon(
                        Icons.location_on_rounded,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25),
                TextField(
                  onChanged: (value) {
                    sLong = value;
                  },
                  controller: _loc2Controller,
                  decoration: InputDecoration(
                    hintText: "Current Location Longitude",
                    labelText: "Your Longitude",
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.location_on_rounded,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25),
                TextField(
                  onChanged: (value) {
                    eLat = value;
                  },
                  decoration: InputDecoration(
                    hintText: "Destination Location Latitude",
                    labelText: "Destination Latitude",
                    suffixIcon: IconButton(
                      onPressed: () async {},
                      icon: const Icon(
                        Icons.location_on_rounded,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25),
                TextField(
                  onChanged: (value) {
                    eLong = value;
                  },
                  decoration: InputDecoration(
                    hintText: "Destination Location Longitude",
                    labelText: "Destination Longitude",
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.location_on_rounded,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25),
                TextField(
                  readOnly: true,
                  controller: timeInput,
                  decoration: InputDecoration(
                    hintText: "00:00:00",
                    labelText: "Start Time",
                    suffixIcon: IconButton(
                      onPressed: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                        );
                        if (pickedTime != null) {
                          print(pickedTime.format(context));
                          DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
                          String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);
                          setState(() {
                            timeInput.text = formattedTime; // set the value of the text field.
                          });
                        } else {
                          // print("Time is not selected");
                        }
                      },
                      icon: const Icon(
                        Icons.access_time,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await FirestoreService().startDelivery(sLat!, sLong!, eLat, eLong);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => TruckerDeliveryScreen(
                            originLatitude: double.tryParse(sLat!),
                            originLongitude: double.tryParse(sLong!),
                          ),
                        ),
                      );
                    } catch (e) {
                      log(e.toString());
                      final snackBar = FailureSnackbar(e.toString());
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(snackBar);
                    }
                  },
                  child: const Text(
                    "Start Delivery",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () async {
                    await AuthService().signOut();
                    Navigator.pushNamedAndRemoveUntil(context, '/check', (route) => false);
                  },
                  child: const Text(
                    "Sign Out",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
