import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'tram_lines_screen.dart';
import 'nearest_station_screen.dart';    
import 'menu_screen.dart';

class NavigationShell extends StatefulWidget {
  @override
  _NavigationShellState createState() => _NavigationShellState();
}

class _NavigationShellState extends State<NavigationShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    TramLinesScreen(),
    NearestStationScreen(),  
    MenuScreen(),
  ];

  final List<BottomNavigationBarItem> _items = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
    BottomNavigationBarItem(icon: Icon(Icons.alt_route), label: 'خطوط الترام'),
    BottomNavigationBarItem(
        icon: Icon(Icons.location_on), label: 'أقرب محطة'),
    BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'القائمة'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: _items,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.white60,
        backgroundColor: const Color(0xFF1F1F1F),
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
