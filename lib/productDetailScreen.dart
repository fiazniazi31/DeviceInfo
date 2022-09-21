import 'package:flutter/material.dart';
import 'package:myapp/services/apiServices.dart';

class ProductDetail extends StatelessWidget {
  final int id;
  ProductDetail(this.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product detail"),
        backgroundColor: Colors.blueGrey[700],
      ),
      body: FutureBuilder(
        future: ApiService().getSinglePost(id),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        snapshot.data["image"],
                        height: 200,
                        width: double.infinity,
                      ),
                      Center(
                        child: Text(
                          "\$" + snapshot.data["price"].toString(),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        snapshot.data["title"],
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Chip(
                        label: Text(snapshot.data["category"].toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            )),
                        backgroundColor: Colors.blue[400],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(snapshot.data["description"])
                    ]),
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.teal[800],
        child: Icon(Icons.add_shopping_cart),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
