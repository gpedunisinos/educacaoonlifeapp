import 'package:flutter/material.dart';

class PageLayout extends StatefulWidget {
  final List<Widget> pages;
  final List<BottomNavigationBarItem> navItems;

  const PageLayout({
    super.key,
    required this.pages,
    required this.navItems,
  }) : assert(pages.length == navItems.length, 'pages and navItems must have the same length');

  @override
  State<PageLayout> createState() => _PageLayoutState();
}

class _PageLayoutState extends State<PageLayout> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: widget.pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xff004fef),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          showUnselectedLabels: true,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          items: widget.navItems,
        ),
      ),
    );
  }
}

BottomNavigationBarItem buildNavItem({
  required IconData icon,
  required String label,
}) {
  return BottomNavigationBarItem(
    icon: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Icon(icon, size: 32),
        ),
        SizedBox(
          height: 32,
          width: 70,
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              softWrap: true,
              overflow: TextOverflow.visible,
              maxLines: 2,
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
          ),
        ),
      ],
    ),
    label: '',
  );
}
