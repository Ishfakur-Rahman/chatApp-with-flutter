import 'package:flash_chat/screens/login_screen.dart';
import 'package:flutter/material.dart';

class ErrorGenerator extends StatelessWidget {
  late final String errorMessage;
  static const String id = 'ErrorPage';
  bool setErrorMessage(String message){
    errorMessage=message;
    return true;
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 5.0,
              child: Text(errorMessage),
            ),
            TextButton(
              onPressed: () {
                Navigator.popUntil(
                    context, (route) => route.settings.name == LoginScreen.id);
              },
              child: Text('try again'),
            ),
          ],
        ),
      ),
    );
  }
}
