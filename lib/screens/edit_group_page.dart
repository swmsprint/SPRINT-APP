import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sprint/services/auth_dio.dart';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();

String serverurl = FlutterConfig.get('SERVER_ADDRESS');
String bucketurl = FlutterConfig.get('AWS_S3_PUT_ADDRESS');
String imageurl = FlutterConfig.get('AWS_S3_GET_ADDRESS');

class EditGroupPage extends StatefulWidget {
  final int groupId;
  final String groupName;
  final String groupDescription;
  final String groupImage;

  const EditGroupPage(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.groupDescription,
      required this.groupImage})
      : super(key: key);

  @override
  State<EditGroupPage> createState() => _EditGroupPageState();
}

class _EditGroupPageState extends State<EditGroupPage> {
  late TextEditingController _groupDescriptionController;
  late String _image;

  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _groupDescriptionController =
        TextEditingController(text: widget.groupDescription);
    _image = widget.groupImage;
  }

  @override
  void dispose() {
    _groupDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfff3f5fc),
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: Color(0xff5563de),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
        title: const Text(
          "그룹 수정하기",
          style: TextStyle(
              color: Color(0xff5563de),
              fontWeight: FontWeight.bold,
              fontSize: 16,
              letterSpacing: 1),
        ),
      ),
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
            const Padding(padding: EdgeInsets.all(20)),
            SizedBox(
              width: 200,
              child: NeumorphicButton(
                onPressed: () {
                  if (_image[0] == 'h') {
                    _editGroup();
                  } else {
                    _uploadImage();
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
                    "그룹 정보 수정",
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
            const Padding(padding: EdgeInsets.all(20)),
            SizedBox(
              width: 200,
              child: NeumorphicButton(
                onPressed: _showDialog,
                style: NeumorphicStyle(
                  shape: NeumorphicShape.concave,
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                  depth: 8,
                  lightSource: LightSource.topLeft,
                  color: const Color.fromARGB(255, 255, 0, 0),
                ),
                child: const Center(
                  child: Text(
                    "그룹 삭제",
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

  _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("정말로 그룹을 삭제하시겠습니까?"),
          content: const Text("삭제한 그룹은 복구할 수 없습니다!"),
          actions: <Widget>[
            TextButton(
              child: const Text("취소", style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("삭제", style: TextStyle(color: Colors.red)),
              onPressed: () {
                _deleteGroup();
              },
            ),
          ],
        );
      },
    );
  }

  _deleteGroup() async {
    var dio = await authDio(context);
    final userID = await storage.read(key: 'userID');
    final response = await dio.delete(
        '$serverurl:8081/api/user-management/group/${widget.groupId}?userId=$userID');
    if (response.statusCode == 200) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  _editGroup() async {
    var dio = await authDio(context);
    final userID = await storage.read(key: 'userID');
    final response = await dio.put(
        '$serverurl:8081/api/user-management/group/${widget.groupId}',
        data: {
          "groupDescription": _groupDescriptionController.text,
          "groupPicture": _image ==
                  "https://sprint-images.s3.ap-northeast-2.amazonaws.com/groups/default.jpeg"
              ? "https://sprint-images.s3.ap-northeast-2.amazonaws.com/groups/default.jpeg"
              : "$imageurl/groups/${widget.groupName}.jpeg",
        });
    if (response.statusCode == 200) {
      Navigator.of(context).popUntil((route) => route.isFirst);
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
    final response =
        await http.put(Uri.parse("$bucketurl/groups/${widget.groupName}.jpeg"),
            headers: {
              'Content-Type': 'image/jpeg',
            },
            body: File(_image).readAsBytesSync());
    if (response.statusCode == 200) {
      _editGroup();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('에러가 발생했습니다 (${response.statusCode}). 다시 시도해 주세요.'),
      ));
    }
  }
}
