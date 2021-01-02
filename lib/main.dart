import 'package:flutter/material.dart';
import 'package:taxi_app/splashScreen.dart';
import 'package:taxi_app/Paypal_Payment/PayPalPayment.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Taxi Delivery',
      theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: "Century Gothic"),
      home: Scaffold(
        body: Center(child: SplashScreen()),
      ),
    );
  }
}
