import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:products/helper/common_strings.dart';
import 'package:products/screens/login_screen.dart';
import 'package:products/utils/common_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../helper/helper_class.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegisterState();
  }
}

class RegisterState extends State<RegisterScreen> {
  bool isEnable = false;
  final TextEditingController _controllerFirstName = TextEditingController();
  final TextEditingController _controllerLastName = TextEditingController();
  final TextEditingController _controllerMobile = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerDob = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.green,
        title: Text(register),
      ),
      body: _widgetBody(),
     // floatingActionButton: _widgetFloatingButton(),
    );
  }

  Widget _widgetBody() {
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
            widgetTextField(_controllerPassword, password, 1,
                TextInputType.visiblePassword),
            SizedBox(
              height: 10.h,
            ),
            widgetButton(register, () {
              print('register');
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
}
