import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:products/model/products.dart';

class ProductsProvider with ChangeNotifier {
  var userId = 'f48fa410-9458-11ec-8979-e3723dc483b0';
  var collection = FirebaseFirestore.instance.collection('Products');
  late CollectionReference _products = FirebaseFirestore.instance
      .collection('Products')
      .doc('Users')
      .collection(userId);

  bool _loading = false;

  bool get loading => _loading;

  bool isEnable = false;

  set loading(bool loadingState) {
    _loading = loadingState;
    print('loading ' + _loading.toString());
    notifyListeners();
  }

  List<Products>? products = [];

  List<Products>? get getProductList {
    return products;
  }

  void fetchAllProducts() {
    loading = true;
    Timer(Duration(seconds: 2), () async {
      getAllProducts().then((value) {
        products!.clear();
        products!.addAll(value);
        loading = false;
        notifyListeners();
      });
    });
  }

  Future<List<Products>> getAllProducts() async {
    print('get products');

    //var val = await FirebaseFirestore.instance.collection('Products').get();
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
}
