import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sprint/widgets/group_page/grouppageappbar.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_config/flutter_config.dart';

String serverurl = FlutterConfig.get('SERVER_ADDRESS');

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  late TextEditingController _groupNameController;
  late TextEditingController _groupDescriptionController;
  late double _groupMembers;

  @override
  void initState() {
    super.initState();
    _groupNameController = TextEditingController();
    _groupDescriptionController = TextEditingController();
    _groupMembers = 5;
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
      appBar: GroupPageAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.all(10)),
            Center(
              child: Stack(
                children: [
                  const SizedBox(
                    child: CircleAvatar(
                      radius: 70,
                      backgroundColor: Color(0x70707070),
                      child: CircleAvatar(
                        radius: 68,
                        backgroundColor: Colors.white,
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
                        onPressed: () {},
                        child: const Icon(
                          Icons.add,
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
            const Padding(padding: EdgeInsets.all(20)),
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
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: 0.075 * MediaQuery.of(context).size.width),
                ),
                Text(
                  "제한 인원: ${_groupMembers.toInt()}명",
                  style: const TextStyle(
                    color: Color(0xff5563de),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.all(5)),
            SizedBox(
              width: 0.85 * MediaQuery.of(context).size.width,
              child: NeumorphicSlider(
                value: _groupMembers,
                min: 5,
                max: 50,
                height: 10,
                style: const SliderStyle(
                  accent: Color(0xff5563de),
                  variant: Color(0x405563de),
                ),
                onChanged: (double value) {
                  setState(() {
                    _groupMembers = value;
                  });
                },
              ),
            ),
            const Padding(padding: EdgeInsets.all(30)),
            SizedBox(
              width: 200,
              child: NeumorphicButton(
                onPressed: _createGroup,
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

  _createGroup() async {
    final response =
        await http.post(Uri.parse('$serverurl:8080/api/user-management/groups'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              "groupLeaderId": 1,
              "groupName": _groupNameController.text,
              "groupDescription": _groupDescriptionController.text,
              "groupPicture": null
            }));
    if (response.statusCode == 200) {
      print("groupId: ${jsonDecode(response.body)['groupId']}");
      Navigator.pop(context);
    } else {
      print("Failed : ${response.statusCode}");
    }
  }
}
