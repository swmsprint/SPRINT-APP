import 'package:flutter/material.dart';

import 'package:sprint/screens/battle_page.dart';
import 'package:sprint/screens/stats_page.dart';
import 'package:sprint/screens/group_page.dart';
import 'package:sprint/screens/home_page.dart';
import 'package:sprint/screens/run_page.dart';

class TabPage extends StatefulWidget {
  const TabPage({Key? key}) : super(key: key);

  @override
  State<TabPage> createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  int _selectedIndex = 0;

  late List _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomePage(),
      const GroupPage(),
      const RunPage(),
      const BattlePage(),
      const StatsPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _pages[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          fixedColor: Colors.amber[600],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: 'Group',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.run_circle_outlined),
              label: 'Run',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: 'Battle',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.table_chart_outlined),
              label: 'Stats',
            ),
          ]),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
