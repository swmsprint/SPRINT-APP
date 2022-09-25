import 'package:flutter/material.dart';
import 'package:sprint/widgets/login_page/carousel.dart';
import 'package:sprint/main.dart';

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
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RootPage()),
                        (_) => false);
                  },
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.07,
                child: IconButton(
                  icon: Image.asset('assets/images/login/google.png'),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RootPage()),
                        (_) => false);
                  },
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.07,
                child: IconButton(
                  icon: Image.asset('assets/images/login/kakao.png'),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RootPage()),
                        (_) => false);
                  },
                ),
              ),
            ]),
          ),
        )
      ],
    ));
  }
}
