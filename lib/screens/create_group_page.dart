import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sprint/widgets/group_page/grouppageappbar.dart';
import 'package:sprint/services/auth_dio.dart';
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

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  late TextEditingController _groupNameController;
  late bool _didUserNameCheck;
  late bool _isUserNameValid;
  late TextEditingController _groupDescriptionController;
  late String _image;

  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _groupNameController = TextEditingController();
    _didUserNameCheck = false;
    _isUserNameValid = false;
    _groupDescriptionController = TextEditingController();
    _image =
        "https://sprint-images.s3.ap-northeast-2.amazonaws.com/groups/default.jpeg";
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    _groupDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GroupPageAppBar(),
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
                  "그룹명",
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
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                    depth: 8,
                    lightSource: LightSource.topLeft,
                    color: const Color(0xffffffff),
                  ),
                  child: SizedBox(
                    width: 0.6 * MediaQuery.of(context).size.width,
                    child: TextField(
                        maxLines: 1,
                        controller: _groupNameController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "그룹명을 입력하세요",
                        ),
                        onSubmitted: (e) {}),
                  ),
                ),
                SizedBox(
                  width: 0.2 * MediaQuery.of(context).size.width,
                  height: 45,
                  child: NeumorphicButton(
                    onPressed: () {
                      if (_groupNameController.text == "") {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('닉네임을 입력해주세요'),
                          ),
                        );
                      } else {
                        _checkGroupName();
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
                        "중복검사",
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
                ? const Text("그룹명 중복검사를 진행해주세요",
                    style: TextStyle(color: Colors.red))
                : _isUserNameValid == false
                    ? const Text("이미 사용중인 그룹명입니다!",
                        style: TextStyle(color: Colors.red))
                    : const Text("사용 가능한 그룹명입니다!",
                        style: TextStyle(color: Colors.green)),
            const Padding(padding: EdgeInsets.all(5)),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: 0.075 * MediaQuery.of(context).size.width),
                ),
                const Text(
                  "그룹 소개",
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
                    maxLines: 5,
                    controller: _groupDescriptionController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "그룹 소개를 입력하세요",
                    ),
                    onSubmitted: (e) {}),
              ),
            ),
            const Padding(padding: EdgeInsets.all(30)),
            SizedBox(
              width: 200,
              child: NeumorphicButton(
                onPressed: () {
                  if (_groupNameController.text == "") {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('그룹명을 입력해주세요'),
                      ),
                    );
                  } else if (_didUserNameCheck == false) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('그룹명 중복검사를 진행해주세요.'),
                    ));
                  } else if (_isUserNameValid == false) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('다른 그룹명을 사용해주세요.'),
                    ));
                  } else {
                    if (_image[0] == 'h') {
                      _createGroup();
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
                    "그룹 생성",
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

  _checkGroupName() async {
    var dio = await authDio(context);
    var response = await dio.get(
        '$serverurl/api/user-management/group/validation-duplicate-name',
        queryParameters: {
          'target': _groupNameController.text,
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

  _createGroup() async {
    var dio = await authDio(context);
    final userID = await storage.read(key: 'userID');
    final response =
        await dio.post('$serverurl/api/user-management/group', data: {
      "groupLeaderId": userID,
      "groupName": _groupNameController.text,
      "groupDescription": _groupDescriptionController.text,
      "groupPicture": _image ==
              "https://sprint-images.s3.ap-northeast-2.amazonaws.com/groups/default.jpeg"
          ? "https://sprint-images.s3.ap-northeast-2.amazonaws.com/groups/default.jpeg"
          : "$imageurl/groups/${_groupNameController.text}.jpeg",
    });
    if (response.statusCode == 200) {
      if (!mounted) return;
      Navigator.pop(context);
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
        Uri.parse("$bucketurl/groups/${_groupNameController.text}.jpeg"),
        headers: {
          'Content-Type': 'image/jpeg',
        },
        body: File(_image).readAsBytesSync());

    if (response.statusCode == 200) {
      _createGroup();
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('에러가 발생했습니다 (${response.statusCode}). 다시 시도해 주세요.'),
      ));
    }
  }
}
