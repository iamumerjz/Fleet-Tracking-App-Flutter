import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fleettrackingmaster/services/auth.dart';
import 'package:fleettrackingmaster/services/firestore.dart';
import 'package:fleettrackingmaster/shared/snackbars.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AdminLogin extends StatefulWidget {
  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  String username = "", secretkey = "", password = "";
  bool saving = false;
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: saving,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          iconTheme: const IconThemeData(color: Colors.white)
        ),
        body: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Welcome Admin',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              TextFormField(
                onChanged: (value) {
                  username = value;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'UserName',
                  labelText: 'UserName',
                  prefixIcon: Icon(Icons.star),
                ),
              ),
              const SizedBox(height: 25),
              TextFormField(
                onChanged: (value) {
                  password = value;
                },
                keyboardType: TextInputType.visiblePassword,
                obscureText: _isObscure,
                decoration: InputDecoration(
                  hintText: 'Password',
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                    icon: Icon(
                      _isObscure ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                  prefixIcon: const Icon(Icons.password),
                ),
              ),
              const SizedBox(height: 25),
              TextFormField(
                onChanged: (value) {
                  secretkey = value;
                },
                keyboardType: TextInputType.streetAddress,
                decoration: const InputDecoration(
                  hintText: 'xxzz',
                  labelText: 'Secret Key',
                  prefixIcon: Icon(Icons.security),
                ),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () async {
                  try {
                    setState(() {
                      saving = true;
                    });
                    int result = await FirestoreService().AdminLogin(username, secretkey, password);
                    if (result == 1) {
                      await AuthService().emailLogin("221375@students.au.edu.pk", "221435", context);
                      Navigator.pushNamedAndRemoveUntil(context, '/adminpanel', (route) => false);
                    } else {
                      final snackBar = FailureSnackbar("No Admin Exists with these credentials");
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(snackBar);
                    }
                    setState(() {
                      saving = false;
                    });
                  } catch (e) {
                    setState(() {
                      saving = false;
                    });
                    log(e.toString());
                    final snackBar = FailureSnackbar(e.toString());
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(snackBar);
                  }
                },
                child: const Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
