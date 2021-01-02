//start job
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:taxi_app/Constants/APIConstants.dart';
import 'package:taxi_app/Driver/Navbar.dart';
import 'package:taxi_app/Driver/current-jobs.dart';
import 'package:taxi_app/Driver/reached-cust.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Constants/colors.dart';
import 'driver-my-jobs.dart';

const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;

class ReachedRest extends StatefulWidget {
  final data;
  final double slat, slong, dlat, dlong;

  ReachedRest({this.data, this.dlat, this.slat, this.dlong, this.slong});

  @override
  _ReachedRestState createState() => _ReachedRestState();
}

class _ReachedRestState extends State<ReachedRest> {
  String phone;
  Completer<GoogleMapController> _controller = Completer();
  LatLng rloc = LatLng(0, 0);
  Set<Marker> markers = {};
  String _placeDistance;
  LocationData currentLocation;
  Location location;

  PolylinePoints polylinePoints, polylinePoints2;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  List<LatLng> polylineCoordinates2 = [];
  final Set<Polyline> _polyline = {};

  CameraPosition iniCamera=CameraPosition(
    target: LatLng(0,0),
    zoom: 14.4746,
  );

  addMarker() {
    Marker rest = Marker(
      markerId: MarkerId("rest"),
      position: rloc,
      visible: true,
      icon: BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(
        title: 'Restaurant',
      ),
    );
    markers.add(rest);
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: rloc,
    );
    _controller.future.then((value) =>
        value.animateCamera(CameraUpdate.newCameraPosition(cPosition)));
  }

  void restLoc(int idOrder) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int idDriver = prefs.getInt("idDriver");
    print(idDriver);
    print(idOrder);
    final http.Response response = await http.post(
      baseURL + getRestLocURL,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, dynamic>{'idOrder': idOrder, 'idDriver': idDriver}),
    );
    print("hello");
    print(response.body);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      bool success = jsonData["success"];

      if (success == true) {
        rloc = LatLng(jsonData["data"]["lat"], jsonData["data"]["lng"]);
        phone = jsonData["data"]["phone"];
        setState(() {});
      } else {}
    } else {
      throw Exception('Failed to create login session.');
    }
  }

  void startJob(int idOrder) async {
    ProgressDialog pr;
    pr = new ProgressDialog(context, showLogs: true);
    pr.style(message: 'Please wait...');
    pr.show();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int idDriver = prefs.getInt("idDriver");

    final http.Response response = await http
        .post(
      baseURL + startJobURL,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, dynamic>{'idOrder': idOrder, 'idDriver': idDriver}),
    )
        .catchError((onError) {
      pr.hide().whenComplete(() {
        _scaffoldkey.currentState.showSnackBar(SnackBar(
          content: Text(
            "Check your internet connection",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
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
            context, MaterialPageRoute(builder: (context) => ReachedCust()));
      } else {
        pr.hide().whenComplete(() {
          _scaffoldkey.currentState.showSnackBar(SnackBar(
            content: Text(
              jsonData["message"],
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ));
          pr.hide();
        });
      }
    } else {
      pr.hide().whenComplete(() {
        _scaffoldkey.currentState.showSnackBar(SnackBar(
          content: Text(
            "Server Error",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
        pr.hide();
      });
      throw Exception('Failed to create login session.');
    }
  }

  void cancelJob(int idOrder) async {
    ProgressDialog pr;
    pr = new ProgressDialog(context, showLogs: true);
    pr.style(message: 'Please wait...');
    pr.show();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int idDriver = prefs.getInt("idDriver");

    final http.Response response = await http
        .post(
      baseURL + cancelOrderURL,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, dynamic>{'idOrder': idOrder, 'idDriver': idDriver}),
    )
        .catchError((onError) {
      pr.hide().whenComplete(() {
        _scaffoldkey.currentState.showSnackBar(SnackBar(
          content: Text(
            "Check your internet connection",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
        pr.hide();
      });
    });
    print("hello");
    print(response.body);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      bool success = jsonData["success"];

      if (success == true) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => CurrJobs()));
      } else {
        pr.hide().whenComplete(() {
          _scaffoldkey.currentState.showSnackBar(SnackBar(
            content: Text(
              jsonData["message"],
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ));
          pr.hide();
        });
      }
    } else {
      pr.hide().whenComplete(() {
        _scaffoldkey.currentState.showSnackBar(SnackBar(
          content: Text(
            "Server Error",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
        pr.hide();
      });
      throw Exception('Failed to create login session.');
    }
  }

  updateDLoc(double lat,double lng) async {
    SharedPreferences prefs=await SharedPreferences.getInstance();
    int idDriver=prefs.getInt("idDriver");

    final http.Response response = await http
        .post(
      baseURL + updateDLocURL,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{'lat': lat,'lng':lng, 'idDriver': idDriver}),
    );
    print("hello");
    print(response.body);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      bool success = jsonData["success"];

      if (success == true) {

      } else {

      }
    } else {
      throw Exception('Failed to update driver location.');
    }
  }

  _createPolylines(LatLng start, LatLng destination) async {

    print(start.latitude);
    print(destination.latitude);

    polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      kGoogleAPIKey, // Google Maps API Key
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
      visible: true,
    );
    _polyline.add(polyline);
    polylines[id] = polyline;
    setState(() {});
  }

  BitmapDescriptor c, s, d;

  icon() {
    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.0),
            'asset/images/marker.png')
        .then((onValue) {
      c = onValue;
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.0),
            'asset/images/driving_pin.png')
        .then((onValue) {
      s = onValue;
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.0),
            'asset/images/destination_map_marker.png')
        .then((onValue) {
      d = onValue;
    });
  }

  Future<bool> _calculateDistance() async {
    try {
      double totalDistance = 0.0;

      // Calculating the total distance by adding the distance
      // between small segments
      for (int i = 0; i < polylineCoordinates.length - 1; i++) {
        totalDistance += _coordinateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude,
        );
      }

      setState(() {
        _placeDistance = totalDistance.toStringAsFixed(2);
        print('DISTANCE: $_placeDistance km');
      });

      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Timer time;

  StopWatchTimer _stopWatchTimer = StopWatchTimer(); // Create instance.

  @override
  void initState() {
    super.initState();
    location = new Location();
    polylinePoints = PolylinePoints();
    location.getLocation().then((value) {
      currentLocation = value;
      iniCamera = CameraPosition(
        target:
        LatLng(value.latitude ?? 0, value.longitude ?? 0),
        zoom: 14.4746,
      );
      updateDLoc(currentLocation.latitude, currentLocation.longitude);
    });
    restLoc(widget.data["idOrder"]);
    if(mounted) {
      time = Timer(
          Duration(seconds: 5), () {
        location.onLocationChanged().listen((LocationData cLoc) {
          // cLoc contains the lat and long of the
          // current user's position in real time,
          // so we're holding on to it
          currentLocation = cLoc;
          updateDLoc(currentLocation.latitude,
              currentLocation.longitude);
          updatePinOnMap();
        });
        updateDLoc(currentLocation.latitude, currentLocation.longitude);
        LatLng startCoordinates = LatLng(currentLocation.latitude,
            currentLocation
                .longitude); //Position(latitude: 24.8615, longitude: 67.0099);

        LatLng destCoordinates = LatLng(widget.dlat,
            widget.dlong); //Position(latitude: 24.9645, longitude: 67.0671);

        updatePinOnMap();
        pol(startCoordinates, destCoordinates);
        _calculateDistance();

        setState(() {
          if (markers.isNotEmpty) markers.clear();
          if (polylines.isNotEmpty)
            polylines.clear();
          if (polylineCoordinates.isNotEmpty)
            polylineCoordinates.clear();
          _placeDistance = null;
        });
      });
    }
    addMarker();
    icon();

  }

  pol(var startCoordinates,var destCoordinates) async {

    // Destination Location Marker
    Marker destinationMarker = Marker(
      markerId: MarkerId('$destCoordinates'),
      position: LatLng(
        destCoordinates.latitude,
        destCoordinates.longitude,
      ),
      icon: d,
    );

    Marker currentMarker = Marker(
        markerId: MarkerId('current'),
        position: LatLng(
          currentLocation.latitude,
          currentLocation.longitude,
        ),
        infoWindow: InfoWindow(
          title: 'Current Location',
        ),
        icon: s);

    // Adding the markers to the list
    // markers.add(startMarker);
    markers.add(destinationMarker);
    markers.add(currentMarker);

    await _createPolylines(LatLng(currentLocation.latitude, currentLocation.longitude), destCoordinates);
  }

  void updatePinOnMap() async {
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
    );
    //final GoogleMapController controller = await mapController.future;
    _controller.future.then((value) =>
        value.animateCamera(CameraUpdate.newCameraPosition(cPosition)));

    // do this inside the setState() so Flutter gets notified
    // that a widget update is due
    setState(() {
      // updated position
      var pinPosition =
          LatLng(currentLocation.latitude, currentLocation.longitude);

      // the trick is to remove the marker (by id)
      // and add it again at the updated location
      markers.removeWhere((m) => m.markerId.value == 'current');
      markers.add(Marker(
          markerId: MarkerId('current'),
          position: pinPosition, // updated position
          icon: c));
    });
  }

  @override
  void dispose() async {
    super.dispose();
    time.cancel();
    _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
    _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
    await _stopWatchTimer.dispose();  // Need to call dispose function.
  }

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
        _stopWatchTimer.onExecute.add(StopWatchExecute.reset);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MyJobs()));

      },
      child: Scaffold(
        key: _scaffoldkey,
        body: Stack(
          children: <Widget>[
            Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
            ),
            /*
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

             */
            Column(
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
                      height: MediaQuery.of(context).size.height * 0.37,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.only(
                            //   topLeft: const Radius.circular(30.0),
                            //  topRight: const Radius.circular(30.0),
                            ),
                        /*
                        image: DecorationImage(
                          image: AssetImage("asset/images/google_map.png"),
                          fit: BoxFit.fill,
                        ),

                         */
                      ),
                      child: Stack(
                        children: [
                          GoogleMap(
                            mapType: MapType.normal,
                            myLocationEnabled: true,
                            compassEnabled: true,
                            myLocationButtonEnabled: false,
                            tiltGesturesEnabled: false,
                            initialCameraPosition: iniCamera,
                            markers: markers != null ? Set<Marker>.from(markers) : null,
                            polylines: _polyline,
                            onMapCreated: (GoogleMapController controller) {
                              _controller.complete(controller);
                            },
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Align(
                                alignment: Alignment.topCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(top:40.0),
                                  child: Text(
                                    "PICK THE ORDER",
                                    style: TextStyle(
                                      color: pcolor,
                                      fontSize: 23,
                                    ),
                                  ),
                                ),
                              ),
                              /*
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 14.0),
                                          child: Container(
                                            height: 25,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            decoration: new BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  new BorderRadius.all(
                                                Radius.circular(8.0),
                                              ),
                                            ),
                                            child: Center(
                                                child: Text(
                                              "0 min away",
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            )),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 18.0),
                                          child: Container(
                                            height: 25,
                                            width: 25,
                                            decoration: new BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  new BorderRadius.all(
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

                               */
                            ],
                          ),
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
                              "Resturant",
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
                              widget.data["RestaurantName"] ??
                                  "Ranchers Resturant",
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
                              "Restaurant Location",
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
                              widget.data["Address"] ??
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
                              widget.data["Postal"] ?? "3467895",
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                fontSize: 19,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: RaisedButton(
                                  onPressed: () {
                                    print(widget.data["idOrder"]);
                                    startJob(widget.data["idOrder"]);
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  color: pcolor,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 12),
                                  child: Text(
                                    "START JOB",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                              /*
                              Image.asset(
                                "asset/images/message.png",
                                height: 30,
                                width: 30,
                                color: scolor,
                              ),

                               */
                              Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: GestureDetector(
                                  onTap: (){
                                    _makePhoneCall('tel:$phone');
                                  },
                                  child: Icon(
                                    Icons.phone,
                                    color: scolor,
                                    size: 35,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: RaisedButton(
                              onPressed: () {
                                print(widget.data["idOrder"]);
                                cancelJob(widget.data["idOrder"]);
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              color: pcolor,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 12),
                              child: Text(
                                "  CANCEL  ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
            Navbar(
              index: 4,
            ),
          ],
        ),
      ),
    );
  }
}
