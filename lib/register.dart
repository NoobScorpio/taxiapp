import 'Driver/register-driver.dart';
import 'Restaurant/register-rest.dart';
import 'package:flutter/material.dart';
import 'Constants/colors.dart';
import 'login.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
                        MaterialPageRoute(builder: (context) => RegRest()));
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  color: pcolor,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "REGISTER AS RESTAURANT",
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
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => RegDriver()));
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    color: tcolor,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        "REGISTER AS TAXI DRIVER",
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
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
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
                          " Signin",
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
          Image.asset(
            'asset/images/bottom_vector.png',
          ),
        ],
      ),
    );
  }
}
