import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_app/Driver/wallet.dart';
import 'register-driver.dart';
import '../Constants/APIConstants.dart';
import '../Constants/colors.dart';
import 'current-jobs.dart';

class LoginDriver extends StatefulWidget {
  @override
  _LoginDriverState createState() => _LoginDriverState();
}

class _LoginDriverState extends State<LoginDriver> {
  TextEditingController email = new TextEditingController();
  TextEditingController pass = new TextEditingController();

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

  void driverValidity() async {
    ProgressDialog pr;
    pr = new ProgressDialog(context, showLogs: true);
    pr.style(message: 'Please wait...');
    pr.show();

    SharedPreferences prefs=await SharedPreferences.getInstance();
    int idDriver=prefs.getInt("idDriver");

    final http.Response response = await http
        .post(
      baseURL + driverValidityURL,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{'idDriver': idDriver}),
    )
        .catchError((onError) {
      pr.hide().whenComplete(() {
        _scaffoldkey.currentState.showSnackBar(SnackBar(content: Text("Check your internet connection",style: TextStyle(color: Colors.white),),backgroundColor: Colors.red,));
        pr.hide();
      });
    });
    print("hello");
    print(response.body);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      bool success = jsonData["success"];

      if (success == true) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => CurrJobs()));
      } else {
        pr.hide().whenComplete((){
          _scaffoldkey.currentState.showSnackBar(SnackBar(content: Text("Something went wrong. Failed to fetch Jobs",style: TextStyle(color: Colors.white),),backgroundColor: Colors.red,));
          pr.hide();
          Timer(Duration(seconds: 1),()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>DriverWallet())));
        });
      }
    } else {
      pr.hide().whenComplete(() {
        _scaffoldkey.currentState.showSnackBar(SnackBar(content: Text("Server Error",style: TextStyle(color: Colors.white),),backgroundColor: Colors.red,));
        pr.hide();
      });
      throw Exception('Failed to create login session.');
    }
  }

  void signIn(String email, String pass) async {
    ProgressDialog pr;
    pr = new ProgressDialog(context, showLogs: true);
    pr.style(message: 'Please wait...');
    pr.show();
    final http.Response response = await http
        .post(
      baseURL + driverLogin,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{'email': email, 'password': pass}),
    )
        .catchError((onError) {
      pr.hide().whenComplete(() {
        _scaffoldkey.currentState.showSnackBar(SnackBar(content: Text("Check your internet connection",style: TextStyle(color: Colors.white),),backgroundColor: Colors.red,));
        pr.hide();
      });
    });
    print("hello");
    print(response.body);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      bool success = jsonData["success"];

      if (success == true) {
        print(jsonData["data"]["idDriver"]);
        onesingle(jsonData["data"]["idDriver"]);
        SharedPreferences prefs=await SharedPreferences.getInstance();
        prefs.setInt("idDriver", jsonData["data"]["idDriver"]);
        prefs.setString("email", jsonData["data"]["Email"]);
        prefs.setString("password", jsonData["data"]["Password"]);
        prefs.setString("user", "driver");
        prefs.setBool("isLogin",true);
        print(prefs.getInt("idDriver"));

        driverValidity();
      } else {
        pr.hide().whenComplete(() {
          _scaffoldkey.currentState.showSnackBar(SnackBar(content: Text("Email or Password is Incorrect",style: TextStyle(color: Colors.white),),backgroundColor: Colors.red,));
          pr.hide();
        });
      }
    } else {
      pr.hide().whenComplete((){
        _scaffoldkey.currentState.showSnackBar(SnackBar(content: Text("Server Error",style: TextStyle(color: Colors.white),),backgroundColor: Colors.red,));
        pr.hide();
      });
      throw Exception('Failed to create login session.');
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: Colors.white,
      body: Container(

        height: size.height,
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: <
              Widget>[
            Container(
              color: pcolor,
              height: 50,
            ),
            Container(
              height: size.height*0.45,
              width: size.width,
              decoration: BoxDecoration(
                color: scolor,
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(15),bottomLeft: Radius.circular(15))
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
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
                  Container(
                    height: size.height*0.33,
                      width: size.width,
                      child:Image.asset('asset/images/login_vector.png',fit: BoxFit.fill,)
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
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
                        hintText: "driver@email.com",
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
                      if (email.text.length != 0 && pass.text.length != 0) {
                        signIn(email.text, pass.text);
                      } else {
                        _scaffoldkey.currentState.showSnackBar(SnackBar(content: Text("Please fill all the required fields",style: TextStyle(color: Colors.white),),backgroundColor: Colors.red,));
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
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegDriver()));
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
