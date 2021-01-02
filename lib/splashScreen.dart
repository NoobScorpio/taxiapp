import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_app/Constants/colors.dart';

import 'Driver/current-jobs.dart';
import 'Restaurant/resturant-current-jobs.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int idDriver;
  String user;
  bool isLogin;

  checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    idDriver = prefs.getInt("idDriver");
    isLogin = prefs.getBool("isLogin");
    user = prefs.getString("user");
    print(idDriver);
    print(prefs.getBool("isLogin"));
    print(user);
  }

  @override
  void initState() {
    super.initState();
    checkLogin();
    Timer(Duration(seconds: 3), () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => user == null
                  ? Login()
                  : user == "driver"
                      ? CurrJobs()
                      : RestCurrJobs()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
              color: pcolor,
            image: DecorationImage(
              image: AssetImage('asset/images/bottom_vector.png'),
              fit: BoxFit.fitWidth
            )
          ),
        ),
      ),
    );
  }
}
