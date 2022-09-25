import 'package:flutter/material.dart';
import 'package:sprint/screens/create_group_page.dart';
import 'package:sprint/screens/search_group_page.dart';
import 'package:sprint/widgets/login_page/carousel.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({super.key});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.all(3)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "가입한 그룹",
                  style: TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 15,
                    color: Color(0xff5563de),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SearchGroupPage(),
                                fullscreenDialog: true),
                          );
                        },
                        icon: const Icon(
                          Icons.search,
                          size: 20,
                          color: Color(0xff5563de),
                        )),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CreateGroupPage(),
                              fullscreenDialog: true),
                        );
                      },
                      icon: const Icon(
                        Icons.add,
                        size: 20,
                        color: Color(0xff5563de),
                      ),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
