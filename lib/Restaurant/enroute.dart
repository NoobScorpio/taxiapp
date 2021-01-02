import 'dart:async';

import 'package:flutter/material.dart';
import 'package:taxi_app/Driver/reached-cust.dart';

import '../Constants/colors.dart';

class TrackDriver extends StatefulWidget {
  
  final data;
  
  TrackDriver({this.data});
  
  @override
  _TrackDriverState createState() => _TrackDriverState();
}

class _TrackDriverState extends State<TrackDriver> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  color: pcolor,
                  height: 50,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * 0.34,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.only(
                            //   topLeft: const Radius.circular(30.0),
                            //  topRight: const Radius.circular(30.0),
                            ),
                        image: DecorationImage(
                          image: AssetImage("asset/images/google_map.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Text(
                              "ENROUTE",
                              style: TextStyle(
                                color: pcolor,
                                fontSize: 23,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Align(
                                alignment: Alignment.bottomRight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 14.0),
                                      child: Container(
                                        height: 25,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        decoration: new BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: new BorderRadius.all(
                                            Radius.circular(8.0),
                                          ),
                                        ),
                                        child: Center(
                                            child: Text(
                                          "23 min away",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 18.0),
                                      child: Container(
                                        height: 25,
                                        width: 25,
                                        decoration: new BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: new BorderRadius.all(
                                            Radius.circular(8.0),
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.navigation,
                                          color: scolor,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          )
                        ],
                      ),
                      //color: Colors.red,
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              "Order No.",
                              style: TextStyle(
                                fontSize: 18,
                                color: scolor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              "1122345",
                              style: TextStyle(
                                fontSize: 19,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(height: 13),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              "Customer Name",
                              style: TextStyle(
                                fontSize: 18,
                                color: scolor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              "John Kyle",
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                fontSize: 19,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(height: 13),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              "Customer Location",
                              style: TextStyle(
                                fontSize: 18,
                                color: scolor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              "123A, St 4 Area 6, City ABC",
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                fontSize: 19,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(height: 13),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              "Postal Code",
                              style: TextStyle(
                                fontSize: 18,
                                color: scolor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              "345678",
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                fontSize: 19,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Image.asset(
                                      "asset/images/message.png",
                                      height: 30,
                                      width: 30,
                                      color: scolor,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 25.0),
                                    child: Icon(
                                      Icons.phone,
                                      color: scolor,
                                      size: 35,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
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
          ),
        ],
      ),
    );
  }
}
