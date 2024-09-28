import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:sign_recognition/screens/levelsPage.dart';
import 'package:sign_recognition/screens/profilePage.dart';
import '../provider/themeProvider.dart';
import 'homePage.dart';
import 'learnPage.dart';

class currPageState extends StatefulWidget {
  const currPageState({super.key});

  @override
  State<currPageState> createState() => _currPageStateState();
}

class _currPageStateState extends State<currPageState> {
  int _selectedIndex = 0;
  PageController _pageController = PageController();

  // List of widgets for each page
  final List<Widget> _pages = [
    MyHomePage(),
    learnPage(),
    levelPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final currTheme = Provider.of<themeProvider>(context);

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _pages,
      ),
      bottomNavigationBar: Container(
        color: currTheme.isDarkMode ? Colors.black : Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: GNav(
            gap: 8,
            backgroundColor: currTheme.isDarkMode ? Colors.black : Colors.white,
            activeColor: currTheme.isDarkMode ? Colors.white : Colors.black,
            tabBackgroundColor:
            currTheme.isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
            padding: const EdgeInsets.all(16),
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
                _pageController.jumpToPage(index); // Navigate to the selected page
              });
            },
            selectedIndex: _selectedIndex,
            tabs: const [
              GButton(icon: Icons.home, text: 'Home'),
              GButton(icon: Icons.library_books_outlined, text: 'Learn'),
              GButton(icon: Icons.quiz_outlined, text: 'Quiz'),
              GButton(icon: Icons.person_2_outlined, text: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }
}
