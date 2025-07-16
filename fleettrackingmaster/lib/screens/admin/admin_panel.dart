import 'package:flutter/material.dart';
import 'package:fleettrackingmaster/services/firestore.dart';

import '../../services/models.dart';
import '../../shared/bottom_nav.dart';
import 'driver_details_to_admin.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({Key? key}) : super(key: key);

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set Scaffold background color to white
      bottomNavigationBar: BottomNavBar(),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent.shade100,
        automaticallyImplyLeading: true, // Show back button
      ),
      body: Column(
        children: [
          Expanded(child: DriverRow()), // Ensure DriverRow takes available space
        ],
      ),
    );
  }
}

class DriverRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Trucker>>(
      future: FirestoreService().getTruckers(), // we have users!!!
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Widget> driversList = [];
          var truckers = snapshot.data;
          int idx = 1;
          for (var trucker in truckers!) {
            driversList.add(link(trucker: trucker, img: "images/img$idx.jpg"));
            driversList.add(SizedBox(height: 10));
            idx = (idx % 8) + 1;
          }
          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: driversList,
          );
        }
        return Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.blueAccent,
          ),
        );
      },
    );
  }
}

class link extends StatelessWidget {
  final Trucker trucker;
  final String img;
  link({required this.trucker, required this.img});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DriverDetailsToAdmin(trucker: trucker, img: img),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.pinkAccent.shade100,
              Colors.blueAccent.shade100,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(img),
                radius: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.star_border_outlined, color: Colors.white, size: 50),
                  Column(
                    children: [
                      Text(
                        trucker.name.toString().toUpperCase(),
                        style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.fade,
                      ),
                      Text(
                        "Plate: ${trucker.numberPlate}",
                        style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "Status: ${trucker.status}",
                        style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Icon(Icons.star_border_outlined, color: Colors.white, size: 50),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
