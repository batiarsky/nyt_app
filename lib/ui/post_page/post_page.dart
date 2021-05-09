import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PostPage extends StatelessWidget {
  final String url;

  PostPage(this.url);

  final Completer<WebViewController> _completer =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post page'),
        centerTitle: true,
      ),
      body: WebView(
        initialUrl: url,
        onWebViewCreated: (WebViewController webViewController) =>
            _completer.complete(webViewController),
      ),
    );
  }
}
