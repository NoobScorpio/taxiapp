import 'dart:convert';

import 'package:flash/flash.dart';
import "package:flutter/material.dart";
import 'package:lottie/lottie.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_app/Constants/APIConstants.dart';
import "package:taxi_app/Constants/colors.dart";
import 'package:taxi_app/Restaurant/create-job.dart';
import 'package:taxi_app/Restaurant/nearby-drivers.dart';
import 'package:taxi_app/Restaurant/rest-navbar.dart';
import 'package:http/http.dart' as http;

class RestCurrJobs extends StatefulWidget {
  @override
  _RestCurrJobsState createState() => _RestCurrJobsState();
}

class _RestCurrJobsState extends State<RestCurrJobs> {
  var jsonData;
  int len = 0;
  bool empty = false;

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

  void getOrdersList() async {
    ProgressDialog pr;
    pr = new ProgressDialog(context, showLogs: true);
    pr.style(message: 'Please wait...');
    pr.show();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int idRest = prefs.getInt("idRest");

    final http.Response response = await http
        .post(
      baseURL + rordersListURL,
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
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);

      bool success = jsonData["success"];

      if (success == true) {
        setState(() {
          len = jsonData["data"].length > 0 ? jsonData["data"].length : 0;
          empty = jsonData["data"].length > 0 ? false : true;
        });
      } else {
        pr.hide().whenComplete(() {
          _showBottomFlash("Something went wrong. Failed to fetch Jobs");
          pr.hide();
        });
      }
    } else {
      pr.hide().whenComplete(() {
        _showBottomFlash("Server Error");
        pr.hide();
      });
      throw Exception('Failed to fetch the jobs');
    }
  }

  void deleteJob(int idOrder) async {
    ProgressDialog pr;
    pr = new ProgressDialog(context, showLogs: true);
    pr.style(message: 'Please wait...');
    pr.show();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int idRest = prefs.getInt("idRest");

    final http.Response response = await http
        .post(
      baseURL + deleteJobURL,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{'idOrder': idOrder, 'idRest': idRest}),
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
        Navigator.pushReplacement(
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
      throw Exception('Failed to delete job.');
    }
  }

  @override
  void initState() {
    super.initState();
    getOrdersList();
    current = 0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {},
      child: Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 70.0),
          child: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CreateJob()));
            },
            label: Text('Create Job'),
            icon: Icon(Icons.add),
            backgroundColor: pcolor,
          ),
        ),
        //backgroundColor: scolor,
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 110.0, bottom: 75),
              child: SingleChildScrollView(
                child: Container(
                  child: len == 0
                      ? Container(
                          height: MediaQuery.of(context).size.height - 185,
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Visibility(
                                  visible: empty == false ? true : false,
                                  child: Container(
                                      height: 150,
                                      child: Lottie.asset(
                                          'asset/json/search.json'))),
                              Visibility(
                                  visible: empty == false ? false : true,
                                  child: Container(
                                      //height: 200,
                                      child: Lottie.asset(
                                          'asset/json/notfound.json'))
                                  //Text("Record not found.!!",style: TextStyle(fontSize: 24),)
                                  )
                            ],
                          )),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.vertical,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.all(0),
                          itemCount: len,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NearbyDrivers(
                                            data: jsonData["data"][index])));
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 7),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(23),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Order ID:",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 17,
                                                  ),
                                                ),
                                                Text(
                                                  jsonData["data"][index]
                                                              ["idOrder"]
                                                          .toString() ??
                                                      "99087",
                                                  style: TextStyle(
                                                    color: scolor,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5.0, horizontal: 12),
                                            child: Container(
                                              color: Colors.grey,
                                              width: 1,
                                              height: 49,
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "Customer: ",
                                                    style: TextStyle(
                                                      color: scolor,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: size.width * 0.45,
                                                    child: Text(
                                                      jsonData["data"][index][
                                                                  "CustomerName"]
                                                              .toString() ??
                                                          "John Kyle",
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Cust Phone: ",
                                                    style: TextStyle(
                                                      color: scolor,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    jsonData["data"][index][
                                                                "CustomerPhone"]
                                                            .toString() ??
                                                        "523525",
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Dest Address: ",
                                                    style: TextStyle(
                                                      color: scolor,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: size.width * 0.4,
                                                    child: Text(
                                                      jsonData["data"][index][
                                                                  "DestAddress"]
                                                              .toString() ??
                                                          "Lorem impsum",
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        width: 180,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          border: Border.all(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Status: ",
                                              textScaleFactor: 1,
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15,
                                              ),
                                            ),
                                            Text(
                                              "Awaiting Driver",
                                              textScaleFactor: 1,
                                              style: TextStyle(
                                                color: Colors.orange,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          deleteJob(jsonData["data"][index]
                                              ["idOrder"]);
                                        },
                                        child: Container(
                                          width: 180,
                                          height: 25,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            color: Colors.green[600],
                                            border: Border.all(
                                              color: Colors.green[600],
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Delete Job",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  height: 50,
                  color: pcolor,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: scolor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(0, 0.5), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.filter_list,
                          color: Colors.white,
                          size: 32,
                        ),
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.clear();
                          prefs.setBool("isLogin", false);
                        },
                      ),
                      Text(
                        "Current Jobs",
                        style: TextStyle(
                          color: pcolor,
                          fontSize: 20,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.notifications_active,
                          color: Colors.white,
                          size: 32,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
            RestNavbar(
              index: 0,
            ),
          ],
        ),
      ),
    );
  }
}
