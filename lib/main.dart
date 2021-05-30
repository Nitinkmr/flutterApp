import 'package:flutter/material.dart';

import 'screens/sign_in_screen.dart';
import 'screens/UserList.dart';
import 'screens/VideoApp.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterFire Samples',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.dark,
      ),
      home: SignInScreen(),
      routes :{
       // '/users' : (context) => UserList(),
        //'/video': (context) =>VideoApp(),
      }
    );
  }
}
