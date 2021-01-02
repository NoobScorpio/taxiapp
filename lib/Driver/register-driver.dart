import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Constants/APIConstants.dart';
import '../Constants/colors.dart';
import 'current-jobs.dart';
import 'login-driver.dart';

class RegDriver extends StatefulWidget {
  @override
  _RegDriverState createState() => _RegDriverState();
}

class _RegDriverState extends State<RegDriver> {
  TextEditingController email = new TextEditingController();
  TextEditingController pass = new TextEditingController();
  TextEditingController name = new TextEditingController();
  TextEditingController carmake = new TextEditingController();
  TextEditingController regno = new TextEditingController();
  TextEditingController city = new TextEditingController();
  TextEditingController postal = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  LocationData currentLocation;
  Location location;

  onesingle(int id) async {
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.init("bd55ce90-1c6c-448d-912c-d258b7c1cb27", iOSSettings: {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.inAppLaunchUrl: false
    });
    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);

    OneSignal.shared.setExternalUserId(id.toString());
    OneSignal.shared.setSubscription(true);
// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    await OneSignal.shared
        .promptUserForPushNotificationPermission(fallbackToSettings: true);
  }

  void signUp() async {
    ProgressDialog pr;
    pr = new ProgressDialog(context, showLogs: true);
    pr.style(message: 'Please wait...');
    pr.show();
    final http.Response response = await http
        .post(
      baseURL + driverSignup,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'email': email.text,
        'password': pass.text,
        "name": name.text,
        "carmake": carmake.text,
        "phone": phone.text,
        "regno": regno.text,
        "postal": postal.text,
        "city": city.text,
        "lat":currentLocation.latitude,
        "lng":currentLocation.longitude
      }),
    )
        .catchError((onError) {
      pr.hide().whenComplete(() {
        _scaffoldkey.currentState.showSnackBar(SnackBar(
          content: Text(
            "Check your internet connection",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
        pr.hide();
      });
    });
    print("hello");
    print(response.body);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      bool success = jsonData["success"];

      if (success == true) {
        pr.hide().whenComplete(() async {
          _scaffoldkey.currentState.showSnackBar(SnackBar(
            content: Text(
              "Your account has been registered",
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.green,
          ));
          pr.hide();
          onesingle(jsonData["data"]["idDriver"]);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setInt("idDriver", jsonData["data"]["idDriver"]);
          print(prefs.getInt("idDriver"));
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CurrJobs()));
        });
      } else {
        pr.hide().whenComplete(() {
          _scaffoldkey.currentState.showSnackBar(SnackBar(
            content: Text(
              "Something went wrong. Pleas check the information and try again",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ));
          pr.hide();
        });
      }
    } else {
      pr.hide().whenComplete(() {
        _scaffoldkey.currentState.showSnackBar(SnackBar(
          content: Text(
            "Server Error",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
        pr.hide();
      });
      throw Exception('Failed to create login session.');
    }
  }

  @override
  void initState() {
    super.initState();
    location = new Location();
    location.getLocation().then((value) {
      currentLocation = value;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image.asset(
                  'asset/images/driver.png',
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 3),
                  child: TextField(
                    controller: name,
                    style: TextStyle(
                      fontFamily: "Century Gothic",
                      color: Colors.grey[700],
                      fontSize: 17,
                    ),
                    autocorrect: false,
                    decoration: InputDecoration(
                      hintText: "Full Name",
                      contentPadding: EdgeInsets.all(0),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 3),
                  child: TextField(
                    controller: email,
                    style: TextStyle(
                      fontFamily: "Century Gothic",
                      color: Colors.grey[700],
                      fontSize: 17,
                    ),
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Email",
                      contentPadding: EdgeInsets.all(0),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 3),
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
                      hintText: "Password",
                      contentPadding: EdgeInsets.all(0),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 3),
                  child: TextField(
                    controller: carmake,
                    style: TextStyle(
                      fontFamily: "Century Gothic",
                      color: Colors.grey[700],
                      fontSize: 17,
                    ),
                    autocorrect: false,
                    decoration: InputDecoration(
                      hintText: "Car Make",
                      contentPadding: EdgeInsets.all(0),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 3),
                  child: TextField(
                    controller: regno,
                    style: TextStyle(
                      fontFamily: "Century Gothic",
                      color: Colors.grey[700],
                      fontSize: 17,
                    ),
                    autocorrect: false,
                    decoration: InputDecoration(
                      hintText: "Registration No.",
                      contentPadding: EdgeInsets.all(0),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 3),
                  child: TextField(
                    controller: city,
                    style: TextStyle(
                      fontFamily: "Century Gothic",
                      color: Colors.grey[700],
                      fontSize: 17,
                    ),
                    autocorrect: false,
                    decoration: InputDecoration(
                      hintText: "City",
                      contentPadding: EdgeInsets.all(0),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 3),
                  child: TextField(
                    controller: postal,
                    style: TextStyle(
                      fontFamily: "Century Gothic",
                      color: Colors.grey[700],
                      fontSize: 17,
                    ),
                    keyboardType: TextInputType.number,
                    autocorrect: false,
                    decoration: InputDecoration(
                      hintText: "Postal Code",
                      contentPadding: EdgeInsets.all(0),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 3),
                  child: TextField(
                    controller: phone,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontFamily: "Century Gothic",
                      color: Colors.grey[700],
                      fontSize: 17,
                    ),
                    autocorrect: false,
                    decoration: InputDecoration(
                      hintText: "Phone number",
                      contentPadding: EdgeInsets.all(0),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 15,
                  ),
                  child: RaisedButton(
                    color: scolor,
                    padding: EdgeInsets.symmetric(horizontal: 55, vertical: 13),
                    onPressed: () {
                      if (email.text.isNotEmpty &&
                          pass.text.isNotEmpty &&
                          name.text.isNotEmpty &&
                          city.text.isNotEmpty &&
                          carmake.text.isNotEmpty &&
                          regno.text.isNotEmpty &&
                          postal.text.isNotEmpty &&
                          phone.text.isNotEmpty) {
                        signUp();
                      }
                    },
                    child: Text(
                      "REGISTER",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 5.0,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginDriver()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Already have an account?",
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
                            color: scolor,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
