import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebWidgetPage extends StatefulWidget {
  const WebWidgetPage({Key? key, required this.url}) : super(key: key);
  final String url;
  @override
  State<WebWidgetPage> createState() => _WebWidgetPageState();
}

class _WebWidgetPageState extends State<WebWidgetPage> {
  WebViewController? _controller;
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = AndroidWebView();
    } else if (Platform.isIOS) {
      WebView.platform = CupertinoWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            if (await _controller!.canGoBack()) {
              _controller!.goBack();
            }
            return false;
          },
          child: WebView(
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller = webViewController;
            },
            gestureNavigationEnabled: true,
          ),
        );
      }),
    );
  }
}
