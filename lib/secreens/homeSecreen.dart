import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:myapp/login.dart';
import 'package:myapp/models/note.dart';
import 'package:myapp/secreens/addNote.dart';
import 'package:myapp/secreens/editNote.dart';

import '../services/authService.dart';

class HomeSecreen extends StatelessWidget {
  User user;
  HomeSecreen(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.blueGrey[700],
          actions: [
            TextButton.icon(
              onPressed: () async {
                await AuthService().signOut();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Login()));
              },
              icon: Icon(Icons.logout),
              label: Text("Sign Out"),
              style: TextButton.styleFrom(foregroundColor: Colors.white),
            )
          ],
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("notes")
                .where("userId", isEqualTo: user.uid)
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.docs.length > 0) {
                  return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        NoteModel note =
                            NoteModel.fromJson(snapshot.data.docs[index]);
                        return Card(
                          color: Colors.teal,
                          elevation: 5,
                          margin: EdgeInsets.all(10),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            title: Text(
                              note.title,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              note.description,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => EditNoteSecreen(note)));
                            },
                          ),
                        );
                      });
                } else {
                  return Center(
                    child: Text("No notes avaliable"),
                  );
                }
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (contex) => AddNoteSecreen(user)));
          },
          backgroundColor: Colors.orangeAccent,
          child: Icon(Icons.add),
        ));
  }
}
