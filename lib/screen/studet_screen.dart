import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homeworkhelper/controller/student_Controller.dart';
import 'package:homeworkhelper/utils/app_color.dart';
import 'package:homeworkhelper/utils/app_componet.dart';
import 'package:homeworkhelper/widgets/app_elevated_button.dart';
import 'package:homeworkhelper/widgets/media_query.dart';

import '../controller/teacher_dashboard_controller.dart';
import '../utils/app_style.dart';
import '../utils/str_const.dart';
import '../widgets/custome_app_bar.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  final teacherDashBoardController = Get.put(TeacherDashBoardController());
  final studentScreenController = Get.put(StudentController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    studentScreenController.setContext(context);
  }

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
            },
          ),
        ),
      ),
      body: Padding(
        padding:
            EdgeInsets.only(left: Get.width * 0.016, right: Get.width * 0.016),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          verticalSpacing(height: Get.height * 0.040),
          appText(
              text: AppString.student,
              fontSize: 28,
              fontWeight: FontWeight.w600,
              fontColor: AppColors.color3246),
          verticalSpacing(height: Get.height * 0.040),
          Container(
              height: height(context) * 0.74,
              width: width(context) * 0.8973,
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.colorDEDE, width: 1),
                  color: AppColors.whiteColor),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SearchFieldWidget(
                      controller: studentScreenController.nameController.value,
                      onChanged: studentScreenController.applyFilter,
                      onTap: () {
                        studentScreenController.applyFilter('');
                      },
                    ),
                    Obx(() => studentScreenController.selectedIds.isNotEmpty
                        ? Padding(
                            padding:
                                const EdgeInsets.only(bottom: 15, right: 15),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: appButton(AppString.delete, () {
                                studentScreenController.deleteSelectedItems();
                              }, AppColors.color2121),
                            ),
                          )
                        : SizedBox()),
                    studentScreenController.dataTableWidget(context),
                  ],
                ),
              )),
        ]),
      ),
    );
  }
}
