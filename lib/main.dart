import 'package:flutter/material.dart';
import 'package:sprint/screens/login_page.dart';
import 'package:sprint/widgets/main/appbar.dart';
import 'package:sprint/widgets/main/bottomnavbar.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:sprint/widgets/main/drawer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sprint/services/auth_dio.dart';

final storage = new FlutterSecureStorage();
String serverurl = FlutterConfig.get('SERVER_ADDRESS');
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required by FlutterConfig
  await Firebase.initializeApp();
  await FlutterConfig.loadEnvVariables();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sprint',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: const Color(0xfff3f5fc),
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<List>(
        future: isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data![0]) {
              return RootPage(userId: int.parse(snapshot.data![1]));
            } else {
              return const LoginPage();
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<List> isLoggedIn() async {
    String? accessToken = await storage.read(key: 'accessToken');
    String? refreshToken = await storage.read(key: 'refreshToken');
    String? userID = await storage.read(key: 'userID');
    if (userID != null && accessToken != null && refreshToken != null) {
      return [true, userID];
    } else {
      return [false, 0];
    }
  }
}

class RootPage extends StatefulWidget {
  int userId;
  RootPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _getUserData();
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(_scaffoldKey),
      body: TabPage(userId: widget.userId),
      endDrawer: CustomDrawer(userId: widget.userId),
    );
  }

  _getUserData() async {
    var dio = await authDio(context);
    final userID = await storage.read(key: 'userID');
    var response =
        await dio.get('$serverurl:8081/api/user-management/user/$userID');
    final data = response.data;
    await storage.write(key: 'nickname', value: data['nickname']);
    await storage.write(key: 'profile', value: data['picture']);
    await storage.write(
        key: 'birthday', value: DateTime.parse(data['birthday']).toString());
    await storage.write(key: 'height', value: '${data['height'].round()}');
    await storage.write(key: 'weight', value: '${data['weight'].round()}');
    await storage.write(key: 'gender', value: data['gender']);
  }
}
