import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homeworkhelper/controller/login_controller.dart';
import 'package:homeworkhelper/controller/main_homeController.dart';
import 'package:homeworkhelper/utils/app_color.dart';
import 'package:homeworkhelper/utils/app_componet.dart';
import 'package:homeworkhelper/utils/app_images.dart';
import 'package:homeworkhelper/utils/app_style.dart';
import 'package:homeworkhelper/utils/str_const.dart';
import 'package:homeworkhelper/widgets/media_query.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  final mainHomeScreenController = Get.put(MainHomeScreenController());
  final loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    double screenWidth = width(context);

    bool isSmallScreen = screenWidth <= 900.0;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              Container(
                width: isSmallScreen
                    ? constraints.maxWidth * 0.1
                    : constraints.maxWidth * 0.2, // Adjust as needed
                height: constraints.maxHeight,
                color: AppColors.whiteColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    verticalSpacing(height: constraints.maxHeight * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppImages.appLogo,
                          height: constraints.maxHeight * 0.082,
                          width: isSmallScreen
                              ? constraints.maxHeight * 0.070
                              : constraints.maxHeight * 0.082,
                        ),
                        horizonatlSpacing(width: constraints.maxWidth * 0.0078),
                        Visibility(
                          visible: !isSmallScreen,
                          child: appText(
                              text: AppString.admin,
                              fontFamily: firaSansFontFamily,
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                              fontColor: AppColors.blueColor),
                        ),
                      ],
                    ),
                    SizedBox(height: constraints.maxHeight * 0.12),
                    mainHomeScreenController.sidebarButton(AppString.dashboard,
                        AppIcon.dashbordIcon, AppIcon.dashboard2, context),
                    mainHomeScreenController.sidebarButton(
                        AppString.schoolAdmin,
                        AppIcon.schoolAdmin,
                        AppIcon.schoolAdmin2,
                        context),
                    mainHomeScreenController.sidebarButton(AppString.teacher,
                        AppIcon.teacher, AppIcon.teacher2, context),
                    mainHomeScreenController.sidebarButton(AppString.student,
                        AppIcon.student, AppIcon.student2, context),
                    mainHomeScreenController.sidebarButton(AppString.course,
                        AppIcon.classA, AppIcon.class2, context),
                    mainHomeScreenController.sidebarButton(AppString.assigment,
                        AppIcon.assigment, AppIcon.assigment2, context),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        loginController.googleSignOut();
                      },
                      child: Padding(
                        padding:
                            EdgeInsets.only(bottom: height(context) * 0.035),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            horizonatlSpacing(width: width(context) * 0.025),
                            Image.asset(
                              AppIcon.logout,
                              height: height(context) * 0.04,
                              width: width(context) * 0.04,
                            ),
                            horizonatlSpacing(
                                width: constraints.maxWidth * 0.02),
                            Visibility(
                              visible: !isSmallScreen,
                              child: appText(
                                  text: AppString.logout,
                                  fontColor: AppColors.grayColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Obx(() => mainHomeScreenController.getBodyWidget()),
              ),
            ],
          ),
        );
      },
    );
  }
}
