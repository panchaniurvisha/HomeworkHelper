// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homeworkhelper/utils/app_color.dart';
import 'package:homeworkhelper/utils/str_const.dart';

String firaSansFontFamily = 'Fira Sans';

class SearchFieldWidget extends StatelessWidget {
  SearchFieldWidget(
      {super.key,
      this.controller,
      required this.onChanged,
      required this.onTap});

  final TextEditingController? controller;
  void Function(String) onChanged;
  void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        // height: Get.height * 0.073, //7986
        // width: Get.width * 0.7986,
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.colorC2C2, width: 1),
            borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, top: 2, bottom: 2),
            child: TextFormField(
              controller: controller,
              onChanged: onChanged,
              onTap: onTap,
              decoration: InputDecoration(
                  hintText: AppString.searchbyname,
                  helperStyle: TextStyle(
                      fontSize: 16,
                      // fontFamily: poppinsFontFamily,
                      color: AppColors.color9E9E),
                  border: InputBorder.none,
                  icon: GestureDetector(
                    child: Icon(
                      Icons.search,
                      size: 24,
                      color: AppColors.color4040,
                    ),
                  )),
            ),
          ),
        ),
      ),
    );
  }
}

abstract class ThemeText {
  static TextStyle header = TextStyle(
      color: Colors.black,
      fontSize: Get.width * 0.02,
      fontWeight: FontWeight.w600);
  static TextStyle subHeader = TextStyle(
      color: AppColors.grayColor, fontSize: 12, fontWeight: FontWeight.w500);
  static TextStyle regular = TextStyle(
      color: AppColors.blackColor, fontSize: 16, fontWeight: FontWeight.w400);
}

Widget appText(
    {required String text,
    Color? fontColor,
    Color? bgColor,
    double? fontSize,
    String? fontFamily,
    FontStyle? fontStyle,
    FontWeight? fontWeight,
    TextAlign? textAlign,
    TextOverflow? overFlow,
    TextDecoration? decoration,
    int? maxLines,
    double? height}) {
  return Text(
    text,
    style: TextStyle(
        color: fontColor ?? AppColors.blueColor,
        fontSize: fontSize ?? 18,
        fontFamily: fontFamily,
        backgroundColor: bgColor,
        fontStyle: fontStyle,
        overflow: TextOverflow.ellipsis,
        fontWeight: fontWeight ?? FontWeight.w400,
        decoration: decoration,
        height: height),
    maxLines: maxLines,
    overflow: overFlow,
    textAlign: textAlign,
  );
}

TextStyle appTextStyle(
    {Color? txtColor,
    Color? bgColor,
    double? height,
    double? fontSize,
    String? fontFamily,
    FontStyle? fontStyle,
    TextDecoration? decoration,
    FontWeight? fontWeight}) {
  return TextStyle(
      color: txtColor ?? AppColors.blueColor,
      fontSize: fontSize ?? 18,
      fontFamily: fontFamily ?? firaSansFontFamily,
      backgroundColor: bgColor,
      fontStyle: fontStyle,
      fontWeight: fontWeight ?? FontWeight.w400,
      decoration: decoration,
      height: height);
}
