import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:products/helper/authentication_helper.dart';
import 'package:products/helper/authentication_helper.dart';
import 'package:products/helper/authentication_helper.dart';
import 'package:products/helper/common_strings.dart';
import 'package:products/providers/login_register_provider.dart';
import 'package:products/screens/home_screen.dart';
import 'package:products/screens/login_screen.dart';
import 'package:products/utils/common_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../helper/authentication_helper.dart';
import '../helper/helper_class.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegisterState();
  }
}

class RegisterState extends State<RegisterScreen> {
  final List<String> _dropdownValues = ["Select Category", "Male", "Female"]; //
  String? selecteditem;
  bool isEnable = false;
  final TextEditingController _controllerFirstName = TextEditingController();
  final TextEditingController _controllerLastName = TextEditingController();
  final TextEditingController _controllerMobile = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerDob = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  @override
  void initState() {
    selecteditem = _dropdownValues[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.green,
        title: Text(register),
      ),
      body: Consumer<AuthenticationProvider>(
          builder: (context, authProvider, child) {
        return authProvider.loading
            ? Center(
                child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
              ))
            : _widgetBody(authProvider);
      }),

      // floatingActionButton: _widgetFloatingButton(),
    );
  }

  Widget _widgetBody(AuthenticationProvider authenticationProvider) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Container(height: 20.h),
            widgetTextField(
                _controllerFirstName, firstName, 1, TextInputType.text),
            widgetTextField(
                _controllerLastName, lastName, 1, TextInputType.text),
            widgetTextFieldPhone(
                _controllerMobile, mobile, 1, 10, TextInputType.phone),
            widgetTextField(
                _controllerEmail, email, 1, TextInputType.emailAddress),
            widgetTextField(_controllerDob, dob, 1, TextInputType.text),
            widgetGenderField(),
            widgetTextField(_controllerPassword, password, 1,
                TextInputType.visiblePassword),
            SizedBox(
              height: 10.h,
            ),
            widgetButton(register, () {
              if (_controllerFirstName.text.isEmpty)
                Helper.show_msg('Please add first name');
              else if (_controllerLastName.text.isEmpty)
                Helper.show_msg('Please add last name');
              else if (_controllerMobile.text.isEmpty)
                Helper.show_msg('Please add email');
              else if (selecteditem == 'Select Category')
                Helper.show_msg('Please select gender');
              else if (_controllerDob.text.isEmpty)
                Helper.show_msg('Please add date of birth');
              else if (_controllerPassword.text.isEmpty)
                Helper.show_msg('Please add password');
              else {
                print('done validation');
                registerUser(
                    _controllerFirstName.text,
                    _controllerLastName.text,
                    _controllerMobile.text,
                    _controllerEmail.text,
                    _controllerPassword.text,
                    selecteditem.toString(),
                    _controllerDob.text,
                    authenticationProvider);
              }
            }),
            Container(
              margin: EdgeInsets.only(
                  left: 22.h, right: 22.h, top: 20.h, bottom: 5.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    already_have_an_account,
                    style: text_style_regular(14.sp, Colors.black),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                      child: Padding(
                          padding: EdgeInsets.only(left: 5.w, right: 5.w),
                          child: Text(login)))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void registerUser(
      String firstName,
      String lastName,
      String mobile,
      String email,
      String password,
      String gender,
      String dob,
      AuthenticationProvider authProvider) {
    authProvider.loading = true;
    authProvider.signUp(email: email, password: password).then((result) {
      if (result == null) {
        User user = AuthenticationHelper().user;
        authProvider
            .addUser(user.uid, firstName, lastName, mobile, email, gender, dob)
            .then((value) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen(user: user)),
              (route) => false);
          authProvider.loading = false;
        });
      } else {
        authProvider.loading = false;
        Helper.show_msg(result);
      }
    });

    /*authProvider.AuthenticationHelper()
        .signUp(email: email, password: password)
        .then((result) {
      if (result == null) {
        User user = AuthenticationHelper().user;
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(
                      user: user,
                    )));

      } else {
        Helper.show_msg(result);
      }
    });*/
  }

  Widget _widgetFloatingButton() {
    return FloatingActionButton(
        elevation: 0.0,
        child: new Icon(Icons.check),
        backgroundColor: Colors.green,
        onPressed: () {
          if (_controllerFirstName.text.isEmpty)
            Helper.show_msg('Please set firstname');
          else if (_controllerLastName.text.isEmpty)
            Helper.show_msg('Please set lastname');
          else if (_controllerMobile.text.isEmpty)
            Helper.show_msg('Please set mobile');
          else if (_controllerEmail.text.isEmpty)
            Helper.show_msg('Please set email');
          else {
            DateFormat dateFormat =
                DateFormat("dd-MM-yyyy"); //yyyy-MM-dd HH:mm:ss
            var date_time = dateFormat.format(DateTime.now());
            print('date time ' + dateFormat.format(DateTime.now()));

            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
          }
        });
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
          right: 20.w,
        ),
        child: DropdownButton(
          underline: Container(),
          items: _dropdownValues
              .map((value) => DropdownMenuItem(
                    child: Text(
                      value,
                      style: TextStyle(color: Colors.black),
                    ),
                    value: value,
                  ))
              .toList(),
          onChanged: (String? value) {
            setState(() {});
            selecteditem = value;
            print('selected item->' + value.toString());
          },
          isExpanded: false,
          value: selecteditem,
        ),
      ),
    );
  }
}
