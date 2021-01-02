import 'package:flutter/material.dart';
import 'Constants/colors.dart';
import 'Driver/login-driver.dart';
import 'Restaurant/login-restuarant.dart';
import 'register.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scolor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            color: pcolor,
            height: 50,
          ),
          Container(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 100,
                    ),
                    child: Text(
                      "TAXI DELIVERY",
                      style: TextStyle(
                        color: pcolor,
                        fontFamily: 'Century Gothic',
                        fontSize: 29,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginRest()));
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    color: pcolor,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        "LOGIN AS RESTAURANT",
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          fontFamily: "Century Gothic",
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginDriver()));
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      color: tcolor,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "LOGIN AS TAXI DRIVER",
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            fontFamily: "Century Gothic",
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 12.0,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Register()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Don't have an account?",
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey[800],
                              decoration: TextDecoration.none,
                            ),
                          ),
                          Text(
                            " Signup",
                            style: TextStyle(
                              fontSize: 14.0,
                              color: pcolor,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Image.asset(
            'asset/images/bottom_vector.png',
          ),
        ],
      ),
    );
  }
}
