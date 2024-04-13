// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homeworkhelper/screen/assignment_Screen.dart';
import 'package:homeworkhelper/screen/studet_screen.dart';
import 'package:homeworkhelper/screen/teacherScreen.dart';
import 'package:homeworkhelper/screen/teacher_dashboard_screen.dart';
import 'package:homeworkhelper/utils/app_color.dart';
import 'package:homeworkhelper/utils/app_componet.dart';
import 'package:homeworkhelper/utils/app_style.dart';
import 'package:homeworkhelper/utils/str_const.dart';
import 'package:homeworkhelper/widgets/media_query.dart';

import '../screen/course_screen.dart';
import '../screen/school_admin_screen.dart';

class MainHomeScreenController extends GetxController {
  final RxString selectedPage = AppString.dashboard.obs;

  Widget sidebarButton(
      String text, String image, String image2, BuildContext context) {
    double screenWidth = width(context);
    bool isSmallScreen = screenWidth <= 900.0;
    return Obx(
      () => InkWell(
        onTap: () {
          selectedPage.value = text;
        },
        child: Padding(
          padding: EdgeInsets.only(bottom: height(context) * 0.035),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              horizonatlSpacing(
                  width: selectedPage.value == text
                      ? width(context) * 0.0117
                      : width(context) * 0.0195),
              selectedPage.value == text
                  ? Image.asset(
                      image2,
                      height: Get.height * 0.080,
                      width: isSmallScreen
                          ? Get.height * 0.070
                          : Get.height * 0.080,
                    )
                  : Image.asset(
                      image,
                      height: height(context) * 0.040,
                      width: height(context) * 0.040,
                    ),
              isSmallScreen
                  ? horizonatlSpacing(width: 0.0)
                  : horizonatlSpacing(
                      width: selectedPage.value == text
                          ? Get.width * 0.0078
                          : Get.width * 0.0156),
              text == selectedPage.value
                  ? Visibility(
                      visible: !isSmallScreen,
                      child: appText(
                          text: text,
                          fontColor: AppColors.blueColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    )
                  : Visibility(
                      visible: !isSmallScreen,
                      child: appText(
                          text: text,
                          fontColor: AppColors.grayColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    ),
              Spacer(),
              text == selectedPage.value
                  ? Container(
                      height: height(context) * 0.047,
                      width: width(context) * 0.00234,
                      decoration: BoxDecoration(
                          color: AppColors.blueColor,
                          borderRadius: BorderRadius.all(Radius.circular(22))),
                    )
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  Widget getBodyWidget() {
    switch (selectedPage.value) {
      case AppString.dashboard:
        return TeacherDashboardScreen();
      case AppString.teacher:
        return TeacherScreen();
      case AppString.schoolAdmin:
        return SchoolAdminScreen();
      case AppString.student:
        return StudentScreen();
      case AppString.course:
        return CourseScreen();
      case AppString.assigment:
        return AssignmentScreen();
      // case AppString.profile:
      //   return TeacherDashboardScreen();

      default:
        return Container(); // Default page
    }
  }
}
