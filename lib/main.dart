import 'package:flutter/material.dart';
import 'package:sprint/screens/login_page.dart';
import 'package:sprint/widgets/main/appbar.dart';
import 'package:sprint/widgets/main/bottomnavbar.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:sprint/widgets/main/drawer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required by FlutterConfig
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
      home: const LoginPage(),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(_scaffoldKey),
      body: TabPage(),
      endDrawer: const CustomDrawer(),
    );
  }
}
