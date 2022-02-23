import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:products/providers/products_provider.dart';
import 'package:products/utils/common_widgets.dart';
import 'package:provider/provider.dart';

import '../helper/common_strings.dart';
import '../helper/helper_class.dart';

class AddUpdateProductScreen extends StatefulWidget {
  String userId;

  AddUpdateProductScreen({required this.userId});

  @override
  State<StatefulWidget> createState() {
    return AddUpdateProductState();
  }
}

class AddUpdateProductState extends State<AddUpdateProductScreen> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();
  final TextEditingController _controllerCategory = TextEditingController();
  final TextEditingController _controllerPrice = TextEditingController();

  @override
  void initState() {
    print('init userId->' + widget.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text(add_product),
        ),
        body: Consumer<ProductsProvider>(
            builder: (context, addProductProvider, child) {
          return addProductProvider.loading
              ? Center(
                  child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
                ))
              : _widgetBody(addProductProvider);
        } //_widgetBody(),
            ));
  }

  Widget _widgetBody(ProductsProvider addProductProvider) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Container(height: 20.h),
            widgetTextField(_controllerName, name, 1, TextInputType.text),
            widgetTextField(
                _controllerDescription, description, 2, TextInputType.text),
            widgetTextField(
                _controllerCategory, category, 1, TextInputType.text),
            widgetTextField(_controllerPrice, price, 1, TextInputType.number),
            SizedBox(
              height: 10.h,
            ),
            widgetButton(add, () {
              if (_controllerName.text.isEmpty)
                Helper.show_msg('Please add product name');
              else if (_controllerDescription.text.isEmpty)
                Helper.show_msg('Please add description');
              else if (_controllerCategory.text.isEmpty)
                Helper.show_msg('Please add category');
              else if (_controllerPrice.text.isEmpty)
                Helper.show_msg('Please add price');
              else {
                addProductProvider.loading = true;
                addProductProvider
                    .addProducts(
                        widget.userId,
                        _controllerName.text,
                        _controllerDescription.text,
                        _controllerCategory.text,
                        _controllerPrice.text)
                    .then((value) {
                  addProductProvider.fetchAllProducts(widget.userId);
                  addProductProvider.loading = false;
                  Navigator.pop(context, value);
                });
              }
            }),
          ],
        ),
      ),
    );
  }
}
