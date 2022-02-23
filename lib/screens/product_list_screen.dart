import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:products/helper/common_strings.dart';
import 'package:products/model/products.dart';
import 'package:products/providers/products_provider.dart';
import 'package:products/screens/add_edit_product_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductsScreen extends StatefulWidget {
  User user;

  ProductsScreen({required this.user});

  @override
  State<StatefulWidget> createState() {
    return ProductsState();
  }
}

class ProductsState extends State<ProductsScreen> {
  bool isMethodCalled = false;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      Timer(Duration(seconds: 0), () => onInitializeProvider());
    });

    super.initState();
  }

  /*Future<Timer> callProductListMethod() async {
    return new Timer(Duration(seconds: 0), onInitializeProvider);
  }*/

  onInitializeProvider() async {
    if (!isMethodCalled) {
      Provider.of<ProductsProvider>(context, listen: false)
          .fetchAllProducts(widget.user.uid);
      isMethodCalled = !isMethodCalled;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          automaticallyImplyLeading: false,
          title: Text(
            products,
          ),
          actions: <Widget>[
            PopupMenuButton(
              icon: Icon(Icons.filter_alt_outlined),
              itemBuilder: (context) => [
                PopupMenuItem<int>(
                  value: 0,
                  child: Text(
                    "Select Category",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: Column(
                    children: [
                      Text(
                        "Phone",
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<int>(
                  value: 2,
                  child: Text(
                    "System",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                PopupMenuItem<int>(
                  value: 3,
                  child: Text(
                    "Clear All",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
              onSelected: (item) => {
                if (item == 1)
                  {
                    Provider.of<ProductsProvider>(context, listen: false)
                        .FilterByCategory("Phone", widget.user.uid)
                  }
                else if (item == 2)
                  {
                    Provider.of<ProductsProvider>(context, listen: false)
                        .FilterByCategory("System", widget.user.uid)
                    // Provider.of<ProductsProvider>(context, listen: false).FilterByCategory("System")
                  }
                else if (item == 3)
                  {
                    Provider.of<ProductsProvider>(context, listen: false)
                        .fetchAllProducts(widget.user.uid)
                  }
              },
            ),
            PopupMenuButton(
              icon: Icon(Icons.sort),
              itemBuilder: (context) => [
                PopupMenuItem<int>(
                  value: 0,
                  child: Text(
                    "Select Sorting",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          "Price High to Low",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                PopupMenuItem<int>(
                  value: 2,
                  child: Text(
                    "Price Low to High",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                PopupMenuItem<int>(
                  value: 3,
                  child: Text(
                    "Clear All",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
              onSelected: (item) => {
                if (item == 1)
                  {
                    Provider.of<ProductsProvider>(context, listen: false)
                        .sortbyHightoLowPrice()
                  }
                else if (item == 2)
                  {
                    Provider.of<ProductsProvider>(context, listen: false)
                        .sortbyLowtoHighPrice()
                  }
                else if (item == 3)
                  {
                    Provider.of<ProductsProvider>(context, listen: false)
                        .fetchAllProducts(widget.user.uid)
                  }
              },
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddUpdateProductScreen(
                              userId: widget.user.uid,
                            )));
              },
              icon: Icon(Icons.add),
            ),
          ],
        ),
        body: Consumer<ProductsProvider>(
          builder: (context, productsProvider, child) {
            return productsProvider.loading
                ? Center(
                    child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
                  ))
                : productsProvider.getProductList!.length > 0
                    ? SingleChildScrollView(
                        child: Container(
                            margin: EdgeInsets.only(top: 20),
                            child: StaggeredGrid.count(
                              crossAxisCount: 1,
                              children: productsProvider.getProductList!
                                  .map((e) => _widget_staggered_grid(
                                      e, context, productsProvider))
                                  .toList(),
                            )),
                      )
                    : Center(
                        child: Text('No products found.'),
                      );
          },
        ));
  }

  Widget _widget_staggered_grid(
      Products documentSnapshot, context, ProductsProvider noteListProvider) {
    return Card(
        margin: EdgeInsets.all(10),
        child: Padding(
          padding:
              EdgeInsets.only(left: 10.w, top: 10.h, bottom: 10.h, right: 10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                documentSnapshot.name.toString(),
                style: TextStyle(fontSize: 18),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.h),
                child: Text(
                  documentSnapshot.description.toString(),
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.h),
                child: Text(
                  documentSnapshot.category.toString(),
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
                child: Text(
                  'Rs ' + documentSnapshot.price.toString(),
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        ));
  }

  /*
  InkWell(
        onTap: () {},
        onLongPress: () {},
        child: ListTile(
          title: Text(
            documentSnapshot.name.toString(),
            style: TextStyle(fontSize: 18),
          ),
          subtitle: Text(
            documentSnapshot.description.toString(),
            //documentSnapshot.content.toString(),
            style: TextStyle(fontSize: 15),
          ),
        ),
      ),
   */

  List<Widget> buildGrid(List<DocumentSnapshot> documents) {
    List<Widget> _gridItems = [];
    for (DocumentSnapshot document in documents) {
      _gridItems.add(_widgetProductList(document));
    }
    return _gridItems;
  }

  Widget _widgetProductList(DocumentSnapshot documentSnapshot) {
    return Card(
      margin: EdgeInsets.all(10),
      child: InkWell(
        onTap: () {},
        onLongPress: () {},
        child: Container(
          child: Padding(
            padding:
                EdgeInsets.only(left: 10.w, right: 10.w, top: 5.h, bottom: 5.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        documentSnapshot['name'],
                        style: TextStyle(fontSize: 18.sp),
                      ),
                    ),
                    Text(
                      documentSnapshot['content'],
                      style: TextStyle(fontSize: 10.sp),
                    ),
                  ],
                ),
                SizedBox(
                  height: 6.h,
                ),
                Text(
                  documentSnapshot['price'].toString(),
                  style: TextStyle(fontSize: 15.sp),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
