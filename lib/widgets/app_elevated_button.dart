import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homeworkhelper/utils/app_style.dart';

import '../utils/app_color.dart';
import 'media_query.dart';

class AppElevatedButton extends StatelessWidget {
  final double? fontSize;
  final void Function()? onPressed;
  final Color? color;

  final Size? fixedSize;
  final Widget? widget;

  final Color? backGroundColor;
  final String? imageName;
  final String? text;

  const AppElevatedButton({
    super.key,
    this.text,
    this.fontSize,
    this.color,
    this.imageName,
    this.onPressed,
    this.backGroundColor,
    this.fixedSize,
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(Get.width * 0.004))),
        ),
        backgroundColor:
            MaterialStateProperty.all(backGroundColor ?? AppColors.lightWhite),
        fixedSize: MaterialStateProperty.all(
          fixedSize ?? Size(Get.width * 0.4, Get.height * 0.07),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (imageName != null)
            Image.asset(imageName!,
                fit: BoxFit.cover, height: Get.height * 0.04),
          SizedBox(width: width(context) * 0.01),
          if (imageName == null) const SizedBox(),
          Flexible(
            child: widget ??
                Text(
                  text!,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: color ?? AppColors.blackColor,
                    fontSize: fontSize ?? Get.width * 0.012,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
          ),
        ],
      ),
    );
  }
}

Widget addButton(
    {double? height,
    double? width,
    required String text,
    final void Function()? onTap}) {
  return InkWell(
    onTap: onTap!,
    child: Container(
      height: height, //Get.height * 0.07,
      width: width, //Get.width * 0.154,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: AppColors.blueColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.add,
            size: 24,
            color: AppColors.whiteColor,
          ),
          appText(
            text: text,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            fontColor: AppColors.whiteColor,
          )
        ],
      ),
    ),
  );
}

Widget appButton(
  String text,
  void Function()? onPressed,
  Color? color, {
  double? height,
  double? width,
}) {
  return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
        backgroundColor:
            MaterialStateProperty.all(color ?? AppColors.lightWhite),
        fixedSize: MaterialStateProperty.all(
          Size(
            width ?? Get.width * 0.089,
            height ?? Get.height * 0.053,
          ),
        ),
      ),
      onPressed: onPressed,
      child: appText(
          text: text,
          fontSize: 18,
          fontWeight: FontWeight.w400,
          fontColor: AppColors.whiteColor));
}

class AppSmallButton extends StatelessWidget {
  final Color? backGroundColor;
  final double? fontSize;
  final void Function()? onPressed;
  final Color? color;
  final double? height;
  final double? width;
  final String? text;
  final FontWeight? fontWeight;
  const AppSmallButton(
      {super.key,
      this.onPressed,
      this.height,
      this.width,
      this.fontSize,
      this.color,
      this.backGroundColor,
      this.text,
      this.fontWeight});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: height ?? Get.height * 0.07,
        width: width ?? Get.width * 0.4,
        decoration: BoxDecoration(
          color: backGroundColor ?? AppColors.lightWhite,
          borderRadius: BorderRadius.all(Radius.circular(Get.width * 0.004)),
        ),
        child: Center(
          child: Text(
            text!,
            style: TextStyle(
                overflow: TextOverflow.ellipsis,
                fontWeight: fontWeight ?? FontWeight.w600,
                color: color ?? AppColors.blackColor,
                fontSize: fontSize ?? 10),
          ),
        ),
      ),
    );
  }
}
