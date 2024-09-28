import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sign_recognition/provider/themeProvider.dart';
import 'package:sign_recognition/screens/authenticate/loginPage.dart';
import 'package:sign_recognition/screens/signRecognizePage.dart';
import '../services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'currPageState.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScrollController _scrollController = ScrollController();
  double _topBarOpacity = 1.0;
  PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Scroll listener to change opacity of the top bar
    _scrollController.addListener(() {
      setState(() {
        _topBarOpacity = (_scrollController.offset <= 150)
            ? 1 - (_scrollController.offset / 150)
            : 0;
        _topBarOpacity = _topBarOpacity.clamp(0.0, 1.0);
      });
    });

    // Start the timer to auto-slide the features
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0; // Reset to the first page
      }

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when widget is disposed
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    themeProvider currTheme = Provider.of<themeProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Padding(
            padding: EdgeInsets.all(8), child: Text('Silent Speak')),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: currTheme.isDarkMode ? Colors.grey : Colors.black,
            height: 1.0,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (String value) async{
              switch (value) {
                case 'Settings':
                  print('Settings selected');
                  break;
                case 'History':
                  print('History selected');
                  break;
                case 'Switch Mode':
                  currTheme.changeTheme();
                  break;
                case 'Log Out':
                  print("Attempting to log out...");
                  try {
                    await _auth.signOut();
                    // Navigator.pushAndRemoveUntil(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => loginPage()),
                    //       (Route<dynamic> route) => false, // Remove all previous routes
                    // );
                    print("Logged out successfully");
                  } catch (e) {
                    print("Error during sign out: $e");
                  }
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'Settings',
                  child: Text('Settings'),
                ),
                const PopupMenuItem<String>(
                  value: 'History',
                  child: Text('History'),
                ),
                const PopupMenuItem<String>(
                  value: 'Switch Mode',
                  child: Text('Switch Mode'),
                ),
                const PopupMenuItem<String>(
                  value: 'Log Out',
                  child: Text('Log Out'),
                ),
              ];
            },
          ),
        ],
      ),
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            title: const Text("What's New"),
            expandedHeight: 300.0,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: _topBarOpacity,
                    child: PageView(
                      controller: _pageController,
                      children: [
                        FeatureCard(featureTitle: 'Feature 1'),
                        FeatureCard(featureTitle: 'Feature 2'),
                        FeatureCard(featureTitle: 'Feature 3'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  color: currTheme.isDarkMode ? Colors.grey : Colors.black,
                  height: 1.0,
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>const signRecognizePage()));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade800,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              height: 150,
                              width: 150,
                              child: const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text("Recognize\na Sign",style: TextStyle(fontSize: 20),)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: (){

                            },
                            child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade800,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  height: 150,
                                  width: 150,
                                  child: const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text("Camera to\nSpeech",style: TextStyle(fontSize: 20),)),
                                  ),
                                ),
                          ),
                        ],
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade800,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          height: 150,
                          width: 150,
                          child: const Center(child: Text("")),
                        ),
                        const SizedBox(width: 30),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade800,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          height: 150,
                          width: 150,
                          child: const Center(child: Text("Hello")),
                        ),
                      ],
                    ),


                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final String featureTitle;
  const FeatureCard({Key? key, required this.featureTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Container(
          height: 200.0,
          child: Center(
            child: Text(
              featureTitle,
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
      ),
    );
  }
}
