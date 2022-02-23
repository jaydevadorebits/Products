import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:products/model/user.dart';
import 'package:products/screens/login_screen.dart';
import 'package:products/utils/common_widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../helper/color_extenstion.dart';
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
  var Dateofbirth;

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
        body: authProvider.loading
            ? Center(
                child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
              ))
            : _widgetBody(authProvider),
      );
    });
  }

  Widget _widgetBody(AuthenticationProvider authenticationProvider) {
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
            widgetDateOfBirth(),
            //widgetTextField(_controllerDob, dob, 1, TextInputType.text),
            SizedBox(
              height: 20.h,
            ),
            widgetButton('Update', () {
              if (_controllerFirstName.text.isEmpty)
                Helper.show_msg('Please add first name');
              else if (_controllerLastName.text.isEmpty)
                Helper.show_msg('Please add last name');
              else if (_controllerMobile.text.isEmpty)
                Helper.show_msg('Please add mobile');
              else if (_controllerEmail.text.isEmpty)
                Helper.show_msg('Please add email');
              else if (_controllerDob.text.isEmpty)
                Helper.show_msg('Please add date of birth');
              else {
                authenticationProvider.loading = true;
                authenticationProvider
                    .updateUser(
                        widget.userId,
                        _controllerFirstName.text,
                        _controllerLastName.text,
                        _controllerMobile.text,
                        _controllerEmail.text,
                        selecteditem.toString(),
                        _controllerDob.text)
                    .then((value) {
                  Helper.show_msg('Profile updated.');
                  authenticationProvider.loading = false;
                });
                print('update' + _controllerDob.text);
              }
            }),
          ],
        ),
      ),
    );
  }

  widgetDateOfBirth() {
    return GestureDetector(
      onTap: () async {
        Dateofbirth = await showDatePicker(
          context: context,
          firstDate: DateTime(1960),
          initialDate: DateTime.now(),
          lastDate: DateTime.now(),
        );

        if (Dateofbirth != null) {
          final DateFormat formatter = DateFormat('dd-MM-yyyy');

          final String formatingdate = formatter.format(Dateofbirth);
          _controllerDob.text = formatingdate;
          print(Dateofbirth);
        }
      },
      child: Container(
        margin:
            EdgeInsets.only(left: 22.h, right: 22.h, top: 10.h, bottom: 5.h),
        decoration: new BoxDecoration(
            color: Colors.transparent,
            borderRadius: new BorderRadius.circular(12.h),
            border: Border.all(color: Colors.green)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 13.h),
          child: TextField(
            controller: _controllerDob,
            enabled: false,
            decoration: InputDecoration(
              hintText: "Select Date of Birth",
              hintStyle: text_style_regular(20.sp, HexColor('#40333333')),
              border: InputBorder.none,
            ),
            maxLines: 1,
            style: text_style_regular(20.sp, color_regular),
          ),
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
          isExpanded: true,
          value: selecteditem,
        ),
      ),
    );
  }
}
