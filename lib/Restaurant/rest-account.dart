import 'dart:convert';
import 'package:flash/flash.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_app/Constants/APIConstants.dart';
import 'package:taxi_app/Constants/colors.dart';
import 'package:taxi_app/Restaurant/rest-navbar.dart';
import 'package:taxi_app/Restaurant/resturant-current-jobs.dart';

import '../login.dart';

class RestAccount extends StatefulWidget {
  final data;

  RestAccount({this.data});

  @override
  _RestAccountState createState() => _RestAccountState();
}

class _RestAccountState extends State<RestAccount> {
  TextEditingController name = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController pass = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController postal = new TextEditingController();
  TextEditingController restName = new TextEditingController();
  TextEditingController address = new TextEditingController();
  TextEditingController city = new TextEditingController();
  TextEditingController code = new TextEditingController();
  TextEditingController value = new TextEditingController();
  TextEditingController ecode = new TextEditingController();
  TextEditingController evalue = new TextEditingController();

  var jsonData;
  int len = 0;

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

  void getPostCodes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int idRest = prefs.getInt("idRest");

    final http.Response response = await http
        .post(
      baseURL + getPostCodesURL,
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
        });
      } else {
        _showBottomFlash("Something went wrong. Failed to fetch jobs");
      }
    } else {
      _showBottomFlash("Server Error");
      throw Exception('Failed to fetch jobs.');
    }
  }

  void addPostCodes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int idRest = prefs.getInt("idRest");

    final http.Response response = await http
        .post(
      baseURL + addPostCodeURL,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'idRest': idRest,
        'postcode': code.text,
        'price': value.text
      }),
    )
        .catchError((onError) {
      _showBottomFlash("Check your internet connection");
    });
    print("hello");
    print(response.body);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      bool success = jsonData["success"];

      if (success == true) {
        code.text = "";
        value.text = "";
        setState(() {});
        getPostCodes();
      } else {
        _showBottomFlash(jsonData["message"]);
      }
    } else {
      _showBottomFlash("Server Error");
      throw Exception('Failed to fetch jobs.');
    }
  }

  void editPostCodes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int idRest = prefs.getInt("idRest");

    final http.Response response = await http
        .post(
      baseURL + editPostCodeURL,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'idRest': idRest,
        'postcode': ecode.text,
        'price': evalue.text
      }),
    )
        .catchError((onError) {
      _showBottomFlash("Check your internet connection");
    });
    print("hello");
    print(response.body);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      bool success = jsonData["success"];

      if (success == true) {
        getPostCodes();
      } else {
        _showBottomFlash("Something went wrong. Failed to fetch jobs");
      }
    } else {
      _showBottomFlash("Server Error");
      throw Exception('Failed to fetch jobs.');
    }
  }

  void deletePostCodes(String code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int idRest = prefs.getInt("idRest");

    final http.Response response = await http
        .post(
      baseURL + deletePostCodeURL,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{'idRest': idRest, 'postcode': code}),
    )
        .catchError((onError) {
      _showBottomFlash("Check your internet connection");
    });
    print("hello");
    print(response.body);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      bool success = jsonData["success"];

      if (success == true) {
        getPostCodes();
      } else {
        _showBottomFlash("Something went wrong. Failed to fetch jobs");
      }
    } else {
      _showBottomFlash("Server Error");
      throw Exception('Failed to fetch jobs.');
    }
  }

  void updateRest() async {
    ProgressDialog pr;
    pr = new ProgressDialog(context, showLogs: true);
    pr.style(message: 'Please wait...');
    pr.show();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int idRest = prefs.getInt("idRest");

    final http.Response response = await http
        .post(
      baseURL + updateRestURL,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'idDriver': idRest,
        'name': name.text,
        'email': email.text,
        'restName': restName.text,
        'password': pass.text,
        'address': address.text,
        'postal': postal.text,
        'city': city.text,
        'phone': phone.text,
      }),
    )
        .catchError((onError) {
      pr.hide().whenComplete(() {
        _showBottomFlash("Check your internet connection");
        pr.hide();
      });
    });
    print("hello");
    pr.hide();
    print(response.body);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      bool success = jsonData["success"];

      if (success == true) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RestCurrJobs()));
      } else {
        _showBottomFlash("Check the given Information and try again");
      }
    } else {
      _showBottomFlash("Server Error");
      throw Exception('Failed to create login session.');
    }
  }

  void dropdownDialog() {
    Dialog fancyDialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
          ),
          height: 250.0,
          width: 280.0,
          child: Stack(
            children: <Widget>[
              Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Edit Postcode",
                    style: TextStyle(color: pcolor, fontSize: 18),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: TextField(
                            controller: ecode,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Postcode",
                              contentPadding: EdgeInsets.all(
                                0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: evalue,
                            decoration: InputDecoration(
                              labelText: "Value",
                              contentPadding: EdgeInsets.all(
                                0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 25.0, top: 5),
                        child: GestureDetector(
                          onTap: () {
                            if (ecode.text.isNotEmpty &&
                                evalue.text.isNotEmpty) {
                              Navigator.pop(context);
                              editPostCodes();
                            } else {
                              _showBottomFlash(
                                  "Insert valid postcode and value");
                            }
                          },
                          child: CircleAvatar(
                            backgroundColor: scolor,
                            radius: 15,
                            child: Icon(Icons.check_circle_outline,
                                color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: () {
                    // Navigator.push(context, MaterialPageRoute(
                    //    builder:(context)=>Invoice()
                    ///));
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      color: scolor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Close",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Poppins",
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
    showDialog(
        context: context, builder: (BuildContext context) => fancyDialog);
  }

  @override
  void initState() {
    super.initState();
    getPostCodes();
    name = new TextEditingController(text: widget.data["name"]);
    email = new TextEditingController(text: widget.data["email"]);
    pass = new TextEditingController(text: widget.data["password"]);
    phone = new TextEditingController(text: widget.data["phone"]);
    postal = new TextEditingController(text: widget.data["postal"]);
    restName = new TextEditingController(text: widget.data["restName"]);
    address = new TextEditingController(text: widget.data["address"]);
    city = new TextEditingController(text: widget.data["city"]);
    current = 3;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                color: scolor,
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 50,
                    color: pcolor,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Account",
                      style: TextStyle(
                        color: pcolor,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20.0, right: 20, top: 10),
                    child: Container(
                      height: MediaQuery.of(context).size.height - 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: Offset(0, 1), // changes position of shadow
                          ),
                        ],
                        color: Colors.white,
                      ),
                      // height: MediaQuery.of(context).size.height * 0.6,
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 25.0,
                                right: 25,
                                top: 17,
                              ),
                              child: TextField(
                                controller: name,
                                decoration: InputDecoration(
                                  labelText: "Full Name",
                                  contentPadding: EdgeInsets.all(
                                    0,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25, top: 15),
                              child: TextField(
                                controller: email,
                                decoration: InputDecoration(
                                  labelText: "Email",
                                  contentPadding: EdgeInsets.all(
                                    0,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25, top: 15),
                              child: TextField(
                                controller: pass,
                                decoration: InputDecoration(
                                  labelText: "Password",
                                  contentPadding: EdgeInsets.all(
                                    0,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25, top: 15),
                              child: TextField(
                                controller: restName,
                                decoration: InputDecoration(
                                  labelText: "Resturant Name",
                                  contentPadding: EdgeInsets.all(
                                    0,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25, top: 15),
                              child: TextField(
                                controller: address,
                                decoration: InputDecoration(
                                  labelText: "Address",
                                  contentPadding: EdgeInsets.all(
                                    0,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25, top: 15),
                              child: TextField(
                                controller: city,
                                decoration: InputDecoration(
                                  labelText: "City",
                                  contentPadding: EdgeInsets.all(
                                    0,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25, top: 15),
                              child: TextField(
                                controller: postal,
                                decoration: InputDecoration(
                                  labelText: "Postal Code",
                                  contentPadding: EdgeInsets.all(
                                    0,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25, top: 15),
                              child: TextField(
                                controller: phone,
                                decoration: InputDecoration(
                                  labelText: "Phone",
                                  contentPadding: EdgeInsets.all(
                                    0,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 25.0),
                                      child: TextField(
                                        controller: code,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText: "Postcode",
                                          contentPadding: EdgeInsets.all(
                                            0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        controller: value,
                                        decoration: InputDecoration(
                                          labelText: "Value",
                                          contentPadding: EdgeInsets.all(
                                            0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 25.0, top: 5),
                                    child: GestureDetector(
                                      onTap: () {
                                        if (code.text.isNotEmpty &&
                                            value.text.isNotEmpty) {
                                          addPostCodes();
                                        } else {
                                          _showBottomFlash(
                                              "Insert valid postcode and value");
                                        }
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: scolor,
                                        radius: 15,
                                        child: Icon(Icons.add,
                                            color: Colors.white),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: len,
                                  itemBuilder: (BuildContext ctxt, int index) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 25.0),
                                              child: Text(
                                                jsonData["data"][index]
                                                        ["postcode"]
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.grey[600]),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 25.0),
                                              child: Text(
                                                "\u{00a3} " +
                                                    jsonData["data"][index]
                                                            ["price"]
                                                        .toString(),
                                                style: TextStyle(
                                                    color: Colors.grey[600]),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.edit,
                                                  color: Colors.grey[600]),
                                              onPressed: () {
                                                ecode.text = jsonData["data"]
                                                        [index]["postcode"]
                                                    .toString();
                                                evalue.text = jsonData["data"]
                                                        [index]["price"]
                                                    .toString();
                                                setState(() {});
                                                dropdownDialog();
                                              },
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15.0),
                                              child: IconButton(
                                                icon: Icon(Icons.delete,
                                                    color: Colors.grey[600]),
                                                onPressed: () {
                                                  deletePostCodes(
                                                      jsonData["data"][index]
                                                              ["postcode"]
                                                          .toString());
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  }),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 12.0, bottom: 12),
                                  child: MaterialButton(
                                    color: scolor,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 18, vertical: 10),
                                    onPressed: () {
                                      updateRest();
                                    },
                                    child: Text(
                                      "Update Profile",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 12.0, bottom: 12, left: 9),
                                  child: MaterialButton(
                                    color: Colors.redAccent,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 35, vertical: 10),
                                    onPressed: () async {
                                      //OneSignal.shared.setSubscription(false);
                                      //OneSignal.shared.removeExternalUserId();
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.clear();
                                      prefs.setBool("isLogin", false);
                                      Navigator.popUntil(
                                          context, (route) => false);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Login()));
                                    },
                                    child: Text(
                                      "Logout",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            RestNavbar(
              index: 3,
            )
          ],
        ),
      ),
    );
  }
}
