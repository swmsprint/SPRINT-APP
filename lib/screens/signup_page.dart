import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sprint/services/auth_dio.dart';
import 'package:sprint/widgets/signup_page/signuppageappbar.dart';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

String serverurl = FlutterConfig.get('SERVER_ADDRESS');
String bucketurl = FlutterConfig.get('AWS_S3_PUT_ADDRESS');
String imageurl = FlutterConfig.get('AWS_S3_GET_ADDRESS');

class SignUpPage extends StatefulWidget {
  final bool isNewUser;
  const SignUpPage({Key? key, required this.isNewUser}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late TextEditingController _userNameController;
  late bool _didUserNameCheck;
  late bool _isUserNameValid;
  late String _gender;
  late DateTime _selectedDate;
  late String _image;
  late int _height;
  late int _weight;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController();
    _didUserNameCheck = false;
    _isUserNameValid = false;
    _gender = "X";
    _selectedDate = DateTime(2000, 1, 1);
    _height = 165;
    _weight = 50;
    _image =
        "https://sprint-images.s3.ap-northeast-2.amazonaws.com/users/default.jpeg";
    if (!widget.isNewUser) {
      _getUserData();
    }
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

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
                            backgroundImage: _image[0] == 'h'
                                ? NetworkImage(
                                    _image,
                                  )
                                : FileImage(
                                    File(_image),
                                  ) as ImageProvider,
                            backgroundColor: Colors.transparent),
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
                    "?????????",
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Neumorphic(
                    style: NeumorphicStyle(
                      shape: NeumorphicShape.concave,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(12)),
                      depth: 8,
                      lightSource: LightSource.topLeft,
                      color: const Color(0xffffffff),
                    ),
                    child: SizedBox(
                      width: 0.6 * MediaQuery.of(context).size.width,
                      child: TextField(
                        maxLines: 1,
                        controller: _userNameController,
                        onChanged: (value) => {
                          setState(() {
                            _didUserNameCheck = false;
                            _isUserNameValid = false;
                          })
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "???????????? ???????????????",
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 0.2 * MediaQuery.of(context).size.width,
                    height: 45,
                    child: NeumorphicButton(
                      onPressed: () {
                        if (_userNameController.text == "") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('???????????? ??????????????????'),
                            ),
                          );
                        } else {
                          _checkUserName();
                        }
                      },
                      style: NeumorphicStyle(
                        shape: NeumorphicShape.concave,
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(12)),
                        depth: 8,
                        lightSource: LightSource.topLeft,
                        color: const Color(0xff5563de),
                      ),
                      child: const Center(
                        child: Text(
                          "????????????",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10.5,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.all(10)),
              (_didUserNameCheck == false)
                  ? const Text("????????? ??????????????? ??????????????????",
                      style: TextStyle(color: Colors.red))
                  : _isUserNameValid == false
                      ? const Text("?????? ???????????? ??????????????????!",
                          style: TextStyle(color: Colors.red))
                      : const Text("?????? ????????? ??????????????????!",
                          style: TextStyle(color: Colors.green)),
              const Padding(padding: EdgeInsets.all(5)),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: 0.075 * MediaQuery.of(context).size.width),
                  ),
                  const Text(
                    "??????",
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
                            child: Center(child: Text("??????")),
                          ),
                          DropdownMenuItem(
                            value: "MALE",
                            child: Center(child: Text("??????")),
                          ),
                          DropdownMenuItem(
                            value: "FEMALE",
                            child: Center(child: Text("??????")),
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
                    "????????????",
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
                    "????????????",
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
                  //???
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
                          content: Text('???????????? ??????????????????'),
                        ),
                      );
                    } else if (_didUserNameCheck == false) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('????????? ??????????????? ??????????????????.'),
                      ));
                    } else if (_isUserNameValid == false) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('?????? ???????????? ??????????????????.'),
                      ));
                    } else {
                      if (_image[0] == 'h') {
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
                  child: Center(
                    child: Text(
                      widget.isNewUser ? "????????????" : "????????????",
                      style: const TextStyle(
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
      ),
    );
  }

  _checkUserName() async {
    var dio = await authDio(context);
    var response = await dio.get(
        '$serverurl/api/user-management/user/validation-duplicate-name',
        queryParameters: {
          'target': _userNameController.text,
        });
    final isNotDuplicate = response.data['result'];
    setState(() {
      _didUserNameCheck = true;
    });
    if (isNotDuplicate) {
      setState(() {
        _isUserNameValid = true;
      });
    } else {
      _isUserNameValid = false;
    }
  }

  _getUserData() async {
    var dio = await authDio(context);
    final userID = await storage.read(key: 'userID');
    var response = await dio.get('$serverurl/api/user-management/user/$userID');
    final data = response.data;
    setState(() {
      _userNameController.text = data['nickname'];
      _didUserNameCheck = true;
      _isUserNameValid = true;
      _selectedDate = DateTime.parse(data['birthday']);
      _height = data['height'].round();
      _weight = data['weight'].round();
      _image = data['picture'];
      _gender = data['gender'];
    });
  }

  _signUp() async {
    var dio = await authDio(context);
    final userID = await storage.read(key: 'userID');

    var response =
        await dio.put('$serverurl/api/user-management/user/$userID', data: {
      "birthday": _selectedDate.toString().substring(0, 10),
      "gender": _gender,
      "height": _height,
      "nickname": _userNameController.text,
      "picture": _image ==
              "https://sprint-images.s3.ap-northeast-2.amazonaws.com/users/default.jpeg"
          ? "https://sprint-images.s3.ap-northeast-2.amazonaws.com/users/default.jpeg"
          : "$imageurl/users/${_userNameController.text}.jpeg",
      "weight": _weight,
    });
    if (response.statusCode == 200) {
      await storage.write(key: 'nickname', value: _userNameController.text);
      await storage.write(
        key: 'profile',
        value: _image ==
                "https://sprint-images.s3.ap-northeast-2.amazonaws.com/users/default.jpeg"
            ? "https://sprint-images.s3.ap-northeast-2.amazonaws.com/users/default.jpeg"
            : "$imageurl/users/${_userNameController.text}.jpeg",
      );
      await storage.write(
          key: 'birthday', value: _selectedDate.toString().substring(0, 10));
      await storage.write(key: 'height', value: '${_height.round()}');
      await storage.write(key: 'weight', value: '${_weight.round()}');
      await storage.write(key: 'gender', value: _gender);
      if (!mounted) return;
      Navigator.pop(context);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('????????? ?????????????????? (${response.statusCode}). ?????? ????????? ?????????.'),
      ));
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
        body: File(_image).readAsBytesSync());
    if (response.statusCode == 200) {
      _signUp();
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('????????? ?????????????????? (${response.statusCode}). ?????? ????????? ?????????.'),
      ));
    }
  }
}
