import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;

class Razorpay extends StatefulWidget {
   Razorpay({super.key, required this.discountedTotal, required this.user_id});
  double discountedTotal;
  int user_id;
  
  @override
  State<Razorpay> createState() => _RazorpayState();
}

class _RazorpayState extends State<Razorpay> {
  late InAppWebViewController inAppWebViewController;
  double _progress = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          InAppWebView(
                        initialUrlRequest: URLRequest(
                          url: Uri.parse("http://10.179.2.187:8001/razorpay-payment?user_id=${widget.user_id}&amount=${widget.discountedTotal}")
                           
                        ),
                        onWebViewCreated: (InAppWebViewController controller){
                          inAppWebViewController = controller;
                        },
                        onProgressChanged: (InAppWebViewController controller, int progress){
                          setState(() {
                            _progress = progress / 100;
                          });
                        },
                        //  shouldOverrideUrlLoading: (controller, navigationAction) async {
                        //       var url = navigationAction.request.url!;
                        //       var response = await http.head(url);
                        //       if (response.statusCode == 200) {
                        //       // Close the in-app web view
                        //            controller.stopLoading();
                        //       // Optionally, you can also close the containing Scaffold
                        //            Navigator.of(context).pop();
                        //        return NavigationActionPolicy.CANCEL;
                        //       }
                        //       return NavigationActionPolicy.ALLOW;
                        //   },
                      )
        ],
      ),
    );
  }
}