import 'package:flutter/material.dart';
import 'package:taxi_app/Driver/Navbar.dart';

import '../Constants/colors.dart';

class PayDriver extends StatefulWidget {
  @override
  _PayDriverState createState() => _PayDriverState();
}

class _PayDriverState extends State<PayDriver> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {},
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              color: scolor,
              height: MediaQuery.of(context).size.height,
            ),
            Navbar(),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 35.0, vertical: 20),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.65,
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.all(
                            Radius.circular(22.0),
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
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Divider(
                              indent: 40,
                              endIndent: 40,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 24.0),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "Customer: ",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      fontFamily: "Century Gothic",
                                    ),
                                  ),
                                  Text(
                                    "John Kyle",
                                    style: TextStyle(
                                      color: scolor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      fontFamily: "Century Gothic",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 24.0),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "Customer Phone: ",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      fontFamily: "Century Gothic",
                                    ),
                                  ),
                                  Text(
                                    "+123 456 789",
                                    style: TextStyle(
                                      color: scolor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      fontFamily: "Century Gothic",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 24.0, right: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Dest Address: ",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      fontFamily: "Century Gothic",
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      "123A, St 3, Block C",
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                        color: scolor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        fontFamily: "Century Gothic",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 24.0),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "Driver: ",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      fontFamily: "Century Gothic",
                                    ),
                                  ),
                                  Text(
                                    "Jerald Hoggs",
                                    style: TextStyle(
                                      color: scolor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      fontFamily: "Century Gothic",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 24.0),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "Car Details: ",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      fontFamily: "Century Gothic",
                                    ),
                                  ),
                                  Text(
                                    "Toyota Prius 2234",
                                    style: TextStyle(
                                      color: scolor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      fontFamily: "Century Gothic",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Divider(
                              indent: 40,
                              endIndent: 40,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Amount: ",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 20,
                                    fontFamily: "Century Gothic",
                                  ),
                                ),
                                Text(
                                  "\u00A310",
                                  style: TextStyle(
                                    color: scolor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    fontFamily: "Century Gothic",
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            RaisedButton(
                              onPressed: () {},
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              color: pcolor,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 75, vertical: 7),
                              child: Text(
                                "PAY",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
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
      ),
    );
  }
}
