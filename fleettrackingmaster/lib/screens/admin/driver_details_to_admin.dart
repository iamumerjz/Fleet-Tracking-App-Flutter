import 'package:flutter/material.dart';
import 'package:fleettrackingmaster/screens/admin/admin_setting_row.dart';

import '../../services/models.dart';
import '../customer/customer_tracking_trucker.dart';

class DriverDetailsToAdmin extends StatelessWidget {

  DriverDetailsToAdmin({required this.trucker, required this.img});
  final Trucker trucker;
  final String img;
  @override
  Widget build(BuildContext context) {
    Widget track = Text('');

    if(trucker.completedOrders > 0){
      trucker.status == "active"? track = ESRow(title: 'Track him Live', colorl: Colors.blueAccent.shade100, iconsSrc: img,):
      track = ESRow(title: "View last location", colorl: Colors.pinkAccent.shade100, iconsSrc: img,);
    }

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(.05),
                blurRadius: 5,
                spreadRadius: 5)
          ],
        ),
        child: ClipRRect(
          child: Stack(
            fit: StackFit.passthrough,
            alignment: Alignment.center,
            children: [
              Image.asset(
                img,
                fit: BoxFit.cover,
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.blueAccent.shade700.withOpacity(.9)
                        ])),
                child: Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        trucker.name.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      const SizedBox(height: 5,),
                      Text(
                        'Number Plate: ${trucker.numberPlate}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 5,),
                      Text(
                        'Email: ${trucker.email}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 5,),
                      Text(
                        'Orders Completed: ${trucker.completedOrders.toString()}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      SizedBox(height: 5,),
                      Text(
                        'Status: ${trucker.status.toString()}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                      SizedBox(height: 15,),
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder:(context)=>DriverLocation(driverEmail: trucker.email, status: trucker.status,)));
                        },
                          child: track
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
