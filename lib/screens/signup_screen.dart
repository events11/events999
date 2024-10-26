import 'package:flutter/material.dart';
import 'welcome_screen.dart';

class SignInScreen extends StatefulWidget {
  static const String screenRoute = 'signIn_screen';
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInState();
}

class _SignInState extends State<SignInScreen> {
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
            SizedBox(height: 180, child: Image.asset('images/event1.webp')),
            const SizedBox(
              height: 20,
            ),
            TextField(
              onChanged: (value) {},
              decoration: InputDecoration(
                  hintText: 'user name',
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[900]!, width: 4),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  )),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {},
              decoration: InputDecoration(
                  hintText: 'enter your E-MAIL',
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[900]!, width: 4),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  )),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              obscureText: true,
              onChanged: (value) {},
              decoration: InputDecoration(
                  hintText: 'enter your password',
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[900]!, width: 4),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  )),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              obscureText: true,
              onChanged: (value) {},
              decoration: InputDecoration(
                  hintText: 'return your password',
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[900]!, width: 4),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            Mybutton(
                color: Colors.yellow[700]!, title: 'sign in ', onpressed: () {})
          ],
        ),
      ),
    );
  }
}
