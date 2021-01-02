import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_app/Constants/APIConstants.dart';
import 'package:taxi_app/Constants/colors.dart';
import 'package:taxi_app/Restaurant/enroute.dart';
import 'package:taxi_app/Restaurant/rest-navbar.dart';
import 'package:flash/flash.dart';

class RestMyJobs extends StatefulWidget {
  @override
  _RestMyJobsState createState() => _RestMyJobsState();
}

class _RestMyJobsState extends State<RestMyJobs> {
  int len = 0, len2 = 0;
  bool empty = false, empty2 = false;
  var jsonData, jsonData2;

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

  //              */
              //             /*
              //             actions: <Widget>[
              //               FlatButton(
              //                   onPressed: () => controller.dismiss('Yes, I do!'),
              //                   child: Text('YES')),
              //               FlatButton(
              //                   onPressed: () => controller.dismiss('No, I do not!'),
              //                   child: Text('NO')),
              //             ],

              //              */
            ),
          ),
        );
      },
    );
  }

  void getInProgressList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int idRest = prefs.getInt("idRest");

    final http.Response response = await http
        .post(
      baseURL + rinProgressListURL,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{'idRest': idRest}),
    )
        .catchError((onError) {
      _showBottomFlash("Check your internet connection");
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
        _showBottomFlash("Something went wrong. Failed to fetch jobs");
      }
    } else {
      _showBottomFlash("Server Error");
      throw Exception('Failed to fetch jobs.');
    }
  }

  void getCompleteList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int idRest = prefs.getInt("idRest");

    final http.Response response = await http
        .post(
      baseURL + rCompletedListURL,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{'idRest': idRest}),
    )
        .catchError((onError) {
      _showBottomFlash("Check your internet connection");
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
        _showBottomFlash("Something went wrong. Failed to fetch jobs");
      }
    } else {
      _showBottomFlash("Server Error");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                              //key: PageStorageKey("key3"),
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
                                                        ["Postal"] ??
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
                                                "Driver Name: ",
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
                                                        ["FullName"] ??
                                                    "Salman",
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
                                                "Car Make: ",
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
                                                        ["CarMake"] ??
                                                    "Toyota",
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
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                    ),
                                                    child: Text(
                                                      "Track Driver",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      TrackDriver(
                                                                        data: jsonData["data"]
                                                                            [
                                                                            index],
                                                                      )));
                                                    }),
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
                              //key: PageStorageKey("key3"),
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
                                                        ["Postal"] ??
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
                                                "Driver Name: ",
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
                                                        ["FullName"] ??
                                                    "Salman",
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
                                                "Car Make: ",
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
                                                        ["CarMake"] ??
                                                    "Toyota",
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
                                                    "Completed",
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
            ),
          ),
        ),
        RestNavbar(
          index: 1,
        ),
      ]),
    );
  }
}
