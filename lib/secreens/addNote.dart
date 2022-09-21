import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:myapp/services/firestoreService.dart';

class AddNoteSecreen extends StatefulWidget {
  User user;
  AddNoteSecreen(this.user);
  @override
  State<AddNoteSecreen> createState() => _AddNoteSecreenState();
}

class _AddNoteSecreenState extends State<AddNoteSecreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Title",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30,
              ),
              TextField(
                controller: titleController,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Description",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30,
              ),
              TextField(
                  controller: descriptionController,
                  minLines: 5,
                  maxLines: 10,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  )),
              SizedBox(
                height: 30,
              ),
              loading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (titleController == "" ||
                              descriptionController == "") {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("All field are required"),
                            ));
                          } else {
                            setState(() {
                              loading = true;
                            });
                            await FirestoreServices().insertNote(
                                titleController.text,
                                descriptionController.text,
                                widget.user.uid);
                            setState(() {
                              loading = false;
                            });
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          "Add Note",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(primary: Colors.orange),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
