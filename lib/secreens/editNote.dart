import "package:flutter/material.dart";
import 'package:myapp/models/note.dart';
import 'package:myapp/services/firestoreService.dart';

class EditNoteSecreen extends StatefulWidget {
  NoteModel note;
  EditNoteSecreen(this.note);

  @override
  State<EditNoteSecreen> createState() => _EditNoteSecreenState();
}

class _EditNoteSecreenState extends State<EditNoteSecreen> {
  TextEditingController titleControler = TextEditingController();
  TextEditingController descriptionControler = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    titleControler.text = widget.note.title;
    descriptionControler.text = widget.note.description;

    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () async {
                await showDialog(
                    context: context,
                    builder: (BuildContext contaxt) {
                      return AlertDialog(
                        title: Text("Please Confirm"),
                        content: Text("Are you sure to delete this note"),
                        actions: [
                          TextButton(
                              onPressed: () async {
                                await FirestoreServices()
                                    .deleteNote(widget.note.id);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: Text("Yes")),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("No")),
                        ],
                      );
                    });
              },
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ))
        ],
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
                controller: titleControler,
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
                  controller: descriptionControler,
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
                          if (titleControler == "" ||
                              descriptionControler == "") {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("All fields are required !"),
                            ));
                          } else {
                            setState(() {
                              loading = true;
                            });
                            FirestoreServices().updateNote(widget.note.id,
                                titleControler.text, descriptionControler.text);
                            setState(() {
                              loading = false;
                            });
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          "Update Note",
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
