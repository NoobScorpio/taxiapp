import 'package:flutter/material.dart';

import 'Constants/colors.dart';

class TopUp extends StatefulWidget {
  @override
  _TopUpState createState() => _TopUpState();
}

class _TopUpState extends State<TopUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            color: scolor,
            height: MediaQuery.of(context).size.height,
          ),
          Positioned(
            bottom: 0,
            child: Container(
              decoration: new BoxDecoration(
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
                      Icon(
                        Icons.home,
                        color: Colors.grey,
                        size: 38,
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
                      Icon(
                        Icons.drive_eta,
                        color: Colors.grey,
                        size: 38,
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
                      Icon(
                        Icons.account_balance_wallet,
                        color: Colors.grey,
                        size: 38,
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
                      Icon(
                        Icons.account_box,
                        color: Colors.grey,
                        size: 38,
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
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                color: pcolor,
                height: 50,
              ),
              Column(
                children: <Widget>[
                  SizedBox(
                    height: 45,
                  ),
                  Text(
                    "Pay Driver",
                    style: TextStyle(
                      color: pcolor,
                      fontSize: 25,
                      fontFamily: "Century Gothic",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(35.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 400,
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(22.0),
                          topRight: const Radius.circular(22.0),
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              "Driver has delivered the package",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                                fontFamily: "Century Gothic",
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Order ID: ",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 20,
                                  fontFamily: "Century Gothic",
                                ),
                              ),
                              Text(
                                "99087",
                                style: TextStyle(
                                  color: scolor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  fontFamily: "Century Gothic",
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
