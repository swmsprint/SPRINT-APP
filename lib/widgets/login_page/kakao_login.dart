import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:html/parser.dart' show parse;

class KakaoLogin extends StatefulWidget {
  const KakaoLogin({super.key});

  @override
  State<KakaoLogin> createState() => _KakaoLoginState();
}

class _KakaoLoginState extends State<KakaoLogin> {
  late WebViewController _controller;
  late String loginCredentials;

  @override
  void initState() {
    loginCredentials = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfff3f5fc),
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context, loginCredentials);
          },
        ),
        title: const Text(
          "SPRINT",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              letterSpacing: 1),
        ),
      ),
      body: SafeArea(
        child: WebView(
          initialUrl: 'http://43.200.144.22:8081/oauth2/kakao',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller = webViewController;
          },
          javascriptChannels: <JavascriptChannel>[
            // Set Javascript Channel to WebView
            _extractDataJSChannel(context),
          ].toSet(),
          onPageFinished: (String url) async {
            // In the final result page we check the url to make sure  it is the last page.
            if (url.contains('/callback')) {
              await _controller.runJavascript(
                  "(function(){Flutter.postMessage(window.document.body.outerHTML)})();");
              Navigator.pop(context, loginCredentials);
            }
          },
          gestureNavigationEnabled: true,
        ),
      ),
    );
  }

  JavascriptChannel _extractDataJSChannel(BuildContext context) {
    return JavascriptChannel(name: 'Flutter', onMessageReceived: userInfo);
  }

  void userInfo(JavascriptMessage message) {
    var pageBody = parse(message.message);
    setState(() {
      loginCredentials = pageBody.getElementsByTagName("pre")[0].text;
    });
  }
}
