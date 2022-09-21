import 'dart:convert';

import "package:http/http.dart" as http;

class ApiService {
  Future getAllPosts() async {
    final allProductUrl = Uri.parse("https://fakestoreapi.com/products");
    final responce = await http.get(allProductUrl);
    print(responce.statusCode);
    print(responce.body);
    return json.decode(responce.body);
  }

  Future getSinglePost(int id) async {
    final singleProductUrl = Uri.parse("https://fakestoreapi.com/products/$id");
    final responce = await http.get(singleProductUrl);
    print(responce.statusCode);
    print(responce.body);
    return json.decode(responce.body);
  }

  Future getAllCategory() async {
    final allCatUrl = Uri.parse("https://fakestoreapi.com/products/categories");
    final responce = await http.get(allCatUrl);
    print(responce.statusCode);
    print(responce.body);
    return json.decode(responce.body);
  }

  Future getProductByCategory(String catName) async {
    final ProductCategoryUrl =
        Uri.parse("https://fakestoreapi.com/products/category/$catName");
    final responce = await http.get(ProductCategoryUrl);
    print(responce.statusCode);
    print(responce.body);
    return json.decode(responce.body);
  }
}
