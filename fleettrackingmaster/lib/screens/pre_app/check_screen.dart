import 'dart:developer';

import 'package:fleettrackingmaster/screens/customer/user_searching_for_driver.dart';
import 'package:flutter/material.dart';
import 'package:fleettrackingmaster/screens/admin/admin_panel.dart';
import 'package:fleettrackingmaster/screens/login/login_screen.dart';

import '../../services/auth.dart';
import '../../shared/error.dart';
import '../../shared/loading.dart';
import '../delivery_trip_screen/delivery_info.dart';

class CheckScreen extends StatelessWidget {
  const CheckScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().userStream, // when user changes builder will run again
      builder: (context, snapshot) {
        // log('User ${AuthService().user.toString()}');
        if (snapshot.connectionState == ConnectionState.waiting) {
          log("connection state is waiting");
          return Loader();
        } else if (snapshot.hasError) {
          log(snapshot.error.toString());
          return  Center(
            child: ErrorMessage(message: snapshot.error.toString()),
          );
        } else if (snapshot.hasData) { // user is logged in
          if (AuthService().user?.isAnonymous == true){ // guest who wants to track a trucker
            return UserSearching();
          }
          return AuthService().user!.email.toString() == "radcowboy@gmail.com"?
               AdminPanel(): //admin
               DeliveryScreen(); // a trucker
        } else { //user is null
          return LoginScreen();
        }
      },
    );
  }
}