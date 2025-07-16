import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.star,
            size: 20,
          ),
          label: 'Main',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.settings_cell,
            size: 20,
          ),
          label: 'Log Out',
        ),
      ],
      fixedColor: Colors.deepPurple[200],
      onTap: (int idx) {
        switch (idx) {
          case 0:
          // do nothing
            break;
          case 1:
            Navigator.pushNamed(context, '/login');
            break;
        }
      },
    );
  }
}