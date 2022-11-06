import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();

class Profile extends StatelessWidget {
  bool isDrawer = false;
  final int userId;
  Profile({Key? key, this.isDrawer = false, required this.userId})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: setUserData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData == false) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(fontSize: 15),
              ),
            );
          } else {
            return Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: 0.075 * MediaQuery.of(context).size.width),
                ),
                Column(
                  children: [
                    Container(
                      height: 110,
                      width: 110,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(snapshot.data[0]))),
                    ),
                    const Padding(padding: EdgeInsets.all(5)),
                    Text(
                      snapshot.data[1],
                      style: TextStyle(
                        fontFamily: 'YDIYGO',
                        fontSize: 20,
                        color:
                            isDrawer ? Colors.white : const Color(0xff5563de),
                      ),
                    ),
                  ],
                ),
              ],
              // ToDo: 배지 박기
            );
          }
        });
  }

  setUserData() async {
    String? profileImage = await storage.read(key: 'profile');
    String? nickName = await storage.read(key: 'nickname');
    return [profileImage, nickName];
  }
}
