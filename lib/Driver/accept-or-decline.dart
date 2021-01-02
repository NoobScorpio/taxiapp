import 'package:flutter/material.dart';
import 'package:taxi_app/Driver/current-jobs.dart';
import 'package:taxi_app/Driver/job-found.dart';
import '../Constants/colors.dart';
import 'Navbar.dart';

class AccOrDec extends StatefulWidget {
  final data;

  AccOrDec({this.data});

  @override
  _AccOrDecState createState() => _AccOrDecState();
}

class _AccOrDecState extends State<AccOrDec> {
  @override
  void initState() {
    super.initState();
    print(widget.data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("asset/images/google_map.png"),
                fit: BoxFit.cover)),
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Color.fromRGBO(61, 6, 95, 0.7),
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                          width: double.infinity,
                          decoration: new BoxDecoration(
                            color: Colors.white,
                            borderRadius: new BorderRadius.all(
                              Radius.circular(22.0),
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(right: 5.0, top: 5),
                                    child: IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          size: 22,
                                        ),
                                        onPressed: null),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Restaurant",
                                      style: TextStyle(
                                        color: scolor,
                                        wordSpacing: 1,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17,
                                        fontFamily: "Century Gothic",
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      widget.data["RestaurantName"] ?? "Ranchers",
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                        color: Colors.grey,
                                        wordSpacing: 1,
                                        fontSize: 20,
                                        fontFamily: "Century Gothic",
                                      ),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      "Location",
                                      style: TextStyle(
                                        color: scolor,
                                        wordSpacing: 1,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17,
                                        fontFamily: "Century Gothic",
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      child: Text(
                                        widget.data["Address"] ??
                                            "123A, St 5 Area 6, City ABC",
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.visible,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          wordSpacing: 1,
                                          fontSize: 20,
                                          fontFamily: "Century Gothic",
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      "Postal Code",
                                      style: TextStyle(
                                        color: scolor,
                                        wordSpacing: 1,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17,
                                        fontFamily: "Century Gothic",
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      widget.data["Postal"].toString() ??
                                          "2348243",
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                        color: Colors.grey,
                                        wordSpacing: 1,
                                        fontSize: 20,
                                        fontFamily: "Century Gothic",
                                      ),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      "Expected Collection Time",
                                      style: TextStyle(
                                        color: scolor,
                                        wordSpacing: 1,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17,
                                        fontFamily: "Century Gothic",
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      child: Text(
                                        "10 minutes",
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.visible,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          wordSpacing: 1,
                                          fontSize: 20,
                                          fontFamily: "Century Gothic",
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 11,
                                    ),
                                    RaisedButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => JobFound(
                                                    idOrder:
                                                        widget.data["idOrder"])));
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6.0),
                                      ),
                                      color: pcolor,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 50, vertical: 10),
                                      child: Text(
                                        "ACCEPT",
                                        style: TextStyle(
                                          color: Colors.white,
                                          letterSpacing: 0.9,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 0,
                                    ),
                                    RaisedButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CurrJobs()));
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6.0),
                                      ),
                                      color: scolor,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 50, vertical: 10),
                                      child: Text(
                                        "DECLINE",
                                        style: TextStyle(
                                          color: Colors.white,
                                          letterSpacing: 0.9,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 0,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Navbar(
                index: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
