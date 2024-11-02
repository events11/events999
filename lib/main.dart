import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/firebase_options.dart';
// ignore: unused_import
import 'screens/pagewa_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/signin_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ignore: prefer_const_constructors
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var screenRoute = PagewaScreen.screenRoute;
    return MaterialApp(
        title: 'MessageMe app',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: registrationScreen(),
        initialRoute: WelcomeScreen.screenRoute,
        routes: {
          WelcomeScreen.screenRoute: (context) => const WelcomeScreen(),
          RegistrationScreen.screenRoute: (context) =>
              const RegistrationScreen(),
          SignInScreen.screenRoute: (context) => const SignInScreen(),
          PagewaScreen.screenRoute: (context) => const PagewaScreen(),
        });
  }
}
