import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homeworkhelper/controller/school_sdmin_controller.dart';
import 'package:homeworkhelper/controller/teacherController.dart';
import 'package:homeworkhelper/widgets/media_query.dart';

import '../controller/teacher_dashboard_controller.dart';
import '../utils/app_color.dart';
import '../utils/app_componet.dart';
import '../utils/app_style.dart';
import '../utils/str_const.dart';
import '../widgets/custome_app_bar.dart';

class SchoolAdminScreen extends StatefulWidget {
  const SchoolAdminScreen({super.key});

  @override
  State<SchoolAdminScreen> createState() => _SchoolAdminScreenState();
}

class _SchoolAdminScreenState extends State<SchoolAdminScreen> {
  final schoolAdminController = Get.put(SchoolAdminController());
  final teacherController = Get.put(TeacherController());

  final teacherDashBoardController = Get.put(TeacherDashBoardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorF3FA,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Obx(
          () => CustomAppBar(
            switchValue: teacherDashBoardController.switchValue.value,
            onSwitchChanged: (value) {
              teacherDashBoardController.switchValue.value = value;
              // Do something with the updated switch value
            },
          ),
        ),
      ),
      body: Padding(
        padding:
            EdgeInsets.only(left: Get.width * 0.016, right: Get.width * 0.016),
        child: Obx(
          () => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            verticalSpacing(height: Get.height * 0.040),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                appText(
                    text: AppString.schoolAdmin,
                    fontSize: 28,
                    //  fontFamily: poppinsFontFamily,
                    fontWeight: FontWeight.w600,
                    fontColor: AppColors.color3246),
              ],
            ),
            verticalSpacing(height: Get.height * 0.030),
            Container(
                height: height(context) * 0.74,
                width: width(context) * 0.8973,
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.colorDEDE, width: 1),
                    color: AppColors.whiteColor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SearchFieldWidget(
                      controller: schoolAdminController.teacherNameController,
                      onChanged: schoolAdminController.applyFilter,
                      onTap: () {
                        schoolAdminController.teacherNameController.clear();
                        schoolAdminController.applyFilter('');
                      },
                    ),
                    schoolAdminController.dataTableWidget(context),
                  ],
                )),
          ]),
        ),
      ),
    );
  }

  TextStyle appTextStyle(
      {Color? color, FontWeight? fontWeight, double? fontSize}) {
    return TextStyle(
        color: color ?? AppColors.blackColor,
        fontWeight: fontWeight ?? FontWeight.w600,
        fontSize: fontSize ?? 14);
  }
}
