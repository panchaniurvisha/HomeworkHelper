// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homeworkhelper/controller/course_Controller.dart';
import 'package:homeworkhelper/utils/app_color.dart';
import 'package:homeworkhelper/utils/app_componet.dart';
import 'package:homeworkhelper/utils/app_style.dart';

final courseController = Get.put(CourseController());

class CustomAlertDialog extends StatelessWidget {
  // final String title;

  final double height;
  final double width;
  final String alertTitle;
  final void Function()? onTap;
  final Widget mainBody;

  CustomAlertDialog(
      {
      //required this.title,

      required this.height,
      required this.width,
      required this.alertTitle,
      required this.onTap,
      required this.mainBody});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      content: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Get.width * 0.01),
            color: AppColors.whiteColor),
        child: Padding(
          padding: EdgeInsets.only(
              left: Get.width * 0.0172,
              right: Get.width * 0.0172,
              bottom: Get.height * 0.03,
              top: Get.height * 0.0172),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  appText(
                      text: alertTitle,
                      fontColor: AppColors.blackColor,
                      fontSize: 22,
                      fontWeight: FontWeight.w600),
                  InkWell(
                    onTap: () => Get.back(),
                    child: Icon(
                      Icons.close_rounded,
                      size: 21,
                      color: AppColors.blackColor,
                    ),
                  )
                ],
              ),
              verticalSpacing(height: Get.height * 0.023),
              mainBody
            ],
          ),
        ),
      ),
    );
  }
}
