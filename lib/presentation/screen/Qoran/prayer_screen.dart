import 'package:flutter/material.dart';

class PrayerScreen extends StatelessWidget {
  const PrayerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            color: Colors.yellowAccent[100],
            child: Image.asset(
              "assets/images/prayer.jpg",
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
