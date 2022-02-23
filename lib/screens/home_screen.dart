import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:products/helper/common_strings.dart';
import 'package:products/screens/product_list_screen.dart';
import 'package:products/screens/user_profile_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  User user;

  HomeScreen({required this.user});

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<HomeScreen> {
  //List<Widget> tabPages = [ProductsScreen(), ProfileScreen()];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetBody(),
      bottomNavigationBar: _widgetBottomNavigationBar(),
    );
  }

  Widget _widgetBody() {
    return IndexedStack(
      index: selectedIndex,
      children: <Widget>[
        ProductsScreen(
          user: widget.user,
        ),
        ProfileScreen(userId: widget.user.uid),
      ],
    );
  }

  Widget _widgetBottomNavigationBar() {
    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      elevation: 0,
      selectedItemColor: Colors.white,
      backgroundColor: Colors.green,
      type: BottomNavigationBarType.fixed,
      currentIndex: selectedIndex,
      onTap: _onItemTapped,
      // currentIndex: selectedIndex,
      // onTap: onTabTapped,
      items: [
        BottomNavigationBarItem(label: products, icon: const Icon(Icons.list)),
        BottomNavigationBarItem(icon: const Icon(Icons.person), label: profile),
      ],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}
