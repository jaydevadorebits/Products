import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:products/helper/color_extenstion.dart';
import 'package:products/helper/common_strings.dart';

text_style_regular(double fontSize, Color fontColor) {
  return TextStyle(
      fontSize: fontSize,
      color: fontColor,
      fontFamily: 'SFUIText_Regular',
      fontWeight: FontWeight.normal);
}

widgetTextField(TextEditingController controller, String hintText, int maxline,
    TextInputType inputType) {
  return Container(
    margin: EdgeInsets.only(left: 22.h, right: 22.h, top: 10.h, bottom: 5.h),
    decoration: new BoxDecoration(
        color: Colors.transparent,
        borderRadius: new BorderRadius.circular(12.h),
        border: Border.all(color: Colors.green)),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 13.h),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: text_style_regular(20.sp, HexColor('#40333333')),
          border: InputBorder.none,
        ),
        maxLines: maxline,
        style: text_style_regular(20.sp, color_regular),
      ),
    ),
  );
}

widgetTextFieldPhone(TextEditingController controller, String hintText,
    int maxline, int maxLength, TextInputType inputType) {
  return Container(
    margin: EdgeInsets.only(left: 22.h, right: 22.h, top: 10.h, bottom: 5.h),
    decoration: new BoxDecoration(
        color: Colors.transparent,
        borderRadius: new BorderRadius.circular(12.h),
        border: Border.all(color: Colors.green)),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 13.h),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        maxLength: maxLength,
        inputFormatters: [
          LengthLimitingTextInputFormatter(10),
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: text_style_regular(20.sp, HexColor('#40333333')),
            border: InputBorder.none,
            counterText: ''),
        maxLines: maxline,
        style: text_style_regular(20.sp, color_regular),
      ),
    ),
  );
}

widgetButton(String text, GestureTapCallback? onTap) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: 55.h,
      margin: EdgeInsets.only(left: 22.h, right: 22.h, top: 10.h, bottom: 5.h),
      decoration: new BoxDecoration(
          color: Colors.green,
          borderRadius: new BorderRadius.circular(12.h),
          border: Border.all(color: Colors.green)),
      child: Center(
        child: Text(
          text,
          style: text_style_regular(14.sp, Colors.white),
        ),
      ),
    ),
  );
}
