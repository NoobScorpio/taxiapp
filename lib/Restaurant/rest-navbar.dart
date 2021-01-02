import 'dart:convert';

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_app/Constants/APIConstants.dart';
import 'package:taxi_app/Restaurant/RestWallet.dart';
import 'package:taxi_app/Restaurant/rest-account.dart';
import 'package:taxi_app/Restaurant/rest-myjobs.dart';
import 'package:taxi_app/Restaurant/resturant-current-jobs.dart';
import 'package:http/http.dart' as http;
import '../Constants/colors.dart';

int current;

class RestNavbar extends StatefulWidget {
  final int index;

  RestNavbar({this.index});

  @override
  _RestNavbarState createState() => _RestNavbarState();
}

class _RestNavbarState extends State<RestNavbar> {
  // bool valid = false;

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

  void getRest() async {
    ProgressDialog pr;
    pr = new ProgressDialog(context, showLogs: true);
    pr.style(message: 'Please wait...');
    pr.show();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int idRest = prefs.getInt("idRest");

    final http.Response response = await http
        .post(
      baseURL + getRestURL,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{'idRest': idRest}),
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
        Navigator.popUntil(context, (route) => false);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RestAccount(data: jsonData["data"])));
      } else {
        pr.hide().whenComplete(() {
          _showBottomFlash(
              "Something went wrong. Failed to fetch the driver details");
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

  // void driverValidity() async {
  //   ProgressDialog pr;
  //   pr = new ProgressDialog(context, showLogs: true);
  //   pr.style(message: 'Please wait...');
  //   pr.show();

  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   int idDriver = prefs.getInt("idDriver");

  //   final http.Response response = await http
  //       .post(
  //     baseURL + driverValidityURL,
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(<String, dynamic>{'idDriver': idDriver}),
  //   )
  //       .catchError((onError) {
  //     pr.hide().whenComplete(() {
  //       _showBottomFlash("Check your internet connection");
  //       pr.hide();
  //     });
  //   });
  //   print("hello");
  //   print(response.body);
  //   if (response.statusCode == 200) {
  //     var jsonData = json.decode(response.body);

  //     bool success = jsonData["success"];

  //     if (success == true) {
  //       setState(() {
  //         valid = true;
  //       });
  //     } else {
  //       pr.hide().whenComplete(() {
  //         _showBottomFlash("Please renew the membership");
  //         pr.hide();
  //       });
  //     }
  //   } else {
  //     pr.hide().whenComplete(() {
  //       _showBottomFlash("Server Error");
  //       pr.hide();
  //     });
  //     throw Exception('Failed to check the validity');
  //   }
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   driverValidity();
  // }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height - 70,
      child: Container(
        decoration: new BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
          color: Colors.white,
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(30.0),
            topRight: const Radius.circular(30.0),
          ),
        ),
        alignment: Alignment.bottomCenter,
        width: MediaQuery.of(context).size.width,
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.popUntil(context, (route) => false);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RestCurrJobs()));
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Image.asset(
                      "asset/images/home.png",
                      color: current == 0 ? scolor : Colors.grey,
                      height: 29,
                      width: 29,
                    ),
                  ),
                  Text(
                    "HOME",
                    style: TextStyle(
                      color: current == 0 ? scolor : Colors.grey,
                      fontSize: 10,
                    ),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.popUntil(context, (route) => false);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RestMyJobs()));
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Image.asset(
                      "asset/images/car.png",
                      color: current == 1 ? scolor : Colors.grey,
                      height: 30,
                      width: 30,
                    ),
                  ),
                  Text(
                    "JOBS",
                    style: TextStyle(
                      color: current == 1 ? scolor : Colors.grey,
                      fontSize: 10,
                    ),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.popUntil(context, (route) => false);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RestWallet()));
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Image.asset(
                      "asset/images/wallet.png",
                      color: current == 2 ? scolor : Colors.grey,
                      height: 30,
                      width: 30,
                    ),
                  ),
                  Text(
                    "WALLET",
                    style: TextStyle(
                      color: current == 2 ? scolor : Colors.grey,
                      fontSize: 10,
                    ),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                getRest();
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Image.asset(
                      "asset/images/user.png",
                      color: current == 3 ? scolor : Colors.grey,
                      height: 28,
                      width: 28,
                    ),
                  ),
                  Text(
                    "ACCOUNT",
                    style: TextStyle(
                      color: current == 3 ? scolor : Colors.grey,
                      fontSize: 10,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
