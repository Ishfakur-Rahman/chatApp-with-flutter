import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/componenets/rounded_button.dart';
import 'registration_screen.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'Welcome_Screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  //Animation uses
  // late AnimationController controller;
  // late Animation animation;
  // @override
  // void initState() {
  //   super.initState();
  //   controller = AnimationController(
  //     duration: const Duration(seconds: 1),
  //     vsync: this,
  //   );
  //   animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
  //       .animate(controller);
  //
  //   controller.forward();
  //
  //   controller.addListener(() {
  //     setState(() {});
  //   });
  // }
  //
  // @override
  // void dispose() {
  //   // controller.dispose();
  //   super.dispose();
  // }

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
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                DefaultTextStyle(
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      WavyAnimatedText('Family Chat'),
                    ],
                    isRepeatingAnimation: true,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            Hero(
              tag: 'login',
              child: RoundedButton(
                colour: Colors.lightBlueAccent,
                title: 'Log In',
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
              ),
            ),
            Hero(
              tag: 'register',
              child: RoundedButton(
                colour: Colors.blueAccent,
                title: 'Register',
                onPressed: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
