import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:products/model/products.dart';
import 'package:uuid/uuid.dart';

class ProductsProvider with ChangeNotifier {
  var collection = FirebaseFirestore.instance.collection('Products');

  bool _loading = false;

  bool get loading => _loading;

  bool isEnable = false;

  set loading(bool loadingState) {
    _loading = loadingState;
    notifyListeners();
  }

  List<Products>? products = [];

  List<Products>? get getProductList {
    return products;
  }

  void fetchAllProducts(String userId) {
    loading = true;
    Timer(Duration(seconds: 2), () async {
      getAllProducts(userId).then((value) {
        products!.clear();
        products!.addAll(value);
        loading = false;
        notifyListeners();
      });
    });
  }

  Future<List<Products>> getAllProducts(userId) async {
    var val = await FirebaseFirestore.instance
        .collection('Products')
        .doc('Users')
        .collection(userId)
        .get();

    var documents = val.docs;
    if (documents.length > 0) {
      try {
        print("Active ${documents.length}");
        return documents.map((document) {
          print('document->' + document.id);
          Products product = Products.fromJson(
            Map<String, dynamic>.from(document.data()),
          );
          return product;
        }).toList();
      } catch (e) {
        print("Exception $e");
        return [];
      }
    }
    return [];
  }

  Future<Products?> addProducts(String userId, String name, String description,
      String category, String price) async {
    print('add_products_repository1->');
    var uuid = Uuid();
    var productId = uuid.v1();
    final productObj = {
      "id": productId,
      "name": name,
      "description": description,
      "category": category,
      "price": price
    };
    final res = await add_product(productObj, productId, userId);
    if (res != null) {
      print('products added');
      Products products = Products();
      products.name = name;
      products.description = description;
      products.category = category;
      products.price = price;
      return products;
    }
    return null;
  }

  Future<String> add_product(
      Map<String, String> todoObj, String key, String userId) async {
    var noteId = key;
    await collection.doc('Users').collection(userId).doc(noteId).set(todoObj);
    return noteId;
  }

  Future<List<Products>?> sortbyLowtoHighPrice() async {
    products?.sort((a, b) =>
        int.parse(a.price.toString()).compareTo(int.parse(b.price.toString())));
    notifyListeners();
  }

  Future<List<Products>?> sortbyHightoLowPrice() async {
    products?.sort((a, b) =>
        int.parse(b.price.toString()).compareTo(int.parse(a.price.toString())));
    notifyListeners();
  }

  Future<List<Products>?> FilterByCategory(
      String inputext, String userId) async {
    getAllProducts(userId).then((value) {
      final _filteredList =
          value.where((product) => product.category == inputext).toList();

      products = _filteredList;

      notifyListeners();
    });
  }

}
