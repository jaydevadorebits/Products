import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:products/helper/authentication_helper.dart';
import 'package:products/screens/home_screen.dart';

import 'package:products/screens/login_screen.dart';

import 'package:products/utils/common_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../providers/login_register_provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashState();
  }
}

class SplashState extends State<SplashScreen> {
  bool isMethodCalled = false;

  @override
  initState() {
    super.initState();
    print('init_state');
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      Timer(Duration(seconds: 5), () => onDoneLoadingLoginScreen());
    });
  }

  onInitializeProvider() async {
    if (!isMethodCalled) {
      User user =
          Provider.of<AuthenticationProvider>(context, listen: false).user;
      isMethodCalled = !isMethodCalled;
    }
  }

  navigateScreen() {
    return new Timer(Duration(seconds: 3), onDoneLoadingLoginScreen());
  }

  onDoneLoadingLoginScreen() {
    if (Provider.of<AuthenticationProvider>(context, listen: false).user !=
        null) {
      User user = Provider.of<AuthenticationProvider>(context, listen: false)
          .user; //AuthenticationHelper().user;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(user: user),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationProvider>(
        builder: (context, authProvider, child) {
      return Scaffold(
        backgroundColor: Colors.green,
        body: Container(
          child: Center(
            child: Text(
              'SplashScreen',
              style: text_style_regular(16.sp, Colors.white),
            ),
          ),
        ),
      );
    });
  }
}
