import 'package:flutter/material.dart';
import './ui/loginscreen.dart';
import './ui/registerPage.dart';
import './ui/homePage.dart';
import './ui/profilePage.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xffa1887f)
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => loginScreen(),
        '/register': (context)=> RegisterScreen(),
        '/home': (context) => HomePage(),
        '/profile': (context) => ProfilePage()
      },
    );
  }
}