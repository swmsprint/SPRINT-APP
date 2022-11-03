import 'package:flutter/material.dart';
import 'package:sprint/widgets/login_page/carousel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sprint/main.dart';
import 'package:sprint/screens/signup_page.dart';
import 'package:sprint/widgets/login_page/kakao_login.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_config/flutter_config.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();

String serverurl = FlutterConfig.get('SERVER_ADDRESS');

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        const Padding(padding: EdgeInsets.all(40)),
        const Carousel(),
        Expanded(
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.07,
                child: IconButton(
                  icon: Image.asset('assets/images/login/apple.png'),
                  onPressed: () async {
                    UserCredential result = await signInWithApple();
                    final userInfo = await _signUp(
                        "APPLE", FirebaseAuth.instance.currentUser!.uid);
                    final AccessToken = userInfo['accessToken'];
                    final RefreshToken = userInfo['refreshToken'];
                    await storage.write(
                        key: 'accessToken', value: AccessToken.toString());
                    await storage.write(
                        key: 'refreshToken', value: RefreshToken.toString());
                    if (!userInfo["alreadySignIn"]) {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignUpPage(
                                  userId: userInfo["memberId"],
                                )),
                      );
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RootPage()),
                          (_) => false);
                    } else {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RootPage()),
                          (_) => false);
                    }
                  },
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.07,
                child: IconButton(
                  icon: Image.asset('assets/images/login/google.png'),
                  onPressed: () async {
                    UserCredential result = await signInWithGoogle();
                    final userInfo = await _signUp(
                        "GOOGLE", FirebaseAuth.instance.currentUser!.uid);
                    final AccessToken = userInfo['accessToken'];
                    final RefreshToken = userInfo['refreshToken'];
                    await storage.write(
                        key: 'accessToken', value: AccessToken.toString());
                    await storage.write(
                        key: 'refreshToken', value: RefreshToken.toString());
                    if (!userInfo["alreadySignIn"]) {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignUpPage(
                                  userId: userInfo["memberId"],
                                )),
                      );
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RootPage()),
                          (_) => false);
                    } else {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RootPage()),
                          (_) => false);
                    }
                  },
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.07,
                child: IconButton(
                  icon: Image.asset('assets/images/login/kakao.png'),
                  onPressed: () async {
                    final userInfo = jsonDecode(await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const KakaoLogin()),
                    ));
                    _checkAlreadyUser(userInfo, context);
                  },
                ),
              ),
            ]),
          ),
        )
      ],
    ));
  }

  _checkAlreadyUser(userInfo, context) async {
    final accessToken = userInfo['accessToken'];
    final refreshToken = userInfo['refreshToken'];
    await storage.write(key: 'accessToken', value: accessToken.toString());
    await storage.write(key: 'refreshToken', value: refreshToken.toString());
    if (!userInfo["alreadySignIn"]) {
      await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SignUpPage(
                  userId: userInfo["memberId"],
                )),
      );
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const RootPage()),
          (_) => false);
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const RootPage()),
          (_) => false);
    }
  }

  _signUp(String provider, String uid) async {
    final response = await http.get(
        Uri.parse(
            '$serverurl:8081/oauth2/firebase?provider=${provider}&uid=${uid}'),
        headers: {
          'Content-Type': 'application/json',
        });
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("Failed : ${response.statusCode}");
    }
  }

  Future<UserCredential> signInWithApple() async {
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    final result =
        await FirebaseAuth.instance.signInWithCredential(oauthCredential);

    return result;
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    final result = await FirebaseAuth.instance.signInWithCredential(credential);

    return result;
  }
}
