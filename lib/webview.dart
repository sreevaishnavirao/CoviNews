import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

// ignore: must_be_immutable
class Webview extends StatelessWidget {
  String url;
  String source;
  Webview(this.url,this.source);
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text(source),
      ),
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: url,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
    );
  }
}
