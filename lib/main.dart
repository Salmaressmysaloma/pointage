import 'dart:html' as html;
import 'dart:ui_web';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart' show platformViewRegistry;
import 'package:pointage/register_page.dart';
import 'package:pointage/scanner_page.dart';
import 'package:firebase_core/firebase_core.dart';

import 'HomePage.dart';
import 'login_page.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pointage',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/scanner': (context) => const ScannerPage(), // إذا بغيتي تدخل مباشرة لها
      },
    );
  }
}



