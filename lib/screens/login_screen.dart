import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:products/helper/common_strings.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:products/screens/home_screen.dart';
import 'package:products/screens/register_screen.dart';
import '../helper/helper_class.dart';
import '../utils/common_widgets.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<LoginScreen> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(login),
        automaticallyImplyLeading: false,
      ),
      body: _widgetBody(),
      //floatingActionButton: _widgetFloatingButton(),
    );
  }

  Widget _widgetBody() {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.15,
            ),
            widgetTextField(
                _controllerEmail, email, 1, TextInputType.emailAddress),
            widgetTextField(_controllerPassword, password, 1,
                TextInputType.visiblePassword),
            SizedBox(
              height: 10.h,
            ),
            widgetButton(login, () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            }),
            Container(
              margin: EdgeInsets.only(
                  left: 22.h, right: 22.h, top: 20.h, bottom: 5.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    you_dont_have_account,
                    style: text_style_regular(14.sp, Colors.black),
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterScreen()));
                      },
                      child: Padding(
                          padding: EdgeInsets.only(left: 5.w, right: 5.w),
                          child: Text(register)))
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
          if (_controllerEmail.text.isEmpty)
            Helper.show_msg('Please set email');
          else if (_controllerPassword.text.isEmpty)
            Helper.show_msg('Please set password');
          else {
            DateFormat dateFormat =
                DateFormat("dd-MM-yyyy"); //yyyy-MM-dd HH:mm:ss
            var date_time = dateFormat.format(DateTime.now());
            print('date time ' + dateFormat.format(DateTime.now()));
          }
        });
  }
}
