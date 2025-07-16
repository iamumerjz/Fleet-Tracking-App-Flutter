import 'package:fleettrackingmaster/screens/register/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:fleettrackingmaster/screens/admin/admin_setting.dart';
import 'package:fleettrackingmaster/screens/delivery_trip_screen/delivery_info.dart';
import 'package:fleettrackingmaster/screens/admin/admin_login_screen.dart';
import 'package:fleettrackingmaster/screens/admin/admin_panel.dart';
import 'package:fleettrackingmaster/screens/customer/customer_tracking_trucker.dart';
import 'package:fleettrackingmaster/screens/login/login_screen.dart';
import 'package:fleettrackingmaster/screens/trucker/trucker_delivering_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fleettrackingmaster/screens/pre_app/check_screen.dart';
import 'package:fleettrackingmaster/screens/pre_app/splash.dart';
import 'package:fleettrackingmaster/screens/customer/user_searching_for_driver.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

import 'constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fleet Tracker',
      theme: kThemeData,
      routes: {
        '/':(context) => const Splash(),
        '/login':(context) => const LoginScreen(),
        '/register':(context) => const RegisterScreen(),
        '/trucker' : (context) => TruckerDeliveryScreen(),
        '/delivery': (context) => const DeliveryScreen(),
        '/usertracking':(context) => const UserSearching(),
        '/driverlocation':(context) => DriverLocation(driverEmail: '', status: '',),
        '/adminlogin':(context) => AdminLogin(),
        '/adminpanel': (context) => const AdminPanel(),
        '/adminsetting': (context) => const AdminSetting(),
        '/check': (context)=> const CheckScreen(),
      },
    );
  }
}
