import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homeworkhelper/controller/login_controller.dart';
import 'package:homeworkhelper/controller/teacherController.dart';
import 'package:homeworkhelper/controller/teacher_dashboard_controller.dart';
import 'package:homeworkhelper/utils/app_color.dart';
import 'package:homeworkhelper/utils/app_componet.dart';
import 'package:homeworkhelper/utils/app_style.dart';
import 'package:homeworkhelper/utils/str_const.dart';
import 'package:homeworkhelper/widgets/app_dialog_box.dart';
import 'package:homeworkhelper/widgets/app_elevated_button.dart';
import 'package:homeworkhelper/widgets/app_text_field.dart';
import 'package:homeworkhelper/widgets/media_query.dart';

import '../widgets/custome_app_bar.dart';
import '../widgets/dropDownMenu.dart';

class TeacherScreen extends StatefulWidget {
  const TeacherScreen({
    super.key,
  });

  @override
  State<TeacherScreen> createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  final teacherDashBoardController = Get.put(TeacherDashBoardController());
  final teacherController = Get.put(TeacherController());
  final loginCintroller = Get.put(LoginController());
  bool isVisible = false;
  final CollectionReference adminCollection =
      FirebaseFirestore.instance.collection('Admin');
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // final CollectionReference _dataCollection =
  //     FirebaseFirestore.instance.collection('User');

  @override
  void initState() {
    super.initState();
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
              // Do something with the updated switch value
            },
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
            left: width(context) * 0.01560, right: width(context) * 0.01560),
        child: Obx(
          () => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            verticalSpacing(height: Get.height * 0.040),
            Row(
              children: [
                appText(
                    text: AppString.teacher,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    fontColor: AppColors.color3246),
                Spacer(),
                loginCintroller.isAdmin.value == true
                    ? addButton(
                        height: Get.height * 0.07,
                        width: Get.width * 0.1537,
                        text: AppString.addTeacher,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                                height: Get.height * 0.465,
                                width: Get.width * 0.597,
                                alertTitle: AppString.nikunj,
                                onTap: () {
                                  Get.back();
                                  courseController.selectedteacherCourse.value =
                                      '';
                                  courseController
                                      .selectedteachersubject.value = '';
                                  teacherController.teacherNameController.text =
                                      '';
                                  teacherController.studentNameController.text =
                                      '';
                                  teacherController.experienceController.text =
                                      '';
                                },
                                mainBody: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        PopupTextField(
                                          controller: teacherController
                                              .teacherNameController,
                                          text: AppString.teacherName,
                                          hintText: 'Enter Name',
                                          onChanged: (p0) {},
                                          onTap: () {},
                                        ),
                                        horizonatlSpacing(
                                            width: Get.width * 0.017),
                                        Obx(
                                          () => DropDownWidget(
                                            dropDowntitle: 'Courses Name',
                                            onChanged: (value) {
                                              courseController
                                                  .selectedteacherCourse
                                                  .value = value ?? '';
                                            },
                                            hinttext: 'Web Development',
                                            value: courseController
                                                        .selectedteacherCourse
                                                        .value ==
                                                    ""
                                                ? null
                                                : courseController
                                                    .selectedteacherCourse
                                                    .value,
                                            items: courseController.courseName
                                                .map((e) {
                                              return DropdownMenuItem(
                                                value: e,
                                                child: Text(e),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                        horizonatlSpacing(
                                            width: Get.width * 0.017),
                                        DropDownWidget(
                                          dropDowntitle: 'Subject',
                                          onChanged: (value) {
                                            courseController
                                                .selectedteachersubject
                                                .value = value ?? '';
                                          },
                                          hinttext: 'Subject',
                                          value: courseController
                                                      .selectedteachersubject
                                                      .value ==
                                                  ""
                                              ? null
                                              : courseController
                                                  .selectedteachersubject.value,
                                          items: courseController.subjectName
                                              .map((e) {
                                            return DropdownMenuItem(
                                              value: e,
                                              child: Text(e),
                                            );
                                          }).toList(),
                                        )
                                      ],
                                    ),
                                    verticalSpacing(height: Get.height * 0.033),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        PopupTextField(
                                          controller: teacherController
                                              .studentNameController,
                                          text: AppString.student,
                                          hintText: 'Enter Student',
                                          onChanged: (p0) {},
                                          onTap: () {},
                                        ),
                                        horizonatlSpacing(
                                            width: Get.width * 0.017),
                                        PopupTextField(
                                          controller: teacherController
                                              .experienceController,
                                          text: AppString.experience,
                                          hintText: '1 Years',
                                          onChanged: (p0) {},
                                          onTap: () {},
                                        ),
                                        horizonatlSpacing(
                                            width: Get.width * 0.017),
                                        Container(
                                          width: Get.width * 0.17,
                                          // color: Colors.amber,
                                        )
                                      ],
                                    ),
                                    verticalSpacing(height: Get.height * 0.072),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        appButton(
                                            // Get.height * 0.053,
                                            // Get.width * 0.089,
                                            AppString.add, () async {
                                          var teacheAdd = firestore
                                              .collection('Teachers')
                                              .doc();
                                          await teacheAdd.set({
                                            'id': teacheAdd.id,
                                            'name': teacherController
                                                .teacherNameController.text,
                                            'course': courseController
                                                .selectedteacherCourse.value
                                                .toString(),
                                            'subject': courseController
                                                .selectedteachersubject.value
                                                .toString(),
                                            'student': teacherController
                                                .studentNameController.text,
                                          }).then((value) {
                                            Get.back();
                                          });
                                        }, AppColors.blueColor),
                                      ],
                                    )
                                  ],
                                )),
                          );
                        },
                      )
                    : SizedBox()
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
                      controller: teacherController.nameController,
                      onChanged: teacherController.applyFilter,
                      onTap: () {
                        teacherController.applyFilter('');
                      },
                    ),
                    Obx(() => teacherController.selectedTeacherIds.isNotEmpty
                        ? Padding(
                            padding:
                                const EdgeInsets.only(bottom: 15, right: 15),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: appButton(AppString.delete, () {
                                teacherController.deleteSelectedTeacherItems();
                              }, AppColors.color2121),
                            ),
                          )
                        : SizedBox()),
                    teacherController.dataTableWidget(context),
                  ],
                )),
          ]),
        ),
      ),
    );
  }
}
