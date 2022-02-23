import 'dart:async';

import 'package:flutter/material.dart';

import 'package:products/screens/login_screen.dart';

import 'package:products/utils/common_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashState();
  }
}

class SplashState extends State<SplashScreen> {
  @override
  initState() {
    super.initState();
    print('init_state');
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      //   navigateScreen();
      Timer(Duration(seconds: 5), () => onDoneLoadingLoginScreen());
    });
  }

  navigateScreen() {
    return new Timer(Duration(seconds: 3), onDoneLoadingLoginScreen());
  }

  /*onDoneLoadingHomeScreen(User user) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            DashboardScreen(user: user), //KeepNoteListScreen(),
      ),
    );
  }*/

  onDoneLoadingLoginScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(), //KeepNoteListScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
  }
}
