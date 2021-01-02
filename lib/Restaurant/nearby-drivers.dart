import 'dart:async';
import 'dart:convert';
import 'package:flash/flash.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_app/Constants/APIConstants.dart';
import 'package:taxi_app/Restaurant/rest-navbar.dart';

import '../Constants/colors.dart';
import 'driver-found.dart';

class NearbyDrivers extends StatefulWidget {

  final data;

  NearbyDrivers({this.data});

  @override
  _NearbyDriversState createState() => _NearbyDriversState();
}

class _NearbyDriversState extends State<NearbyDrivers> {
  Completer<GoogleMapController> _controller = Completer();
  var jsonData;

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
              message: Text(msg??""),
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

  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(0, 0),
    zoom: 14.4746,
  );
  double latitude, longitude;
  int restId;

  setRestLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double lat = prefs.getDouble("lat");
    double lng = prefs.getDouble("lng");
    restId = prefs.getInt("idRest");

    latitude = lat;
    longitude = lng;

    _kGooglePlex = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 14.4746,
    );
    setState(() {});
  }

  void nearbyDrivers() async {
    ProgressDialog pr;
    pr = new ProgressDialog(context, showLogs: true);
    pr.style(message: 'Please wait...');
    pr.show();
    final http.Response response = await http
        .post(
      baseURL + nearByURL,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{'restId': restId}),
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
          _showBottomFlash(jsonData["message"]);
          pr.hide();
        });
      }
    } else {
      pr.hide().whenComplete(() {
        _showBottomFlash("Server Error");
        pr.hide();
      });
      throw Exception('Failed to fetch nearby drivers.');
    }
  }

  void checkOrderStatus() async {
    final http.Response response = await http
        .post(
      baseURL + checkOrderStatusURL,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{'idOrder': widget.data["idOrder"]}),
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
      } else {

      }
    } else {
      _showBottomFlash("Server Error");
      throw Exception('Failed to fetch nearby drivers.');
    }
  }

  @override
  void initState() {
    super.initState();

    Timer.periodic(
        Duration(seconds: 2), (timer) {
          checkOrderStatus();
          if(jsonData!=null){
            if(jsonData["success"]) {
              if (jsonData["data"]["Status"] == "Accepted") {
                timer.cancel();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(
                    builder: (context) => DriverFound(data: jsonData["data"])));
              }
            }
          }
          if(!mounted){
            timer.cancel();
            return;
          }
          setState(() {

          });
    });
    setRestLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            /*
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "asset/images/full_map.png",
                ),
                fit: BoxFit.cover,
              ),
            ),

             */
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
          Container(
            color: pcolor.withOpacity(0.7),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: <Widget>[
                Container(
                  color: pcolor,
                  height: 50,
                ),
                RestNavbar(index: 4,)
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Text(
                    "FINDING NEARBY DRIVERS FOR DELIVERY..",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w400,
                      fontSize: 23,
                    ),
                  ),
                ),
              ),
              Lottie.asset(
                'asset/json/finding.json',
                height: 280,
                width: 280,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
