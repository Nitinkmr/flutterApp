import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_samples/models/User.dart';
import 'package:flutterfire_samples/services/database_service.dart';
import 'dart:convert';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {

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
                return Card(
                  color: Colors.red,
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Image.network(
                                "https://homepages.cae.wisc.edu/~ece533/images/airplane.png",
                                fit: BoxFit.fill),
                            Text(doc["name"])
                          ],
                        )
                      ],
                    ),
                  )


                );
              }).toList()
          ) : Container();

        }
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      Map userMap = json.decode(users[i]);
      User user = new User(name: userMap["name"]);
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
