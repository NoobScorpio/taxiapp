import 'dart:convert';

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_app/Constants/APIConstants.dart';
import 'package:taxi_app/Restaurant/resturant-current-jobs.dart';
import '../Constants/colors.dart';
import 'package:http/http.dart' as http;

class LoginRest extends StatefulWidget {
  @override
  _LoginRestState createState() => _LoginRestState();
}

class _LoginRestState extends State<LoginRest> {
  TextEditingController email = new TextEditingController();
  TextEditingController pass = new TextEditingController();

  void _showBottomFlash(String msg,
      {bool persistent = true, EdgeInsets margin = EdgeInsets.zero}) {
    showFlash(
      context: context,
      persistent: persistent,
      duration: Duration(seconds: 3),
      builder: (_, controller) {
        return Flash(
          controller: controller,
          margin: margin,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(8), topLeft: Radius.circular(8)),
          borderColor: Colors.black87,
          boxShadows: kElevationToShadow[8],
          backgroundColor: Colors.black87,
          position: FlashPosition.bottom,
          onTap: () => controller.dismiss(),
          forwardAnimationCurve: Curves.easeInCirc,
          reverseAnimationCurve: Curves.bounceIn,
          child: DefaultTextStyle(
            style: TextStyle(color: Colors.white),
            child: FlashBar(
              message: Text(msg),
              leftBarIndicatorColor: Colors.red,
              icon: Icon(
                Icons.error,
                color: Colors.white,
              ),
              /*
              primaryAction: FlatButton(
                onPressed: () => controller.dismiss(),
                child: Text('DISMISS',style: TextStyle(color: Colors.white),),
              ),

               */
              /*
              actions: <Widget>[
                FlatButton(
                    onPressed: () => controller.dismiss('Yes, I do!'),
                    child: Text('YES')),
                FlatButton(
                    onPressed: () => controller.dismiss('No, I do not!'),
                    child: Text('NO')),
              ],

               */
            ),
          ),
        );
      },
    );
  }

  void signIn(String email, String pass) async {
    ProgressDialog pr;
    pr = new ProgressDialog(context, showLogs: true);
    pr.style(message: 'Please wait...');
    pr.show();
    final http.Response response = await http
        .post(
      baseURL + restLogin,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{'email': email, 'password': pass}),
    )
        .catchError((onError) {
      pr.hide().whenComplete(() {
        _showBottomFlash("Check your internet connection");
        pr.hide();
      });
    });
    print("hello");
    print(response.body);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      bool success = jsonData["success"];

      if (success == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt("idRest", jsonData["idRest"]);
        prefs.setString("email", jsonData["email"]);
        prefs.setDouble("lat", jsonData["lat"]);
        prefs.setDouble("lng", jsonData["lng"]);
        prefs.setString("restName", jsonData["restName"]);
        prefs.setBool("isLogin", true);
        prefs.setString("user", "restaurant");

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RestCurrJobs()));
      } else {
        pr.hide().whenComplete(() {
          _showBottomFlash(jsonData["message"]);
          pr.hide();
        });
      }
    } else {
      pr.hide().whenComplete(() {
        _showBottomFlash("Server Error");
        pr.hide();
      });
      throw Exception('Failed to create login session.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: scolor,
        height: size.height,
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: <
              Widget>[
            Container(
              color: pcolor,
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 50,
                top: 35,
              ),
              child: Text(
                "TAXI DELIVERY",
                style: TextStyle(
                  color: pcolor,
                  fontFamily: 'Century',
                  fontSize: 29,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            Align(
                alignment: Alignment.center,
                child: Center(
                    child: Image.asset('asset/images/login_vector.png'))),
            Container(
              color: Colors.white,
              height: size.height * 0.5,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                    child: TextField(
                      controller: email,
                      style: TextStyle(
                        fontFamily: "Century Gothic",
                        color: Colors.grey[700],
                        fontSize: 17,
                      ),
                      autocorrect: false,
                      decoration: InputDecoration(
                        hintText: "resturant@email.com",
                        contentPadding: EdgeInsets.all(0),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                    child: TextField(
                      controller: pass,
                      obscureText: true,
                      style: TextStyle(
                        fontFamily: "Century Gothic",
                        color: Colors.grey[700],
                        fontSize: 17,
                      ),
                      autocorrect: false,
                      decoration: InputDecoration(
                        hintText: "********************",
                        contentPadding: EdgeInsets.all(0),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  RaisedButton(
                    color: scolor,
                    padding: EdgeInsets.symmetric(horizontal: 55, vertical: 7),
                    onPressed: () {
                      if (email.text.isNotEmpty && pass.text.isNotEmpty) {
                        signIn(email.text, pass.text);
                      } else {
                        _showBottomFlash("Please Fill all the required fields");
                      }
                    },
                    child: Text(
                      "LOGIN",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 12.0,
                    ),
                    child: GestureDetector(
                      onTap: () {},
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
                              color: scolor,
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
          ]),
        ),
      ),
    );
  }
}
