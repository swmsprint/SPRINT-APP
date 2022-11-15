import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sprint/screens/signup_page.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xfff3f5fc),
          elevation: 0.0,
          leading: const SizedBox(),
          title: const Text(
            "개인정보 처리방침 및 서비스 이용약관",
            style: TextStyle(
                color: Color(0xff5563de),
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 1),
          ),
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: 0.075 * MediaQuery.of(context).size.width),
                ),
                const Text(
                  "SPRINT 개인정보 처리방침",
                  style: TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 15,
                    color: Color(0xff5563de),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(3.0),
              height: 300.0,
              width: 0.85 * MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(13)),
                border: Border.all(
                  color: const Color(0xff5563de),
                  width: 2.0,
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: FutureBuilder(
                  future: loadAsset('assets/text/policy.txt'),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data.toString());
                    } else {
                      return const Text("Loading...");
                    }
                  },
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: 0.075 * MediaQuery.of(context).size.width),
                ),
                const Text(
                  "SPRINT 서비스 이용약관",
                  style: TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 15,
                    color: Color(0xff5563de),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(3.0),
              height: 300.0,
              width: 0.85 * MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(13)),
                border: Border.all(
                  color: const Color(0xff5563de),
                  width: 2.0,
                ),
              ),
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: FutureBuilder(
                    future: loadAsset('assets/text/terms.txt'),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(snapshot.data.toString());
                      } else {
                        return const Text("Loading...");
                      }
                    },
                  )),
            ),
          ],
        ),
        bottomNavigationBar: Material(
          color: const Color(0xff5563de),
          child: InkWell(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SignUpPage(isNewUser: true)),
              );
              Navigator.pop(context);
            },
            child: const SizedBox(
              height: kToolbarHeight,
              width: double.infinity,
              child: Center(
                child: Text(
                  '개인정보 처리방침 및 서비스 이용약관에 동의합니다.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String> loadAsset(String path) async {
    return await rootBundle.loadString(path);
  }
}
