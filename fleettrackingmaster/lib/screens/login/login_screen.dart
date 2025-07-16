import 'package:flutter/material.dart';
import 'package:fleettrackingmaster/services/auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  static const id ="login_screen";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

bool _isObscure = true;

class _LoginScreenState extends State<LoginScreen> {

  String name = "", email="", password = "", numberPlate = "";
  bool saving = false;



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: saving,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 50, // to apply margin in the main axis of the wrap
                  runSpacing: 25,
                  children: [
                    Text(
                      'Fleet Tracker',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 35,
                          fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Log in to start a session',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 25),
                    ),
                    TextFormField(
                      onChanged: (value){
                        email = value;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          hintText: 'xyz@email.com',
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined)),
                    ),
                    TextFormField(
                      onChanged: (value){
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
                    TextFormField(
                      keyboardType: TextInputType.streetAddress,
                      decoration: const InputDecoration(
                          hintText: 'ABC-0123',
                          labelText: 'Truck Registration Number',
                          prefixIcon: Icon(Icons.fire_truck)),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                            setState((){
                              saving = true;
                            });
                            var user = await AuthService().emailLogin(email, password, context);
                            setState((){
                              saving = false;
                            });
                        },
                        child: const Text("Start Session",style: TextStyle(
                          color: Colors.white,
                        ),)),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: () async {

                          await AuthService().anonLogin();
                          Navigator.pushNamedAndRemoveUntil(context, '/usertracking', (route) => false);
                        },
                        child: const Text("Track your friend's Truck with email",style: TextStyle(
                          color: Colors.white,
                        ),)
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: ()  {
                             Navigator.pushNamed(context, '/adminlogin');
                        },
                        child: const Text("Admin Login",style: TextStyle(
                          color: Colors.white,
                        ),)
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: Text(
                          "Haven't Registered? Get Registered here",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 15,
                          ),
                        ),),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


}
