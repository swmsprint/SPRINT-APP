import 'package:flutter/material.dart';
import 'package:sprint/screens/run_page.dart';
import 'package:sprint/screens/battle_page.dart';
import 'package:sprint/screens/stats_page.dart';
import 'package:sprint/screens/group_page.dart';
import 'package:sprint/screens/home_page.dart';

class TabPage extends StatefulWidget {
  final int userId;
  const TabPage({Key? key, required this.userId}) : super(key: key);

  final Color selectedColor = const Color(0xff5563de);
  @override
  State<TabPage> createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  int currentIndex = 0;
  late List _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomePage(),
      const GroupPage(),
      const BattlePage(),
      StatsPage(
        userId: widget.userId,
      ),
    ];
  }

  setBottomBarIndex(index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white.withAlpha(55),
      body: Stack(
        children: [
          Center(child: _pages[currentIndex]),
          Positioned(
            bottom: 0,
            left: 0,
            child: SizedBox(
              width: size.width,
              height: 80,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  CustomPaint(
                    size: Size(size.width, 80),
                    painter: BNBCustomPainter(),
                  ),
                  Center(
                    heightFactor: 0.1,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xff7a85e9), Color(0xff5563de)],
                          stops: [0.0, 1.0],
                        ),
                        borderRadius:
                            BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xff828cdf),
                            offset: Offset(3, 8),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          backgroundColor: Colors.transparent,
                          disabledForegroundColor: Colors.transparent,
                          disabledBackgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: EdgeInsets.zero,
                          fixedSize: const Size(70, 70),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RunPage(),
                                fullscreenDialog: true),
                          );
                        },
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: size.width,
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.home,
                            size: 30,
                            color: currentIndex == 0
                                ? widget.selectedColor
                                : Colors.grey.shade400,
                          ),
                          onPressed: () {
                            setBottomBarIndex(0);
                          },
                          splashColor: Colors.white,
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.groups,
                              size: 30,
                              color: currentIndex == 1
                                  ? widget.selectedColor
                                  : Colors.grey.shade400,
                            ),
                            onPressed: () {
                              setBottomBarIndex(1);
                            }),
                        Container(
                          width: size.width * 0.20,
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.star,
                              size: 30,
                              color: currentIndex == 2
                                  ? widget.selectedColor
                                  : Colors.grey.shade400,
                            ),
                            onPressed: () {
                              setBottomBarIndex(2);
                            }),
                        IconButton(
                            icon: Icon(
                              Icons.table_chart_outlined,
                              size: 30,
                              color: currentIndex == 3
                                  ? widget.selectedColor
                                  : Colors.grey.shade400,
                            ),
                            onPressed: () {
                              setBottomBarIndex(3);
                            }),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 0); // Start
    path.lineTo(size.width * 0.69, 0);
    path.cubicTo(size.width * 0.65, 0, size.width * 0.62, size.height * 0.11,
        size.width * 0.6, size.height * 0.28);
    path.cubicTo(size.width * 0.58, size.height * 0.46, size.width * 0.54,
        size.height * 0.57, size.width / 2, size.height * 0.57);
    path.cubicTo(size.width * 0.46, size.height * 0.57, size.width * 0.42,
        size.height * 0.46, size.width * 0.4, size.height * 0.28);
    path.cubicTo(size.width * 0.38, size.height * 0.11, size.width * 0.35, 0,
        size.width * 0.31, 0);
    path.cubicTo(size.width * 0.31, 0, 0, 0, 0, 0);
    path.cubicTo(0, 0, 0, size.height, 0, size.height);
    path.cubicTo(
        0, size.height, size.width, size.height, size.width, size.height);
    path.cubicTo(size.width, size.height, size.width, 0, size.width, 0);
    path.cubicTo(size.width, 0, size.width * 0.69, 0, size.width * 0.69, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
