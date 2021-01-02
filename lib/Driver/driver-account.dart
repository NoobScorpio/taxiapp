import 'dart:convert';
import 'package:flash/flash.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_app/Constants/APIConstants.dart';
import 'package:taxi_app/Constants/colors.dart';
import 'package:taxi_app/Driver/Navbar.dart';
import 'package:taxi_app/Driver/current-jobs.dart';
import 'package:taxi_app/login.dart';

class DriverAccount extends StatefulWidget {

  final data;

  DriverAccount({this.data});

  @override
  _DriverAccountState createState() => _DriverAccountState();
}

class _DriverAccountState extends State<DriverAccount> {

  TextEditingController name=new TextEditingController();
  TextEditingController email=new TextEditingController();
  TextEditingController pass=new TextEditingController();
  TextEditingController phone=new TextEditingController();
  TextEditingController postal=new TextEditingController();
  TextEditingController carmake=new TextEditingController();
  TextEditingController regno=new TextEditingController();
  TextEditingController city=new TextEditingController();

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


  void updateDriver() async {
    ProgressDialog pr;
    pr = new ProgressDialog(context, showLogs: true);
    pr.style(message: 'Please wait...');
    pr.show();

    SharedPreferences prefs=await SharedPreferences.getInstance();
    int idDriver=prefs.getInt("idDriver");

    final http.Response response = await http
        .post(
      baseURL + updateDriverURL,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'idDriver': idDriver,
        'name': name.text,
        'email': email.text,
        'carmake': carmake.text,
        'password': pass.text,
        'regno': regno.text,
        'postal': postal.text,
        'city': city.text,
        'phone': phone.text,
      }),
    )
        .catchError((onError) {
      pr.hide().whenComplete(() {
        _showBottomFlash("Check your internet connection");
          pr.hide();
      });
    });
    print("hello");
    print(response.body);
    pr.hide();
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      bool success = jsonData["success"];

      if (success == true) {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>CurrJobs()));
      } else {
        _showBottomFlash("Check the given Information and try again");
      }
    } else {
      _showBottomFlash("Server Error");
      throw Exception('Failed to create login session.');
    }
  }

  void getDriver() async {
    ProgressDialog pr;
    pr = new ProgressDialog(context, showLogs: true);
    pr.style(message: 'Please wait...');
    pr.show();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int idDriver = prefs.getInt("idDriver");

    final http.Response response = await http
        .post(
      baseURL + getDriverURL,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{'idDriver': idDriver}),
    )
        .catchError((onError) {
      pr.hide().whenComplete(() {
        _showBottomFlash("Check your internet connection");
        pr.hide();
      });
    });
    pr.hide();
    print("hello");
    print(response.body);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      bool success = jsonData["success"];

      if (success == true) {
        name=new TextEditingController(text: jsonData["data"]["name"]);
        email=new TextEditingController(text: jsonData["data"]["email"]);
        pass=new TextEditingController(text: jsonData["data"]["password"]);
        phone=new TextEditingController(text: jsonData["data"]["phone"]);
        postal=new TextEditingController(text: jsonData["data"]["postal"]);
        carmake=new TextEditingController(text: jsonData["data"]["carmake"]);
        regno=new TextEditingController(text: jsonData["data"]["regno"]);
        city=new TextEditingController(text: jsonData["data"]["city"]);
        setState(() {

        });
      } else {
        _showBottomFlash(
            "Something went wrong. Failed to fetch the driver details");
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
  void initState() {
    super.initState();
    getDriver();
    current=3;
    setState(() {

    });
  }
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                color: scolor,
              ),
            ),
            Column(
              children: [
                Container(
                  height: 50,
                  color: pcolor,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Account",
                    style: TextStyle(
                      color: pcolor,
                      fontSize: 24,
                    ),
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.only(left: 20.0,right: 20, top: 10),
                  child: Container(
                    height: MediaQuery.of(context).size.height-180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: Offset(0, 1), // changes position of shadow
                        ),
                      ],
                      color: Colors.white,
                    ),
                    // height: MediaQuery.of(context).size.height * 0.6,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 25.0,
                              right: 25,
                              top: 17,
                            ),
                            child: TextField(
                              controller: name,
                              decoration: InputDecoration(
                                labelText: "Full Name",
                                contentPadding: EdgeInsets.all(
                                  0,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 25.0,right: 25,top: 15),
                            child: TextField(
                              controller: email,
                              decoration: InputDecoration(
                                labelText: "Email",
                                contentPadding: EdgeInsets.all(
                                  0,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 25.0,right: 25,top: 15),
                            child: TextField(
                              controller: pass,
                              decoration: InputDecoration(
                                labelText: "Password",
                                contentPadding: EdgeInsets.all(
                                  0,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 25.0,right: 25,top: 15),
                            child: TextField(
                              controller: carmake,
                              decoration: InputDecoration(
                                labelText: "Car Make",
                                contentPadding: EdgeInsets.all(
                                  0,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 25.0,right: 25,top: 15),
                            child: TextField(
                              controller: regno,
                              decoration: InputDecoration(
                                labelText: "Registeration No.",
                                contentPadding: EdgeInsets.all(
                                  0,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 25.0,right: 25,top: 15),
                            child: TextField(
                              controller: city,
                              decoration: InputDecoration(
                                labelText: "City",
                                contentPadding: EdgeInsets.all(
                                  0,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 25.0,right: 25,top: 15),
                            child: TextField(
                              controller: postal,
                              decoration: InputDecoration(
                                labelText: "Postal",
                                contentPadding: EdgeInsets.all(
                                  0,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 25.0,right: 25,top: 15),
                            child: TextField(
                              controller: phone,
                              decoration: InputDecoration(
                                labelText: "Phone",
                                contentPadding: EdgeInsets.all(
                                  0,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                const EdgeInsets.only(top: 12.0, bottom: 12),
                                child: MaterialButton(
                                  color: scolor,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 10),
                                  onPressed: () {
                                    updateDriver();
                                  },
                                  child: Text(
                                    "Update Profile",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 12.0, bottom: 12, left: 9),
                                child: MaterialButton(
                                  color: Colors.redAccent,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 35, vertical: 10),
                                  onPressed: () async {
                                    OneSignal.shared.setSubscription(false);
                                    OneSignal.shared.removeExternalUserId();
                                    SharedPreferences prefs=await SharedPreferences.getInstance();
                                    prefs.clear();
                                    prefs.setBool("isLogin",false);
                                    Navigator.popUntil(context, (route) => false);
                                    Navigator.push(context,MaterialPageRoute(builder: (context)=>Login()));
                                  },
                                  child: Text(
                                    "Logout",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Navbar(index: 3,)
          ],
        ),
      ),
    );
  }
}
