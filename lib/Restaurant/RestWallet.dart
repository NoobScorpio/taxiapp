import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_app/Constants/APIConstants.dart';

import 'package:taxi_app/Constants/colors.dart';
import 'package:taxi_app/Restaurant/rest-navbar.dart';

class RestWallet extends StatefulWidget {
  @override
  _RestWalletState createState() => _RestWalletState();
}

class _RestWalletState extends State<RestWallet> {
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

  //              */
  //             /*
  //             actions: <Widget>[
  //               FlatButton(
  //                   onPressed: () => controller.dismiss('Yes, I do!'),
  //                   child: Text('YES')),
  //               FlatButton(
  //                   onPressed: () => controller.dismiss('No, I do not!'),
  //                   child: Text('NO')),
  //             ],

  //              */
             ),
           ),
         );
       },
     );
   }

   void checkRBalance() async {

     SharedPreferences prefs = await SharedPreferences.getInstance();
     int idRest = prefs.getInt("idRest");

     final http.Response response = await http
         .post(
       baseURL + checkRBalanceURL,
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
         setState(() {});
       } else {
         _showBottomFlash("Please activate the account by topup some amount");
       }
     } else {
       _showBottomFlash("Server Error");
       throw Exception('Failed to check the validity');
     }
   }

   @override
   void initState() {
     super.initState();
     current = 2;
     setState(() {});
     checkRBalance();
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              color: scolor,
            ),
          ),
          Column(
            children: [
              Container(
                color: pcolor,
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(28.0),
                child: Text(
                  "Wallet",
                  style: TextStyle(color: pcolor, fontSize: 25),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: pcolor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Personal Balance",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                           jsonData == null
                               ? ""
                               : "\u{00a3} " +
                                   jsonData["data"]["Balance"].toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 110,
              ),
              Lottie.asset("asset/json/walletanim.json",
                  width: 120, height: 120),
              SizedBox(
                height: 25,
              ),
              MaterialButton(
                onPressed: () {},
                // color: jsonData == null
                //     ? Colors.grey
                //     : jsonData["data"]["Membership"] == "Valid"
                //         ? Colors.grey
                //         : pcolor,
                color: pcolor,
                padding: EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9.0),
                ),
                child: Text(
                  "Topup",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
               Text(
                 "Keep your account balance minimum at \u{00a3}50 to avoid account freeze",
                 style: TextStyle(
                   color: pcolor,
                   fontSize: 15,
                 ),
               ),
            ],
          ),
          RestNavbar(
            index: 2,
          ),
        ],
      ),
    );
  }
}
