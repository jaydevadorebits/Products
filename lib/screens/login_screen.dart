import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:products/helper/authentication_helper.dart';
import 'package:products/helper/common_strings.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:products/screens/home_screen.dart';
import 'package:products/screens/register_screen.dart';
import 'package:provider/provider.dart';
import '../helper/helper_class.dart';
import '../providers/login_register_provider.dart';
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
        body: Consumer<AuthenticationProvider>(
            builder: (context, authProvider, child) {
          return authProvider.loading
              ? Center(
                  child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
                ))
              : _widgetBody(authProvider);
        }
            //_widgetBody(),
            //floatingActionButton: _widgetFloatingButton(),
            ));
  }

  Widget _widgetBody(AuthenticationProvider authenticationProvider) {
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
              loginUser(_controllerEmail.text, _controllerPassword.text,
                  authenticationProvider);
              //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
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
            //loginUser(_controllerEmail.text, _controllerPassword.text,);
          }
        });
  }

  void loginUser(String email, String password,
      AuthenticationProvider authenticationProvider) {
    authenticationProvider.loading = true;
    authenticationProvider
        .signIn(email: email, password: password)
        .then((result) {
      if (result == null) {
        User user = AuthenticationHelper().user;
        /*Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(
                      user: user,
                    )));*/
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen(user: user)),
            (route) => false);
      } else {
        authenticationProvider.loading = false;
        Helper.show_msg(result);
      }
    });

    /*AuthenticationHelper()
        .signIn(email: email, password: password)
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
}
