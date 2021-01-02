import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_app/Constants/APIConstants.dart';
import 'package:taxi_app/Driver/reached-cust.dart';
import 'package:taxi_app/Driver/reached-restuarant.dart';
import '../constants/colors.dart';
import 'Navbar.dart';

class MyJobs extends StatefulWidget {
  @override
  _MyJobsState createState() => _MyJobsState();
}

class _MyJobsState extends State<MyJobs> {
  TabController _tabController;
  int len = 0, len2 = 0;
  bool empty = false, empty2 = false;
  var jsonData, jsonData2;

  void getInProgressList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int idDriver = prefs.getInt("idDriver");

    print(idDriver);

    final http.Response response = await http
        .post(
      baseURL + inProgressListURL,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{'idDriver': idDriver}),
    )
        .catchError((onError) {
      _scaffoldkey.currentState.showSnackBar(SnackBar(
        content: Text(
          "Check your internet connection",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
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
        _scaffoldkey.currentState.showSnackBar(SnackBar(
          content: Text(
            "Something went wrong. Failed to fetch Jobs",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
      }
    } else {
      _scaffoldkey.currentState.showSnackBar(SnackBar(
        content: Text(
          "Server Error",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
      throw Exception('Failed to fetch jobs.');
    }
  }

  void getCompleteList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int idDriver = prefs.getInt("idDriver");

    final http.Response response = await http
        .post(
      baseURL + completeListURL,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{'idDriver': idDriver}),
    )
        .catchError((onError) {
      _scaffoldkey.currentState.showSnackBar(SnackBar(
        content: Text(
          "Check your internet connection",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
    });
    print("hello");
    print(response.body);
    if (response.statusCode == 200) {
      jsonData2 = json.decode(response.body);

      bool success = jsonData2["success"];

      if (success == true) {
        setState(() {
          len2 = jsonData2["data"].length > 0 ? jsonData2["data"].length : 0;
          empty2 = jsonData2["data"].length > 0 ? false : true;
        });
      } else {
        _scaffoldkey.currentState.showSnackBar(SnackBar(
          content: Text(
            "Something went wrong. Failed to fetch Jobs",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
      }
    } else {
      _scaffoldkey.currentState.showSnackBar(SnackBar(
        content: Text(
          "Server Error",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
      throw Exception('Failed to create login session.');
    }
  }

  @override
  void initState() {
    super.initState();
    getInProgressList();
    getCompleteList();
    current = 1;
    setState(() {});
  }

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      body: Stack(children: [
        DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: AppBar(
                backgroundColor: scolor,
                automaticallyImplyLeading: false,
                bottom: TabBar(
                  tabs: [
                    Center(
                      child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.timer,
                                color: pcolor,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "IN PROGRESS",
                                style: TextStyle(color: pcolor),
                              ),
                            ],
                          )),
                    ),
                    Center(
                      child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                color: pcolor,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "COMPLETED",
                                style: TextStyle(color: pcolor),
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ),
            body: TabBarView(
              children: [
                Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 70),
                    child: Container(
                      child: len == 0
                          ? Center(
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
                            ))
                          : ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              //key: PageStorageKey("key1"),
                              shrinkWrap: true,
                              padding: EdgeInsets.all(0),
                              itemCount: len,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 17.0, vertical: 5),
                                  child: Container(
                                    // height: MediaQuery.of(context).size.height * 0.2,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height: 14,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 13.0),
                                              child: Text(
                                                "Customer Name: ",
                                                style: TextStyle(
                                                  color: scolor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 3.0),
                                              child: Text(
                                                jsonData["data"][index]
                                                        ["CustomerName"] ??
                                                    "Ranchers",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 13.0),
                                              child: Text(
                                                "Location: ",
                                                style: TextStyle(
                                                  color: scolor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 3.0),
                                              child: Text(
                                                jsonData["data"][index]
                                                        ["DestAddress"] ??
                                                    "123A, St 6 Area 5 City ABC",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 13.0),
                                              child: Text(
                                                "Postal code: ",
                                                style: TextStyle(
                                                  color: scolor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 3.0),
                                              child: Text(
                                                jsonData["data"][index]
                                                            ["postcode"]
                                                        .toString() ??
                                                    "248764",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 13.0),
                                              child: Text(
                                                "Customer Phone: ",
                                                style: TextStyle(
                                                  color: scolor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 3.0),
                                              child: Text(
                                                jsonData["data"][index]
                                                        ["CustomerPhone"] ??
                                                    "Ranchers",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 13.0),
                                              child: Text(
                                                "Restaurant Name: ",
                                                style: TextStyle(
                                                  color: scolor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 3.0),
                                              child: Text(
                                                jsonData["data"][index]
                                                        ["RestaurantName"] ??
                                                    "Ranchers",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        /*
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(left: 13.0),
                                      child: Text(
                                        "Expected Collection Time: ",
                                        style: TextStyle(
                                          color: scolor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 3.0),
                                      child: Text(
                                        "10 minutes",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                 */
                                        SizedBox(
                                          height: 1,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 11.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              ButtonTheme(
                                                height: 25,
                                                minWidth: 25,
                                                child: RaisedButton(
                                                  color: pcolor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                  ),
                                                  child: Text(
                                                    "Check Route",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    print(jsonData["data"]
                                                        [index]["idOrder"]);
                                                    if (jsonData["data"][index]
                                                            ["Status"] ==
                                                        "Accepted") {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      ReachedRest(
                                                                        data: jsonData["data"]
                                                                            [
                                                                            index],
                                                                        dlat: jsonData["data"][index]
                                                                            [
                                                                            "Latitude"],
                                                                        dlong: jsonData["data"][index]
                                                                            [
                                                                            "Longitude"],
                                                                      )));
                                                    } else if (jsonData["data"]
                                                            [index]["Status"] ==
                                                        "In Progress") {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      ReachedCust(
                                                                        idOrder:
                                                                            jsonData["data"][index]["idOrder"],
                                                                        data: jsonData["data"]
                                                                            [
                                                                            index],
                                                                        dlat: jsonData["data"][index]
                                                                            [
                                                                            "Latitude"],
                                                                        dlong: jsonData["data"][index]
                                                                            [
                                                                            "Longitude"],
                                                                      )));
                                                    }
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 70),
                    child: Container(
                      child: len2 == 0
                          ? Center(
                              child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Visibility(
                                    visible: empty2 == false ? true : false,
                                    child: Container(
                                        height: 150,
                                        child: Lottie.asset(
                                            'asset/json/search.json'))),
                                Visibility(
                                    visible: empty2 == false ? false : true,
                                    child: Container(
                                        //height: 200,
                                        child: Lottie.asset(
                                            'asset/json/notfound.json'))
                                    //Text("Record not found.!!",style: TextStyle(fontSize: 24),)
                                    )
                              ],
                            ))
                          : ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              //key: PageStorageKey("key2"),
                              shrinkWrap: true,
                              padding: EdgeInsets.all(0),
                              itemCount: len2,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 17.0, vertical: 5),
                                  child: Container(
                                    // height: MediaQuery.of(context).size.height * 0.2,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height: 14,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 13.0),
                                              child: Text(
                                                "Customer Name: ",
                                                style: TextStyle(
                                                  color: scolor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 3.0),
                                              child: Text(
                                                jsonData2["data"][index]
                                                        ["CustomerName"] ??
                                                    "Ranchers",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 13.0),
                                              child: Text(
                                                "Location: ",
                                                style: TextStyle(
                                                  color: scolor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 3.0),
                                              child: Text(
                                                jsonData2["data"][index]
                                                        ["DestAddress"] ??
                                                    "123A, St 6 Area 5 City ABC",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 13.0),
                                              child: Text(
                                                "Postal code: ",
                                                style: TextStyle(
                                                  color: scolor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 3.0),
                                              child: Text(
                                                jsonData2["data"][index]
                                                            ["postcode"]
                                                        .toString() ??
                                                    "248764",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 13.0),
                                              child: Text(
                                                "Customer Phone: ",
                                                style: TextStyle(
                                                  color: scolor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 3.0),
                                              child: Text(
                                                jsonData2["data"][index]
                                                        ["CustomerPhone"] ??
                                                    "Ranchers",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 13.0),
                                              child: Text(
                                                "Restaurant Name: ",
                                                style: TextStyle(
                                                  color: scolor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 3.0),
                                              child: Text(
                                                jsonData2["data"][index]
                                                        ["RestaurantName"] ??
                                                    "Ranchers",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        /*
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(left: 13.0),
                                      child: Text(
                                        "Expected Collection Time: ",
                                        style: TextStyle(
                                          color: scolor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 3.0),
                                      child: Text(
                                        "10 minutes",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                 */
                                        SizedBox(
                                          height: 1,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 11.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              ButtonTheme(
                                                height: 25,
                                                minWidth: 25,
                                                child: RaisedButton(
                                                  color: Colors.green[600],
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                  ),
                                                  child: Text(
                                                    "Earned \u{00A3}" +
                                                            jsonData2["data"]
                                                                        [index]
                                                                    ["price"]
                                                                .toString() ??
                                                        "10",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                  onPressed: () {},
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    )),
              ],
              controller: _tabController,
            ),
          ),
        ),
        Navbar(
          index: 1,
        ),
      ]),
    );
  }
}
