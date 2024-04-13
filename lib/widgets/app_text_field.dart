// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:homeworkhelper/utils/app_color.dart';
import 'package:homeworkhelper/utils/app_componet.dart';
import 'package:homeworkhelper/utils/app_style.dart';

import 'media_query.dart';

class PopupTextField extends StatelessWidget {
  final String text;
  final String hintText;
  final Widget? suffixIcon;
  final int? maxLines;
  final Color? backGrounColor;
  final double? Height;
  final double? Width;
  final bool? readOnly;
  final Color? borderColor;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final void Function(String) onChanged;
  final void Function() onTap;
  PopupTextField(
      {super.key,
      required this.text,
      required this.hintText,
      this.controller,
      required this.onChanged,
      required this.onTap,
      this.backGrounColor,
      this.borderColor,
      this.keyboardType,
      this.suffixIcon,
      this.maxLines,
      this.Height,
      this.Width,
      this.readOnly});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        appText(
            text: text,
            fontSize: 12,
            fontColor: AppColors.blackColor,
            fontWeight: FontWeight.w400),
        verticalSpacing(
            height: height(context) * 0.013), // Adjust the spacing as needed
        Container(
          height: Height ?? height(context) * 0.048,
          width: Width ?? width(context) * 0.176,
          // padding: EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            border: Border.all(
              color: borderColor ?? Colors.transparent,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(2),
            color: backGrounColor ?? AppColors.colorF3F3,
          ),
          child: TextField(
            readOnly: readOnly ?? false,
            keyboardType: keyboardType,
            style: TextStyle(fontSize: 12.0, color: Colors.black),
            maxLines: maxLines ?? 1,
            controller: controller,
            onChanged: onChanged,
            onTap: onTap,
            cursorColor: AppColors.grayColor,
            textAlign: TextAlign.left,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              fillColor: AppColors.colorF3F3,
              hintText: hintText,
              hintStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.grayColor,
              ),
              border: InputBorder.none,
              disabledBorder:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(2)),
              contentPadding: EdgeInsets.only(bottom: 18, left: 5),
              suffixIcon: suffixIcon ?? SizedBox(),
            ),
          ),
        ),
      ],
    );
  }
}
