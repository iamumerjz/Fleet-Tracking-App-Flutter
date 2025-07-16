import 'package:flutter/material.dart';
import 'package:fleettrackingmaster/screens/pre_app/check_screen.dart';

import '../login/login_screen.dart';

class Splash extends StatefulWidget {
  static const id ="splash";
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _afterSplash();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Image.asset("images/splash_1.png"),
    );

  }
  void _afterSplash() async {
    await Future.delayed(const Duration(seconds: 2), () {});
// ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const CheckScreen()));
  }
}