import 'dart:async';
import 'dart:io';

import 'package:webview_flutter/webview_flutter.dart';

import 'package:flutter/material.dart';

class OpenNews extends StatefulWidget {
  String articleUrl;
  OpenNews(this.articleUrl, {Key? key}) : super(key: key);

  @override
  _OpenNewsState createState() => _OpenNewsState();
}

class _OpenNewsState extends State<OpenNews> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
      
  void initState() {
    super.initState();
    // Enable hybrid composition.
    print(widget.articleUrl);
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: WebView(
          initialUrl: widget.articleUrl,
          // javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          onProgress: (int progress) {
            print("WebView is loading (progress : $progress%)");
             Scaffold(
              backgroundColor: Colors.blueGrey[900],
              body: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}