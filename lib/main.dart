import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_web/webview_flutter_web.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  if (kIsWeb) {
    WebViewPlatform.instance = WebWebViewPlatform();
  }
  
  runApp(MaterialApp(
    home: SplashScreen(child: WebViewApp()),
    debugShowCheckedModeBanner: false,
  ));
}

class WebViewApp extends StatefulWidget {
  const WebViewApp({Key? key}) : super(key: key);

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  late final WebViewController controller;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    controller = WebViewController();
    _initializeWebView();
  }

  void _initializeWebView() {
    if (!kIsWeb) {
      controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    }
    controller.loadRequest(Uri.parse('https://karrotafrica.com'));
  }

  Future<void> _refreshWebView() async {
    await controller.reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _refreshWebView,
          child: WebViewWidget(controller: controller),
        ),
      ),
    );
  }
}