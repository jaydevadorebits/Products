import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:products/providers/login_register_provider.dart';
import 'package:products/providers/products_provider.dart';

import 'package:products/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<ProductsProvider>.value(value: ProductsProvider()),
      ChangeNotifierProvider<AuthenticationProvider>.value(
          value: AuthenticationProvider()),

    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  //late User user;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      builder: () => MaterialApp(
        title: 'Products',
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
