import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:taxi_app/Constants/APIConstants.dart';
import 'Navbar.dart';
import 'accept-or-decline.dart';
import '../Constants/colors.dart';
import 'package:http/http.dart' as http;

import 'job-found.dart';

class CurrJobs extends StatefulWidget {
  @override
  _CurrJobsState createState() => _CurrJobsState();
}

class _CurrJobsState extends State<CurrJobs> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  int len = 0;
  bool empty = false;
  var jsonData;
  bool sort=false;

  void getOrdersList() async {

    final http.Response response = await http.get(
      baseURL + ordersListURL,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).catchError((onError) {
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
      throw Exception('Failed to fetch the jobs');
    }
  }

  /*
  void checkDriverStatus() async {
    ProgressDialog pr;
    pr = new ProgressDialog(context, showLogs: true);
    pr.style(message: 'Please wait...');
    pr.show();

    SharedPreferences prefs=await SharedPreferences.getInstance();
    int idDriver=prefs.getInt("idDriver");

    final http.Response response = await http
        .post(
      baseURL + checkDriverStatusURL,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{'idDriver': idDriver}),
    )
        .catchError((onError) {
      pr.hide().whenComplete((){
        _scaffoldkey.currentState.showSnackBar(SnackBar(content: Text("Check your inter net connection",style: TextStyle(color: Colors.white),),backgroundColor: Colors.red,));
        pr.hide();
      });
    });
    print("hello");
    print(response.body);
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);

      bool success = jsonData["success"];

      if (success == true) {

      } else {
        pr.hide().whenComplete(() {
        _scaffoldkey.currentState.showSnackBar(SnackBar(content: Text("Something went wrong",style: TextStyle(color: Colors.white),),backgroundColor: Colors.red,));
            pr.hide();
        });
      }
    } else {
      pr.hide().whenComplete(() => {
      _scaffoldkey.currentState.showSnackBar(SnackBar(content: Text("Server Error",style: TextStyle(color: Colors.white),),backgroundColor: Colors.red,));
          pr.hide();
      });
      throw Exception('Failed to create login session.');
    }
  }


   */
  @override
  void initState() {
    super.initState();
    getOrdersList();
    current = 0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {},
      child: Scaffold(
        key: _scaffoldkey,
        //backgroundColor: scolor,
        body: Stack(
          children: <Widget>[
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
                                        builder: (context) => AccOrDec(
                                            data: jsonData["data"][index])));
                              },
                              child: Padding(
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
                                              "Restaurant: ",
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
                                                          ["RestaurantName"]
                                                      .toString() ??
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
                                              jsonData["data"][index]["Address"]
                                                      .toString() ??
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
                                              jsonData["data"][index]["Postal"]
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
                                              "Expected Collection Time: ",
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
                                      SizedBox(
                                        height: 1,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 11.0),
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
                                                      BorderRadius.circular(30),
                                                ),
                                                child: Text(
                                                  "Accept",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => JobFound(
                                                              idOrder:
                                                              jsonData["data"][index]["idOrder"])));
                                                },
                                              ),
                                            ),
                                            /*
                                            ButtonTheme(
                                              height: 25,
                                              minWidth: 25,
                                              child: FlatButton(
                                                onPressed: () {},
                                                child: Text(
                                                  "Decline",
                                                  style: TextStyle(
                                                    color: pcolor,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ),

                                             */
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 4,
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
            Navbar(
              index: 0,
            ),
            Column(
              children: <Widget>[
                Container(
                  color: pcolor,
                  height: 50,
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
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(
                              Icons.sort,
                              color: Colors.white,
                              size: 31,
                            ),
                            onPressed: (){
                              List temp=jsonData["data"].reversed.toList();
                              jsonData=temp;
                              setState(() {

                              });
                            }),

                        Text(
                          "Jobs",
                          style: TextStyle(
                            color: pcolor,
                            fontSize: 24,
                          ),
                        ),

                        IconButton(
                            icon: Icon(
                              Icons.notifications,
                              color: Colors.white,
                              size: 31,
                            ),
                            onPressed: null),

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
