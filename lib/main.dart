//import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:myapp/login.dart';
import 'package:myapp/register.dart';
import 'package:myapp/secreens/homeSecreen.dart';
import 'package:myapp/services/authService.dart';
import "home.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(brightness: Brightness.dark),
      home: StreamBuilder(
        stream: AuthService().firebaseAuth.authStateChanges(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return HomeSecreen(snapshot.data);
          } else {
            return Login();
          }
        },
      ),
      // initialRoute: Login.id,
      // routes: {
      //   Login.id: ((context) => Login()),
      //   Register.id: ((context) => Register()),
      //   Home.id: ((context) => Home())
      // },
    );
  }
}
