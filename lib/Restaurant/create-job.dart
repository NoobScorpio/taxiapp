import 'dart:convert';

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_app/Restaurant/rest-navbar.dart';
import '../Constants/APIConstants.dart';
import '../Constants/colors.dart';
import 'nearby-drivers.dart';
import 'package:http/http.dart' as http;

class CreateJob extends StatefulWidget {
  @override
  _CreateJobState createState() => _CreateJobState();
}

class _CreateJobState extends State<CreateJob> {

  var jsonData;
  int len=0;

  TextEditingController cName = new TextEditingController();
  TextEditingController cPhone = new TextEditingController();
  TextEditingController dAddress = new TextEditingController();
  TextEditingController postcode = new TextEditingController();
  TextEditingController time = new TextEditingController();
  TextEditingController ordervalue = new TextEditingController();
  LatLng destination;

  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleAPIKey);

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

  void createJob() async {
    ProgressDialog pr;
    pr = new ProgressDialog(context, showLogs: true);
    pr.style(message: 'Please wait...');
    pr.show();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int restId = prefs.getInt("idRest");

    double price;

    for(var p in jsonData["data"]){
      if(p["postcode"].toString()==postcode.text){
        price=p["price"];
      }
    }

    final http.Response response = await http
        .post(
      baseURL + createJobURL,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'cName': cName.text,
        'dAddress': dAddress.text,
        "cPhone": cPhone.text,
        "orderValue": ordervalue.text,
        "time": time.text,
        "postcode": postcode.text,
        "idRest": restId,
        "price":price
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
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => NearbyDrivers(data: jsonData["data"],)));
      } else {
        pr.hide().whenComplete(() {
          _showBottomFlash(
              "Something went wrong. Please check the provided information");
          pr.hide();
        });
      }
    } else {
      pr.hide().whenComplete(() {
        _showBottomFlash("Server Error");
        pr.hide();
      });
      throw Exception('Failed to create the order.');
    }
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

  void dropdownDialog() {
    Dialog fancyDialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
          ),
          height: 400.0,
          width: 280.0,
          child:Stack(
            children: <Widget>[
              Column(
                children: [
                  Text(
                      "Postcodes",
                    style: TextStyle(
                      color: pcolor,
                      fontSize: 18
                    ),
                  ),
                  SizedBox(height: 20,),
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: len,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return ListTile(
                          title:Text(jsonData["data"][index]["postcode"].toString()),
                          onTap: (){
                            setState(() {
                              postcode.text=jsonData["data"][index]["postcode"].toString();
                              Navigator.pop(context);
                            });
                          },);
                      }
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
          )

      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => fancyDialog);
  }

  Future<Null> displayPrediction(
      Prediction p, TextEditingController controller) async {
    if (p != null) {
      // get detail (lat/lng)
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;
      destination = LatLng(lat, lng);
      controller.text = detail.result.formattedAddress;
    }
  }

  @override
  void initState() {
    super.initState();
    getPostCodes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    color: pcolor,
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 90.0),
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.height * 0.32,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: new BorderRadius.only(
                                  //   topLeft: const Radius.circular(30.0),
                                  //  topRight: const Radius.circular(30.0),
                                  ),
                              image: DecorationImage(
                                image:
                                    AssetImage("asset/images/google_map.png"),
                                fit: BoxFit.fill,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(40.0),
                                  child: Text(
                                    "NEARBY DRIVERS",
                                    style: TextStyle(
                                      color: pcolor,
                                      fontSize: 23,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            //color: Colors.red,
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(height: 18),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 3),
                                  child: TextField(
                                    controller: cName,
                                    style: TextStyle(
                                      fontFamily: "Century Gothic",
                                      color: Colors.grey[700],
                                      fontSize: 17,
                                    ),
                                    autocorrect: false,
                                    decoration: InputDecoration(
                                      hintText: "Customer Name",
                                      contentPadding: EdgeInsets.all(0),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 3),
                                  child: TextField(
                                    controller: cPhone,
                                    style: TextStyle(
                                      fontFamily: "Century Gothic",
                                      color: Colors.grey[700],
                                      fontSize: 17,
                                    ),
                                    autocorrect: false,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: "Mobile",
                                      contentPadding: EdgeInsets.all(0),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 3),
                                  child: TextField(
                                    controller: dAddress,
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
                                                dAddress.text =
                                                    result.formattedAddress;

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
                                                                            dAddress.text =
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
                                      hintText: "Destination Address",
                                      contentPadding: EdgeInsets.all(0),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 3),
                                  child: TextField(
                                    onTap: (){
                                      dropdownDialog();
                                    },
                                    readOnly: true,
                                    controller: postcode,
                                    style: TextStyle(
                                      fontFamily: "Century Gothic",
                                      color: Colors.grey[700],
                                      fontSize: 17,
                                    ),
                                    autocorrect: false,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: "PostCode",
                                      contentPadding: EdgeInsets.all(0),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 3),
                                  child: TextField(
                                    controller: ordervalue,
                                    style: TextStyle(
                                      fontFamily: "Century Gothic",
                                      color: Colors.grey[700],
                                      fontSize: 17,
                                    ),
                                    autocorrect: false,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: "Order Value",
                                      contentPadding: EdgeInsets.all(0),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 3),
                                  child: TextField(
                                    controller: time,
                                    style: TextStyle(
                                      fontFamily: "Century Gothic",
                                      color: Colors.grey[700],
                                      fontSize: 17,
                                    ),
                                    autocorrect: false,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: "Time for Collection (minutes)",
                                      contentPadding: EdgeInsets.all(0),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 18.0),
                                  child: Center(
                                    child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      color: scolor,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 65, vertical: 13),
                                      onPressed: () {
                                        if (cPhone.text.isNotEmpty &&
                                            cName.text.isNotEmpty &&
                                            dAddress.text.isNotEmpty &&
                                            postcode.text.isNotEmpty &&
                                            ordervalue.text.isNotEmpty &&
                                            time.text.isNotEmpty) {
                                          createJob();
                                        } else {
                                          _showBottomFlash(
                                              "Please fill all the required field");
                                        }
                                      },
                                      child: Text(
                                        "CREATE JOB",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            RestNavbar(
              index: 4,
            )
          ],
        ),
      ),
    );
  }
}
