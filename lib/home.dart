import "package:flutter/material.dart";
import 'package:myapp/allCategories.dart';
import 'package:myapp/productDetailScreen.dart';
import 'package:myapp/services/apiServices.dart';
import 'package:myapp/services/authService.dart';

class Home extends StatefulWidget {
  static String id = "./home";
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blueGrey[700],
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AllCategory()));
              },
              icon: Icon(Icons.view_list)),
          TextButton.icon(
            onPressed: () {
              AuthService().signOut();
            },
            icon: Icon(Icons.logout),
            label: Text("Sign Out"),
            style: TextButton.styleFrom(foregroundColor: Colors.white),
          )
        ],
      ),
      body: FutureBuilder(
          future: ApiService().getAllPosts(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return Center(
                child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(snapshot.data[index]["title"]),
                        leading: Image.network(
                          snapshot.data[index]["image"],
                          height: 50,
                          width: 30,
                        ),
                        subtitle: Text("Price = \$" +
                            snapshot.data[index]["price"].toString()),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductDetail(
                                      snapshot.data[index]["id"])));
                        },
                      );
                    }),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
