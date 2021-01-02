import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // InAppWebViewController webView;
  String url = "";
  double progress = 0;
  double cost = 45.5;
  final GlobalKey<ScaffoldState> globKeyPay = new GlobalKey<ScaffoldState>();
  void showSnack(text) {
    globKeyPay.currentState.showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).primaryColor,
      content: Text(text),
      duration: Duration(seconds: 5),
    ));
  }

  @override
  Widget build(BuildContext context) {
    String _loadHTML() {
      return '''
  <html>
  <body onload="document.f.submit();">
  <form id="f" name="f" method="get" action="https://paypal-testing-inprep.herokuapp.com/?price=$cost">
  <input type="hidden" name="price" value="$cost"/>
  </form>
  </body>
  </html>
  ''';
    }

    return Scaffold(
      key: globKeyPay,
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: WebView(
        onPageFinished: (page) async {
          if (page.contains('/success')) {
            print('SUCCSESS PAGE');
            // showSnack('You will be redirected to App shortly');
            var id = page.toString().substring(
                page.toString().indexOf('=P') + 1,
                page.toString().indexOf('&t'));
            print(id);
            showSnack('You will be redirected to App shortly');
            var boolTrue = false;
            await Future.delayed(Duration(seconds: 2)).then((value) {
              boolTrue = true;
              Navigator.pop(context, id);
            });
            showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: Text("Payment"),
                      content: Text(boolTrue
                          ? "Payment was successsfull"
                          : "Payment was not successsfull"),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('ok'),
                          onPressed: () async {
                            Navigator.pop(context, id);
                          },
                        ),
                      ],
                    ));
            Navigator.pop(context, id);
          }
          // }
        },
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl:
            // '',
            // 'https://google.com.pk'
            Uri.dataFromString(_loadHTML(), mimeType: 'text/html').toString(),
      ),
    );
  }
}
