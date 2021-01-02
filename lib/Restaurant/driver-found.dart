import 'package:flutter/material.dart';
import 'pay-driver.dart';

import '../Constants/colors.dart';

class DriverFound extends StatefulWidget {

  final data;

  DriverFound({this.data});

  @override
  _DriverFoundState createState() => _DriverFoundState();
}

class _DriverFoundState extends State<DriverFound> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("asset/images/google_map.png"),
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Color.fromRGBO(61, 6, 95, 0.7),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
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
                        "DRIVER DETAILS",
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
                          child: Stack(
                            children: <Widget>[
                              Positioned(
                                  top: 0,
                                  right: 0,
                                  child: IconButton(
                                      icon: Icon(
                                        Icons.close,
                                        size: 22,
                                      ),
                                      onPressed: null)),
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Driver",
                                      style: TextStyle(
                                        color: scolor,
                                        wordSpacing: 1,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        fontFamily: "Century Gothic",
                                      ),
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Flexible(
                                      child: Text(
                                        widget.data["FullName"]??"John Skyle",
                                        overflow: TextOverflow.visible,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          wordSpacing: 1,
                                          fontSize: 22,
                                          fontFamily: "Century Gothic",
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 14,
                                    ),
                                    Text(
                                      "Estimated Arrival",
                                      style: TextStyle(
                                        color: scolor,
                                        wordSpacing: 1,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        fontFamily: "Century Gothic",
                                      ),
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Flexible(
                                      child: Text(
                                        widget.data["time"]??"10 min",
                                        overflow: TextOverflow.visible,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          wordSpacing: 1,
                                          fontSize: 22,
                                          fontFamily: "Century Gothic",
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 14,
                                    ),
                                    Text(
                                      "Car Details",
                                      style: TextStyle(
                                        color: scolor,
                                        wordSpacing: 1,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        fontFamily: "Century Gothic",
                                      ),
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Flexible(
                                      child: Text(
                                        widget.data["CarMake"]==null?"Toyota Prius 1332":widget.data["CarMake"]+" "+widget.data["RegistrationNo"],
                                        overflow: TextOverflow.visible,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          wordSpacing: 1,
                                          fontSize: 22,
                                          fontFamily: "Century Gothic",
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 41,
                                    ),
                                    RaisedButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PayDriver()));
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                      color: scolor,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 60, vertical: 10),
                                      child: Text(
                                        "Track Driver",
                                        style: TextStyle(
                                          color: Colors.white,
                                          letterSpacing: 0.9,
                                          fontSize: 19,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Image.asset(
                              "asset/images/home.png",
                              color: Colors.grey,
                              height: 29,
                              width: 29,
                            ),
                          ),
                          Text(
                            "HOME",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                            ),
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Image.asset(
                              "asset/images/car.png",
                              color: Colors.grey,
                              height: 30,
                              width: 30,
                            ),
                          ),
                          Text(
                            "JOBS",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                            ),
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Image.asset(
                              "asset/images/wallet.png",
                              color: Colors.grey,
                              height: 30,
                              width: 30,
                            ),
                          ),
                          Text(
                            "WALLET",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                            ),
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Image.asset(
                              "asset/images/user.png",
                              color: Colors.grey,
                              height: 28,
                              width: 28,
                            ),
                          ),
                          Text(
                            "ACCOUNT",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
