import 'package:flutter/material.dart';
import 'package:fleettrackingmaster/screens/admin/admin_setting_row.dart';
import 'package:fleettrackingmaster/services/auth.dart';

class AdminSetting extends StatelessWidget {
  const AdminSetting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blueAccent.shade100),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: (){
                AuthService().signOut();
                Navigator.pushNamedAndRemoveUntil(context, '/check', (route) => false);
              },
              child: ESRow(
                title: 'Sign Out',
                colorl: Colors.purpleAccent.shade100,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ESRow(
              title: 'Home    ',
              colorl: Colors.cyan.shade100,
            ),
          ],
        ),
      ),
    );
  }
}
