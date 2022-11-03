import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sprint/widgets/signup_page/signuppageappbar.dart';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_config/flutter_config.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();

String serverurl = FlutterConfig.get('SERVER_ADDRESS');
String bucketurl = FlutterConfig.get('AWS_S3_PUT_ADDRESS');
String imageurl = FlutterConfig.get('AWS_S3_GET_ADDRESS');

class SignUpPage extends StatefulWidget {
  int userId;
  SignUpPage({super.key, required this.userId});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late TextEditingController _userNameController;
  late String _gender;
  late DateTime _selectedDate;
  late String? _image;
  late int _height;
  late int _weight;

  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController();
    _gender = "X";
    _selectedDate = DateTime(1980, 1, 1);
    _height = 165;
    _weight = 50;
    _image = null;
  }

  @override
  void dispose() {
    _userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<int>> possibleHeights = [];
    List<DropdownMenuItem<int>> possibleWeights = [];
    //the items loop function
    for (int i = 70; i < 250; i++) {
      var newItem = DropdownMenuItem(
        value: i,
        child: Center(child: Text("$i cm")),
      );
      possibleHeights.add(newItem);
    }
    for (int i = 30; i < 250; i++) {
      var newItem = DropdownMenuItem(
        value: i,
        child: Center(child: Text("$i kg")),
      );
      possibleWeights.add(newItem);
    }
    () async {
      String? token = await storage.read(key: 'accessToken');
      print(token);
    };

    return Scaffold(
      appBar: SignupPageAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.all(10)),
            Center(
              child: Stack(
                children: [
                  SizedBox(
                    child: CircleAvatar(
                      radius: 70,
                      backgroundColor: const Color(0x70707070),
                      child: CircleAvatar(
                        radius: 68,
                        backgroundImage: _image != null
                            ? FileImage(
                                File(_image!),
                              )
                            : const AssetImage(
                                "assets/images/default.jpeg",
                              ) as ImageProvider,
                        backgroundColor:
                            _image != null ? Colors.transparent : Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: FloatingActionButton(
                        backgroundColor: const Color(0xff5563de),
                        onPressed: _getImage,
                        child: const Icon(
                          Icons.add_a_photo,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.all(30)),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: 0.075 * MediaQuery.of(context).size.width),
                ),
                const Text(
                  "닉네임",
                  style: TextStyle(
                    color: Color(0xff5563de),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.all(5)),
            Neumorphic(
              style: NeumorphicStyle(
                shape: NeumorphicShape.concave,
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                depth: 8,
                lightSource: LightSource.topLeft,
                color: const Color(0xffffffff),
              ),
              child: SizedBox(
                width: 0.85 * MediaQuery.of(context).size.width,
                child: TextField(
                    maxLines: 1,
                    controller: _userNameController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "닉네임을 입력하세요",
                    ),
                    onSubmitted: (e) {}),
              ),
            ),
            const Padding(padding: EdgeInsets.all(15)),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: 0.075 * MediaQuery.of(context).size.width),
                ),
                const Text(
                  "성별",
                  style: TextStyle(
                    color: Color(0xff5563de),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.all(5)),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: 0.075 * MediaQuery.of(context).size.width),
                ),
                SizedBox(
                  width: 0.2 * MediaQuery.of(context).size.width,
                  child: Neumorphic(
                    style: NeumorphicStyle(
                      shape: NeumorphicShape.concave,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(12)),
                      depth: 8,
                      lightSource: LightSource.topLeft,
                      color: const Color(0xffffffff),
                    ),
                    child: DropdownButton<String>(
                      value: _gender,
                      icon: const Icon(Icons.arrow_drop_down),
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      isExpanded: true,
                      onChanged: (String? value) {
                        setState(() {
                          _gender = value!;
                        });
                      },
                      items: const [
                        DropdownMenuItem(
                          value: "X",
                          child: Center(child: Text("기타")),
                        ),
                        DropdownMenuItem(
                          value: "MALE",
                          child: Center(child: Text("남성")),
                        ),
                        DropdownMenuItem(
                          value: "FEMALE",
                          child: Center(child: Text("여성")),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.all(15)),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: 0.075 * MediaQuery.of(context).size.width),
                ),
                const Text(
                  "생년월일",
                  style: TextStyle(
                    color: Color(0xff5563de),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.all(5)),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: 0.075 * MediaQuery.of(context).size.width),
                ),
                SizedBox(
                  width: 0.3 * MediaQuery.of(context).size.width,
                  child: Neumorphic(
                    style: NeumorphicStyle(
                      shape: NeumorphicShape.concave,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(12)),
                      depth: 8,
                      lightSource: LightSource.topLeft,
                      color: const Color(0xffffffff),
                    ),
                    child: TextButton(
                      child: Text(
                        _selectedDate.toString().substring(0, 10),
                        style: const TextStyle(color: Color(0xff5563de)),
                      ),
                      onPressed: () {
                        Future<DateTime?> future = showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                          builder: (context, child) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                primaryColor: const Color(0xff5563de),
                                colorScheme: const ColorScheme.light(
                                    primary: Color(0xff5563de)),
                                buttonTheme: const ButtonThemeData(
                                    textTheme: ButtonTextTheme.primary),
                              ),
                              child: child!,
                            );
                          },
                        );
                        future.then((date) {
                          setState(() {
                            if (date != null) {
                              _selectedDate = date;
                            }
                          });
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.all(15)),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: 0.075 * MediaQuery.of(context).size.width),
                ),
                const Text(
                  "신체정보",
                  style: TextStyle(
                    color: Color(0xff5563de),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.all(5)),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: 0.075 * MediaQuery.of(context).size.width),
                ),
                //키
                SizedBox(
                  width: 0.35 * MediaQuery.of(context).size.width,
                  child: Neumorphic(
                    style: NeumorphicStyle(
                      shape: NeumorphicShape.concave,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(12)),
                      depth: 8,
                      lightSource: LightSource.topLeft,
                      color: const Color(0xffffffff),
                    ),
                    child: DropdownButton<int>(
                      value: _height,
                      icon: const Icon(Icons.arrow_drop_down),
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      isExpanded: true,
                      onChanged: (int? value) {
                        setState(() {
                          _height = value!;
                        });
                      },
                      items: possibleHeights,
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(
                        0.15 * MediaQuery.of(context).size.width, 0, 0, 0)),
                SizedBox(
                  width: 0.35 * MediaQuery.of(context).size.width,
                  child: Neumorphic(
                    style: NeumorphicStyle(
                      shape: NeumorphicShape.concave,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(12)),
                      depth: 8,
                      lightSource: LightSource.topLeft,
                      color: const Color(0xffffffff),
                    ),
                    child: DropdownButton<int>(
                      value: _weight,
                      icon: const Icon(Icons.arrow_drop_down),
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      isExpanded: true,
                      onChanged: (int? value) {
                        setState(() {
                          _weight = value!;
                        });
                      },
                      items: possibleWeights,
                    ),
                  ),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.all(25)),
            SizedBox(
              width: 200,
              child: NeumorphicButton(
                onPressed: () {
                  if (_userNameController.text == "") {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('닉네임을 입력해주세요'),
                      ),
                    );
                  } else {
                    if (_image == null) {
                      _signUp();
                    } else {
                      _uploadImage();
                    }
                  }
                },
                style: NeumorphicStyle(
                  shape: NeumorphicShape.concave,
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                  depth: 8,
                  lightSource: LightSource.topLeft,
                  color: const Color(0xff5563de),
                ),
                child: const Center(
                  child: Text(
                    "가입하기",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _signUp() async {
    String? token = await storage.read(key: 'accessToken');
    final response = await http.put(
        Uri.parse('$serverurl:8081/api/user-management/user/${widget.userId}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "birthday": _selectedDate.toString().substring(0, 10),
          "gender": _gender,
          "height": _height,
          "nickname": _userNameController.text,
          "picture": _image == null
              ? "https://sprint-images.s3.ap-northeast-2.amazonaws.com/default.jpeg"
              : "$imageurl/users/${_userNameController.text}.jpeg",
          "weight": _weight,
        }));
    if (response.statusCode == 200) {
      Navigator.pop(context);
    } else {
      print("Failed : ${response.statusCode}");
    }
  }

  Future<void> _getImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: image.path,
        cropStyle: CropStyle.circle,
      );
      setState(() {
        _image = croppedImage!.path;
      });
    }
  }

  Future<void> _uploadImage() async {
    final response = await http.put(
        Uri.parse("$bucketurl/users/${_userNameController.text}.jpeg"),
        headers: {
          'Content-Type': 'image/jpeg',
        },
        body: File(_image!).readAsBytesSync());
    if (response.statusCode == 200) {
      _signUp();
    } else {
      print("Failed : ${response.statusCode}");
    }
  }
}
