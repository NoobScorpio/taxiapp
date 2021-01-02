//arrival time
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_app/Constants/APIConstants.dart';
import 'package:taxi_app/Driver/Navbar.dart';
import 'package:http/http.dart' as http;
import '../Constants/colors.dart';
import 'driver-my-jobs.dart';

class JobFound extends StatefulWidget {
  final int idOrder;

  JobFound({this.idOrder});

  @override
  _JobFoundState createState() => _JobFoundState();
}

class _JobFoundState extends State<JobFound> {
  TextEditingController time = new TextEditingController();

  void acceptOrder(int idOrder) async {
    ProgressDialog pr;
    pr = new ProgressDialog(context, showLogs: true);
    pr.style(message: 'Please wait...');
    pr.show();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int idDriver = prefs.getInt("idDriver");
    print(idDriver);
    print(idOrder);
    final http.Response response = await http
        .post(
      baseURL + acceptOrderURL,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'idOrder': idOrder,
        'idDriver': idDriver,
        "time": time.text
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
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyJobs()));
      } else {
        pr.hide().whenComplete(() {
          _scaffoldkey.currentState.showSnackBar(SnackBar(
            content: Text(
              jsonData["message"],
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
      throw Exception('Failed to accept order.');
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("asset/images/google_map.png"),
              fit: BoxFit.cover)),
      child: Scaffold(
        key: _scaffoldkey,
        backgroundColor: Color.fromRGBO(61, 6, 95, 0.7),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        color: pcolor,
                        height: 50,
                      ),
                      SizedBox(
                        height: 45,
                      ),
                      Text(
                        "JOB FOUND",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontFamily: "Century Gothic",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 25,
                          left: 35,
                          right: 35,
                        ),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.59,
                          width: double.maxFinite,
                          decoration: new BoxDecoration(
                            color: Colors.white,
                            borderRadius: new BorderRadius.all(
                              Radius.circular(22.0),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Time for arrival",
                                style: TextStyle(
                                  color: scolor,
                                  wordSpacing: 1,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 25,
                                  fontFamily: "Century Gothic",
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: new Theme(
                                  data: new ThemeData(
                                    //primaryColor: Colors.redAccent,
                                    primaryColor: scolor,
                                  ),
                                  child: TextField(
                                    controller: time,
                                    autofocus: true,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              RaisedButton(
                                onPressed: () {
                                  if (time.text.isNotEmpty) {
                                    acceptOrder(widget.idOrder);
                                  }
                                  /*
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ReachedRest()));

                                   */
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                color: scolor,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 75, vertical: 10),
                                child: Text(
                                  "SUBMIT",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 19,
                                  ),
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
              Navbar(
                index: 4,
              )
            ],
          ),
        ),
      ),
    );
  }
}
