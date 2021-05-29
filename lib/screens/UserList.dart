

import 'package:flutter/material.dart';

class UserList extends StatefulWidget {

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {

  List<String> users = [
    "USER 1",
    "USER 2",
    "USER 3",
    "USER 4",

  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("ACTIVE USERS"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          children: users.map( (user) {
            return ElevatedButton(
              child: Text(user),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/video');
              }
            );
          }).toList()
        ),
      )
    );
  }
}
