import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_config/flutter_config.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

String serverurl = FlutterConfig.get('SERVER_ADDRESS');
String bucketurl = FlutterConfig.get('AWS_S3_PUT_GROUP_ADDRESS');
String imageurl = FlutterConfig.get('AWS_S3_GET_GROUP_ADDRESS');

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
  late String? _image;

  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _groupDescriptionController =
        TextEditingController(text: widget.groupDescription);
    _image = null;
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
                        backgroundImage: _image != null
                            ? FileImage(
                                File(_image!),
                              )
                            : NetworkImage(
                                widget.groupImage,
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
                onPressed: _uploadImage,
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
                onPressed: _deleteGroup,
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

  _deleteGroup() async {
    final response = await http.delete(
      Uri.parse(
          '$serverurl:8080/api/user-management/group/${widget.groupId}?userId=1'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      print("Failed : ${response.statusCode}");
    }
  }

  _editGroup() async {
    final response = await http.put(
        Uri.parse(
            '$serverurl:8080/api/user-management/group/${widget.groupId}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "groupDescription": _groupDescriptionController.text,
          "groupPicture": "$imageurl/${widget.groupName}.jpeg",
        }));
    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      Navigator.of(context).popUntil((route) => route.isFirst);
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
    if (_image != null) {
      final response =
          await http.put(Uri.parse("$bucketurl/${widget.groupName}.jpeg"),
              headers: {
                'Content-Type': 'image/jpeg',
              },
              body: File(_image!).readAsBytesSync());
      if (response.statusCode == 200) {
        _editGroup();
      } else {
        print("Failed : ${response.statusCode}");
      }
    } else {
      _editGroup();
    }
  }
}
