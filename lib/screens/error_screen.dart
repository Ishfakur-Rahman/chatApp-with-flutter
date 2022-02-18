import 'package:flutter/material.dart';

class ErrorGenerator extends StatelessWidget {
  static const String id = 'ErrorPage';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              child: Text('Make sure you have an account'),
            ),
            Card(
              child: Text(
                  'If you can\'t still proceed then make sure you have internet connection'),
            ),
          ],
        ),
      ),
    );
  }
}
