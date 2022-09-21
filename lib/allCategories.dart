import "package:flutter/material.dart";
import 'package:myapp/categoryProduct.dart';
import 'package:myapp/services/apiServices.dart';

class AllCategory extends StatelessWidget {
  const AllCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Categories"),
          centerTitle: true,
        ),
        body: FutureBuilder(
            future: ApiService().getAllCategory(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CatProductScreen(snapshot.data[index])));
                        },
                        child: Card(
                          elevation: 5,
                          margin: EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Container(
                            padding: EdgeInsets.all(40),
                            child: Center(
                                child: Text(
                              snapshot.data[index].toString().toUpperCase(),
                              style: TextStyle(fontSize: 25),
                            )),
                          ),
                        ),
                      );
                    });
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}
