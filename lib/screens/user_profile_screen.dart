import 'package:flutter/material.dart';

import 'package:products/model/user.dart';
import 'package:products/screens/login_screen.dart';
import 'package:products/utils/common_widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../helper/common_strings.dart';
import '../helper/helper_class.dart';
import '../providers/login_register_provider.dart';

class ProfileScreen extends StatefulWidget {
  String userId;

  ProfileScreen({required this.userId});

  @override
  State<StatefulWidget> createState() {
    return ProfileState();
  }
}

class ProfileState extends State<ProfileScreen> {
  final List<String> _dropdownValues = ["Select Category", "Male", "Female"]; //
  String? selecteditem;
  String? selectedDob;

  final TextEditingController _controllerFirstName = TextEditingController();
  final TextEditingController _controllerLastName = TextEditingController();
  final TextEditingController _controllerMobile = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerDob = TextEditingController();

  bool isMethodCalled = false;
  UserModel userModel = UserModel();

  @override
  void initState() {
    //selecteditem = _dropdownValues[0];
    print('userId->' + widget.userId);
    super.initState();
  }

  onInitializeProvider() async {
    if (!isMethodCalled) {
      Provider.of<AuthenticationProvider>(context, listen: false)
          .getUserDetails(widget.userId)
          .then((value) {
        userModel = value;
        _controllerFirstName.text = userModel.firstName!;
        _controllerLastName.text = userModel.lastName!;
        _controllerMobile.text = userModel.mobile!;
        _controllerEmail.text = userModel.email!;
        _controllerDob.text = userModel.dob!;
        selecteditem = userModel.gender;
      });
      isMethodCalled = !isMethodCalled;
    }
  }

  @override
  void didChangeDependencies() {
    onInitializeProvider();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationProvider>(
        builder: (context, authProvider, child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text('Profile'),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                authProvider.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false);
              },
              icon: Icon(Icons.logout),
            ),
          ],
        ),
        body: _widgetBody(),
      );
    });
  }

  Widget _widgetBody() {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            widgetTextField(
                _controllerFirstName, firstName, 1, TextInputType.text),
            widgetTextField(
                _controllerLastName, lastName, 1, TextInputType.text),
            widgetTextFieldPhone(
                _controllerMobile, mobile, 1, 10, TextInputType.phone),
            widgetTextField(
                _controllerEmail, email, 1, TextInputType.emailAddress),
            widgetGenderField(),
            widgetTextField(_controllerDob, dob, 1, TextInputType.text),
            SizedBox(
              height: 20.h,
            ),
            widgetButton('update', () {
              /*if (_controllerFirstName.text.isEmpty)
                Helper.show_msg('Please add first name');
              else if (_controllerLastName.text.isEmpty)
                Helper.show_msg('Please add last name');
              else if (_controllerMobile.text.isEmpty)
                Helper.show_msg('Please add email');
              else if (_controllerPassword.text.isEmpty)
                Helper.show_msg('Please add password');
              else {
                print('update' + selecteditem.toString());
              }*/
              print('update' + selecteditem.toString());
            }),
          ],
        ),
      ),
    );
  }

  widgetGenderField() {
    return Container(
      height: 60.h,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 22.h, right: 22.h, top: 10.h, bottom: 5.h),
      decoration: new BoxDecoration(
          color: Colors.transparent,
          borderRadius: new BorderRadius.circular(12.h),
          border: Border.all(color: Colors.green)),
      child: Container(
        margin: EdgeInsets.only(
          left: 10.w,
          right: 2.w,
        ),
        child: DropdownButton(
          underline: Container(),
          items: _dropdownValues
              .map((value) => DropdownMenuItem(
                    child: Text(value),
                    value: value,
                  ))
              .toList(),
          onChanged: (String? value) {
            setState(() {});
            selecteditem = value;
          },
          isExpanded: false,
          value: selecteditem,
        ),
      ),
    );
  }
}
