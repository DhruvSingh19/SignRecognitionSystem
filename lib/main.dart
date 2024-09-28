import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sign_recognition/provider/themeProvider.dart';
import 'package:sign_recognition/screens/currPageState.dart';
import 'package:sign_recognition/screens/authenticate/loginPage.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
      create: (_) => themeProvider(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    print(FirebaseAuth.instance.currentUser);
    return StreamProvider<User?>.value(
      value: FirebaseAuth.instance.authStateChanges(),
      initialData: null,
      child: Consumer<User?>(
        builder: (context, user, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            themeMode: Provider.of<themeProvider>(context).isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            theme: ThemeData(
              primaryColor: const Color(0xFF0D47A1), // Dark Blue
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF0D47A1), // Dark Blue
                secondary: Color(0xFF42A5F5), // Sky Blue
              ),
              scaffoldBackgroundColor: Colors.white, // White
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white, // Dark Blue
              ),
              textTheme: const TextTheme(
                bodyLarge: TextStyle(color: Color(0xFF212121)), // Dark Gray
                bodyMedium: TextStyle(color: Color(0xFF212121)), // Dark Gray
              ),
            ),
            darkTheme: ThemeData(
              primaryColor: const Color(0xFF6A1B9A), // Purple
              colorScheme: const ColorScheme.dark(
                primary: Color(0xFF6A1B9A), // Purple
                secondary: Color(0xFFFFD54F), // Gold
              ),
              scaffoldBackgroundColor: Colors.black, // Dark Purple
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.black, // Purple
              ),
              textTheme: const TextTheme(
                bodyLarge: TextStyle(color: Colors.white), // Light Purple
                bodyMedium: TextStyle(color: Colors.white), // Light Purple
              ),
            ),
            home: user == null ? loginPage() : const currPageState(),
          );
        },
      ),
    );
  }
}


// themeMode: Provider.of<themeProvider>(context).isDarkMode
// ? ThemeMode.dark
//     : ThemeMode.light,
// theme: ThemeData(
// primaryColor: const Color(0xFF0D47A1), // Dark Blue
// colorScheme: const ColorScheme.light(
// primary: Color(0xFF0D47A1), // Dark Blue
// secondary: Color(0xFF42A5F5), // Sky Blue
// ),
// scaffoldBackgroundColor: Colors.white, // White
// appBarTheme: const AppBarTheme(
// backgroundColor: Colors.white, // Dark Blue
// ),
// textTheme: const TextTheme(
// bodyLarge: TextStyle(color: Color(0xFF212121)), // Dark Gray
// bodyMedium: TextStyle(color: Color(0xFF212121)), // Dark Gray
// ),
// ),
// darkTheme: ThemeData(
// primaryColor: const Color(0xFF6A1B9A), // Purple
// colorScheme: const ColorScheme.dark(
// primary: Color(0xFF6A1B9A), // Purple
// secondary: Color(0xFFFFD54F), // Gold
// ),
// scaffoldBackgroundColor: Colors.black, // Dark Purple
// appBarTheme: const AppBarTheme(
// backgroundColor: Colors.black, // Purple
// ),
// textTheme: const TextTheme(
// bodyLarge: TextStyle(color: Colors.white), // Light Purple
// bodyMedium: TextStyle(color: Colors.white), // Light Purple
// ),
// ),