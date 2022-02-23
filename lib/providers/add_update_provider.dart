import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:products/model/products.dart';
import 'package:uuid/uuid.dart';

class AddProductProvider with ChangeNotifier {
  var userId = 'f48fa410-9458-11ec-8979-e3723dc483b0';
  var collection = FirebaseFirestore.instance.collection('Products');

  bool _loading = false;

  bool get loading => _loading;

  bool isEnable = false;

  set loading(bool loadingState) {
    _loading = loadingState;
    print('loading ' + _loading.toString());
    notifyListeners();
  }

  Future<Products?> addProducts(
      String name, String description, String category, String price) async {
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
    final res = await add_product(productObj, productId);
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

  Future<String> add_product(Map<String, String> todoObj, String key) async {
    var noteId = key;
    await collection.doc('Users').collection(userId).doc(noteId).set(todoObj);
    return noteId;
  }
}
