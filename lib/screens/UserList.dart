import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_samples/models/User.dart';
import 'package:flutterfire_samples/services/database_service.dart';
import 'dart:convert';

import 'VideoApp.dart';

class UserList extends StatefulWidget {

  String loggedInUserEmail;
  UserList({Key? key, required this.loggedInUserEmail}) : super(key: key);

  @override
  _UserListState createState() => _UserListState(loggedInUserEmail:this.loggedInUserEmail);
}

class _UserListState extends State<UserList> {
  String loggedInUserEmail;
  _UserListState({Key? key, required this.loggedInUserEmail}) ;
  late Stream<QuerySnapshot> _users;

  @override
  void initState() {
    super.initState();
  }

  Widget loadUsers() {
    return StreamBuilder(
        stream: DatabaseService().getUsers(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return snapshot.hasData ? GridView.count(
            crossAxisCount: 2,
            scrollDirection: Axis.vertical,
              children: snapshot.data!.docs.map((doc) {
                print(doc);
                User user = new User(doc["name"], doc["id"], doc["live_urls"], doc["pics_urls"], doc["videos_urls"]);
                return Card(
                  color: Colors.red,
                  //child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Image.network(
                                "https://homepages.cae.wisc.edu/~ece533/images/airplane.png",
                                fit: BoxFit.fill),
                            Text(doc["name"])
                          ],
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context,
                            MaterialPageRoute(builder: (context) => VideoApp(currentUser: user, loggedInUserEmail:loggedInUserEmail)) );;
                          },
                        )
                      ],
                    ),
                  //)


                );
              }).toList()
          ) : Container();

        }
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("ACTIVE USERS"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Container(
          child: Stack(
              children: <Widget>[
              loadUsers(),
      // Container(),

      ]),
    ));

  }

  List<User> _convertToUser(String data) {
    List usersJson = json.decode(json.encode(data));
    List users = usersJson != null ? List.from(usersJson) : [];
    List<User> convertedUsers = [];
    for (int i = 0; i < users.length; i++) {
      Map doc = json.decode(users[i]);
      User user = new User(doc["name"], doc["id"], doc["live_urls"], doc["pics_urls"], doc["videos_urls"]);
      convertedUsers.add(user);
    }

    return convertedUsers;
  }
}

/*
* children: users.map( (user) {
            return ElevatedButton(
              child: Text(user),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/video');
              }
            );
          }).toList()
* */
