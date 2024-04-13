import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homeworkhelper/controller/course_Controller.dart';
import 'package:homeworkhelper/controller/login_controller.dart';
import 'package:homeworkhelper/utils/app_images.dart';
import 'package:homeworkhelper/widgets/media_query.dart';

import '../controller/teacher_dashboard_controller.dart';
import '../utils/app_color.dart';
import '../utils/app_componet.dart';
import '../utils/app_style.dart';
import '../utils/str_const.dart';
import '../widgets/app_dialog_box.dart';
import '../widgets/app_elevated_button.dart';
import '../widgets/app_text_field.dart';
import '../widgets/custome_app_bar.dart';
import '../widgets/dropDownMenu.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  final teacherDashBoardController = Get.put(TeacherDashBoardController());
  final courseController = Get.put(CourseController());
  final loginCintroller = Get.put(LoginController());
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

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
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: appText(
                            text: AppString.courseName,
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            fontColor: AppColors.color3246),
                      ),
                      horizonatlSpacing(width: Get.width * 0.0031),
                      Image.asset(
                        AppIcon.courseIcon,
                        height: 20,
                        width: 20,
                      ),
                    ],
                  ),
                ),
                loginCintroller.isAdmin.value == true
                    ? SizedBox()
                    : addButton(
                        height: Get.height * 0.07,
                        width: Get.width * 0.1537,
                        text: AppString.addCourses,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                                onTap: () {
                                  Get.back();

                                  courseController
                                      .coursePeriod1Controller.text = '';

                                  courseController.courseNameController.text =
                                      '';
                                  courseController.studentsListController.text =
                                      '';

                                  courseController.selectedTeacherName.value =
                                      '';
                                },
                                alertTitle: AppString.courseName,
                                // height: Get.height * 0.465,
                                height: Get.height * 0.354,
                                width: Get.width * 0.597,
                                mainBody: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      // mainAxisAlignment:
                                      //     MainAxisAlignment.spaceBetween,
                                      children: [
                                        PopupTextField(
                                          controller: courseController
                                              .courseNameController,
                                          text: AppString.courseName,
                                          hintText: 'Course Name',
                                          onChanged: (p0) {},
                                          onTap: () {},
                                        ),
                                        /* Obx(
                                          () => DropDownWidget(
                                            dropDowntitle: 'Courses Name',
                                            onChanged: (value) {
                                              courseController.selectedCourse
                                                  .value = value ?? '';
                                            },
                                            hinttext: 'Web Development',
                                            value: courseController
                                                        .selectedCourse.value ==
                                                    ""
                                                ? null
                                                : courseController
                                                    .selectedCourse.value,
                                            items: courseController.courseName
                                                .map((e) {
                                              return DropdownMenuItem(
                                                value: e,
                                                child: Text(e),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                        /* dropdownMenu(
                                          courseController
                                              .courseName.obs.value,
                                          AppString.course), */ */
                                        Spacer(),
                                        PopupTextField(
                                          controller: courseController
                                              .coursePeriod1Controller,
                                          text: AppString.coursePeriod,
                                          hintText: 'Courses Period',
                                          onChanged: (p0) {},
                                          onTap: () {},
                                        ),
                                        Spacer(),
                                        Obx(
                                          () => DropDownWidget(
                                            dropDowntitle: 'Teacher Name',
                                            onChanged: (value) {
                                              courseController
                                                  .selectedTeacherName
                                                  .value = value ?? '';
                                            },
                                            hinttext: 'Teacher Name',
                                            value: courseController
                                                        .selectedTeacherName
                                                        .value ==
                                                    ""
                                                ? null
                                                : courseController
                                                    .selectedTeacherName.value,
                                            items: courseController.teacherList
                                                .map((e) {
                                              return DropdownMenuItem<String>(
                                                value: e,
                                                child: Text(e),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                        /* PopupTextField(
                                          controller: courseController
                                              .studentsListController,
                                          text: AppString.teacher,
                                          hintText: 'Teacher',
                                          onChanged: (p0) {},
                                          onTap: () {},
                                        ), */
                                      ],
                                    ),
                                    verticalSpacing(height: Get.height * 0.063),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: appButton(AppString.add, () async {
                                        /* courseController.enrollStudentInCourse(
                                            'Web Development'); */

                                        var courseadd = firestore
                                            .collection('Courses')
                                            .doc();

                                        await courseadd.set({
                                          'id': courseadd.id,
                                          'course': courseController
                                              .courseNameController.value.text
                                              .trim(),
                                          'course_period': courseController
                                              .coursePeriod1Controller.text,
                                          'teacher': courseController
                                              .selectedTeacherName.value,
                                          'qr_code': '',
                                          'students': []
                                        }).then((value) {
                                          Get.back();
                                        });
                                      }, AppColors.blueColor),
                                    )
                                  ],
                                )),
                          );
                        },
                      )
              ],
            ),
            verticalSpacing(height: Get.height * 0.040),
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
                      controller: TextEditingController(),
                      onChanged: (v) {},
                      onTap: () {},
                    ),
                    Visibility(
                      visible: courseController.isAnyChecked.value,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15, right: 15),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: appButton(
                              AppString.delete, () {}, AppColors.color2121),
                        ),
                      ),
                    ),
                    courseController.dataTableWidget(context),
                  ],
                )),
          ]),
        ),
      ),
    );
  }
}
