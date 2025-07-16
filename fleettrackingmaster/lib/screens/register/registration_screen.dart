import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fleettrackingmaster/services/auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'package:fleettrackingmaster/shared/snackbars.dart';
import 'package:fleettrackingmaster/services/firestore.dart';

class RegisterScreen extends StatefulWidget {
  static const id = "signup_screen";
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  final _auth = FirebaseAuth.instance;
  bool saving = false;
  String name = "", email = "", password = "", numberPlate = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get Registered',style: TextStyle(
          color: Colors.white,
        ),),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.secondary,
          iconTheme: const IconThemeData(color: Colors.white)
      ),
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: saving,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              child: SingleChildScrollView(
                child: Wrap(
                  //spacing: 50, // to apply margin in the main axis of the wrap
                  runSpacing: 20,
                  children: [
                    Text(
                      'Fleet Tracker',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 45),
                    ),
                    TextFormField(
                      onChanged: (value) {
                        name = value;
                      },
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                          hintText: 'Full Name',
                          labelText: 'Full Name',
                          prefixIcon: Icon(Icons.person_outline_sharp)),
                    ),
                    TextFormField(
                      onChanged: (value) {
                        email = value;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          hintText: 'xyz@email.com',
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined)),
                    ),
                    passwordTextField(),
                    TextFormField(
                      onChanged: (value) {
                        numberPlate = value;
                      },
                      keyboardType: TextInputType.streetAddress,
                      decoration: const InputDecoration(
                          hintText: 'ABC-0123',
                          labelText: 'Truck Registration Number',
                          prefixIcon: Icon(Icons.fire_truck)),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            saving = true;
                          });
                          try {
                            await AuthService().registerUser(email, password); // register a user
                            await FirestoreService().completeUser(
                                name,
                                numberPlate,
                                email); //stores his basics in document
                            setState(() {
                              saving = false;
                            });

                            final snackBar = SuccessSnackbar(
                                "Account Created!", Colors.cyan);
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(snackBar);

                            Navigator.pushNamedAndRemoveUntil(context, '/check', (route) => false);
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
                        "Register",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField passwordTextField() {
    return TextFormField(
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
    );
  }
}
