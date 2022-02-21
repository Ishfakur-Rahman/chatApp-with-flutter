import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/error_screen.dart';
import 'chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/componenets/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'Registration_Screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  late String messages;
  late final _newUser;

  Future<bool> registrationAuthentication() async {
    try {
      _newUser = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        messages = 'The password provided is too weak';
      } else if (e.code == 'email-already-in-use') {
        messages = 'The account already exist for that email';
      }
      // Navigator.pushNamed(
      //   context,
      //   ErrorGenerator.id,
      //   arguments: ErrorGenerator().setErrorMessage(messages),
      // );
      return false;
    } catch (e) {
      messages = 'Valid email address required';
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              child: Hero(
                tag: 'logo',
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
              style: TextStyle(
                color: Colors.black,
              ),
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                email = value;
              },
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'Enter your email',
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              style: TextStyle(
                color: Colors.black,
              ),
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              onChanged: (value) {
                password = value;
              },
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'Enter your password',
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            Hero(
              tag: 'register',
              child: RoundedButton(
                colour: Colors.blueAccent,
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      });
                  await registrationAuthentication();
                  if (_newUser != null) {
                    Navigator.pushNamed(context, ChatScreen.id);
                  }
                },
                title: 'Register',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
