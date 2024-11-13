// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:hello_world/screens/signup_screen.dart';
import 'welcome_screen.dart';

// ignore: unused_import
import 'pagewa_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationScreen extends StatefulWidget {
  static const String screenRoute = 'login_screen';
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController_emailController = TextEditingController();
  final TextEditingController_passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await _auth.signInWithEmailAndPassword(
        email: TextEditingController_emailController.text,
        password: TextEditingController_passwordController.text,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PagewaScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String errormessage = "Login failed";
      if (e.code == 'user-not-found') {
        errormessage = "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        errormessage = "Incorrect password.";
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Login Failed"),
          content: Text(errormessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 180,
              child: Image.asset('images/event1.webp'),
            ),
            const SizedBox(
              height: 50,
            ),
            TextField(
              controller: TextEditingController_emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Enter your email',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.yellow,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ), //هون بنعمل حلق لكلمة ادخل اليميسل
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ), //هون لما نظغط على ادخال الايميل بصير اغمق والحلق بصير لون ازرق
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              controller: TextEditingController_passwordController,
              obscureText: true,
              /*onChanged: (value) {
                password = value;
              },*/
              decoration: const InputDecoration(
                hintText: 'Enter your password',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.yellow,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ), //هون بنعمل حلق لكلمة ادخل اليميسل
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ), //هون لما نظغط على ادخال الايميل بصير اغمق والحلق بصير لون ازرق
                ),
              ),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: Text('Login'),
                  ),
            /*Mybutton(
                color: Colors.blue,
                title: 'Log in',
                onpressed: () async {
                  //print(email);
                  //print(password);

                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: TextEditingController_emailController.text.trim(),
                      password:
                          TextEditingController_passwordController.text.trim());
                })*/
          ],
        ),
      ),
    );
  }
}

/*class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SignInScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Welcome to the Home Screen!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}*/