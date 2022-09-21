import 'package:flutter/material.dart';
import 'package:myapp/productDetailScreen.dart';
import 'package:myapp/services/apiServices.dart';

class CatProductScreen extends StatelessWidget {
  final String catName;
  CatProductScreen(this.catName);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(catName.toUpperCase()),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: ApiService().getProductByCategory(catName),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
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
                                builder: (context) =>
                                    ProductDetail(snapshot.data[index]["id"])));
                      },
                    );
                  });
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
