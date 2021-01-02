import 'dart:convert';
import 'package:flash/flash.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../Constants/APIConstants.dart';
import '../Constants/colors.dart';
import 'login-restuarant.dart';

class RegRest extends StatefulWidget {
  @override
  _RegRestState createState() => _RegRestState();
}

class _RegRestState extends State<RegRest> {
  TextEditingController email = new TextEditingController();
  TextEditingController pass = new TextEditingController();
  TextEditingController name = new TextEditingController();
  TextEditingController restName = new TextEditingController();
  TextEditingController address = new TextEditingController();
  TextEditingController city = new TextEditingController();
  TextEditingController postal = new TextEditingController();
  TextEditingController phone = new TextEditingController();

  LatLng destination;

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
          borderRadius: BorderRadius.only(topRight: Radius.circular(8),topLeft: Radius.circular(8)),
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
              icon: Icon(Icons.error,color: Colors.white,),
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


  void signUp() async {
    ProgressDialog pr;
    pr = new ProgressDialog(context, showLogs: true);
    pr.style(message: 'Please wait...');
    pr.show();
    final http.Response response = await http
        .post(
      baseURL + driverSignup,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'email': email.text,
        'password': pass.text,
        "name": name.text,
        "restName": restName.text,
        "phone": phone.text,
        "address": address.text,
        "postal": postal.text,
        "city": city.text,
        "lat":destination.latitude,
        "lng":destination.longitude
      }),
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
      } else {
        pr.hide().whenComplete(() {
          _showBottomFlash("Something went wrong. Please check the provided information");
          pr.hide();
        });
      }
    } else {
      pr.hide().whenComplete(() {
        _showBottomFlash("Server Error");
        pr.hide();
      });
      throw Exception('Failed to create login session.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: size.height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image.asset(
                'asset/images/resturant.png',
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 3),
                child: TextField(
                  controller: name,
                  style: TextStyle(
                    fontFamily: "Century Gothic",
                    color: Colors.grey[700],
                    fontSize: 17,
                  ),
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: "Full Name",
                    contentPadding: EdgeInsets.all(0),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 3),
                child: TextField(
                  controller: email,
                  style: TextStyle(
                    fontFamily: "Century Gothic",
                    color: Colors.grey[700],
                    fontSize: 17,
                  ),
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Email",
                    contentPadding: EdgeInsets.all(0),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 3),
                child: TextField(
                  controller: pass,
                  obscureText: true,
                  style: TextStyle(
                    fontFamily: "Century Gothic",
                    color: Colors.grey[700],
                    fontSize: 17,
                  ),
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: "Password",
                    contentPadding: EdgeInsets.all(0),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 3),
                child: TextField(
                  controller: restName,
                  style: TextStyle(
                    fontFamily: "Century Gothic",
                    color: Colors.grey[700],
                    fontSize: 17,
                  ),
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: "Resturant Name",
                    contentPadding: EdgeInsets.all(0),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 3),
                child: TextField(
                  controller: address,
                  readOnly: true,
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return PlacePicker(
                            apiKey: kGoogleAPIKey,
                            initialPosition: LatLng(0, 0),
                            //autocompleteComponents: [Component(Component.country, "se")],
                            useCurrentLocation: true,
                            //autocompleteLanguage: "se",
                            usePlaceDetailSearch: true,
                            usePinPointingSearch: true,
                            onPlacePicked: (result) {
                              address.text =
                                  result.formattedAddress;

                              destination=LatLng(result.geometry.location.lat,result.geometry.location.lng);

                              Navigator.of(context).pop();
                              setState(() {});
                            },
                            //region: "se",
                            selectedPlaceWidgetBuilder: (_,
                                selectedPlace,
                                state,
                                isSearchBarFocused) {
                              return isSearchBarFocused
                                  ? Container()
                              // Use FloatingCard or just create your own Widget.
                                  : FloatingCard(
                                elevation: 5,
                                bottomPosition:
                                25.0, // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
                                leftPosition: 10.0,
                                rightPosition: 10.0,

                                borderRadius:
                                BorderRadius
                                    .circular(12.0),
                                child: state ==
                                    SearchingState
                                        .Searching
                                    ? Center(
                                    child: Padding(
                                      padding:
                                      const EdgeInsets
                                          .all(
                                          10.0),
                                      child:
                                      CircularProgressIndicator(),
                                    ))
                                    : Padding(
                                  padding:
                                  const EdgeInsets
                                      .all(
                                      10.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        selectedPlace
                                            .formattedAddress,
                                        textAlign:
                                        TextAlign
                                            .center,
                                        style: TextStyle(
                                            fontSize:
                                            18),
                                      ),
                                      SizedBox(
                                        height:
                                        10,
                                      ),
                                      Container(
                                          width:
                                          120,
                                          child:
                                          RaisedButton(
                                            child:
                                            Text(
                                              "Select here",
                                              style:
                                              TextStyle(color: Colors.white),
                                            ),
                                            color: Color.fromRGBO(
                                                11,
                                                142,
                                                54,
                                                1),
                                            onPressed:
                                                () {
                                              address.text =
                                                  selectedPlace.formattedAddress;
                                              Navigator.of(context).pop();
                                              setState(() {});
                                            },
                                          )),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                  style: TextStyle(
                    fontFamily: "Century Gothic",
                    color: Colors.grey[700],
                    fontSize: 17,
                  ),
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: "Address",
                    contentPadding: EdgeInsets.all(0),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 3),
                child: TextField(
                  controller: city,
                  style: TextStyle(
                    fontFamily: "Century Gothic",
                    color: Colors.grey[700],
                    fontSize: 17,
                  ),
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: "City",
                    contentPadding: EdgeInsets.all(0),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 3),
                child: TextField(
                  controller: postal,
                  style: TextStyle(
                    fontFamily: "Century Gothic",
                    color: Colors.grey[700],
                    fontSize: 17,
                  ),
                  keyboardType: TextInputType.number,
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: "Postal Code",
                    contentPadding: EdgeInsets.all(0),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 3),
                child: TextField(
                  controller: phone,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontFamily: "Century Gothic",
                    color: Colors.grey[700],
                    fontSize: 17,
                  ),
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: "Phone",
                    contentPadding: EdgeInsets.all(0),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 15,
                ),
                child: RaisedButton(
                  color: scolor,
                  padding: EdgeInsets.symmetric(horizontal: 55, vertical: 13),
                  onPressed: () {
                    if (email.text.isNotEmpty &&
                        pass.text.isNotEmpty &&
                        postal.text.isNotEmpty &&
                        address.text.isNotEmpty &&
                        name.text.isNotEmpty &&
                        restName.text.isNotEmpty &&
                        city.text.isNotEmpty &&
                        phone.text.isNotEmpty) {
                      signUp();
                    } else {
                      _showBottomFlash("Please fill all the required fields");
                    }
                  },
                  child: Text(
                    "REGISTER",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 5.0,
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginRest()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey[800],
                          decoration: TextDecoration.none,
                        ),
                      ),
                      Text(
                        " Signin",
                        style: TextStyle(
                          fontSize: 14.0,
                          color: scolor,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}
