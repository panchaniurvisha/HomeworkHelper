import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homeworkhelper/controller/assignment_Controller.dart';
import 'package:homeworkhelper/controller/login_controller.dart';
import 'package:homeworkhelper/controller/teacher_dashboard_controller.dart';
import 'package:homeworkhelper/utils/app_color.dart';
import 'package:homeworkhelper/utils/app_componet.dart';
import 'package:homeworkhelper/utils/app_style.dart';
import 'package:homeworkhelper/utils/str_const.dart';
import 'package:homeworkhelper/widgets/app_elevated_button.dart';
import 'package:homeworkhelper/widgets/custome_app_bar.dart';

import '../utils/app_images.dart';
import '../widgets/app_date_picker.dart';
import '../widgets/app_dialog_box.dart';
import '../widgets/app_text_field.dart';
import '../widgets/dropDownMenu.dart';
import '../widgets/media_query.dart';

class AssignmentScreen extends StatefulWidget {
  const AssignmentScreen({super.key});

  @override
  State<AssignmentScreen> createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  final teacherDashBoardController = Get.put(TeacherDashBoardController());
  final assignmentController = Get.put(AssignmentController());
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: appText(
                      text: AppString.assigment,
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      fontColor: AppColors.color3246),
                ),
                loginCintroller.isAdmin.value == true
                    ? SizedBox()
                    : addButton(
                        height: Get.height * 0.07,
                        width: Get.width * 0.13,
                        text: AppString.addNew,
                        onTap: () {
                          _addAssignmentDialog(context);
                        },
                      )
              ],
            ),
            verticalSpacing(height: Get.height * 0.030),
            Obx(
              () => Container(
                  height: height(context) * 0.74,
                  width: width(context) * 0.8973,
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.colorDEDE, width: 1),
                      color: AppColors.whiteColor),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SearchFieldWidget(
                        controller:
                            assignmentController.asignmentNameController,
                        onChanged: assignmentController.applyFilter,
                        onTap: () {
                          assignmentController.applyFilter('');
                        },
                      ),
                      Visibility(
                        visible: assignmentController.isAnyChecked.value,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 15, right: 15),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: appButton(
                                AppString.delete, () {}, AppColors.color2121),
                          ),
                        ),
                      ),
                      Obx(() => assignmentController.dataTableWidget(context)),
                    ],
                  )),
            ),
          ]),
        ),
      ),
    );
  }

  void _addAssignmentDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: ((context) => CustomAlertDialog(
              onTap: () {
                Get.back();
                assignmentController.selectedCourse.value = "";
                assignmentController.asignmentNameController.text = '';
                assignmentController.coursePeriodController.text = '';
                assignmentController.dueDateController.text = '';
                assignmentController.assignDateController.text = '';
                assignmentController.addTextController.text = '';
              },
              alertTitle: AppString.addAssignment,
              height: height(context) * 0.8617,
              width: Get.width * 0.597,
              mainBody: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Obx(
                          () => DropDownWidget(
                            dropDowntitle: 'Courses Name',
                            onChanged: (value) {
                              assignmentController.selectedCourse.value =
                                  value ?? '';
                            },
                            hinttext: 'Web Development',
                            value:
                                assignmentController.selectedCourse.value == ""
                                    ? null
                                    : assignmentController.selectedCourse.value,
                            items: assignmentController.coursesList.map((e) {
                              return DropdownMenuItem<String>(
                                value: e,
                                child: Text(e),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      horizonatlSpacing(width: Get.width * 0.017),
                      PopupTextField(
                        controller:
                            assignmentController.asignmentNameController,
                        text: AppString.assigment,
                        hintText: 'Assignment Name',
                        onChanged: (p0) {},
                        onTap: () {},
                        maxLines: 1,
                        Height: height(context) * 0.045,
                        Width: width(context) * 0.176,
                      ),
                      horizonatlSpacing(width: Get.width * 0.017),
                      // /*  dropdownMenu(courseController.courseName.obs.value,
                      //     AppString.coursename),
                      // dropdownMenu(courseController.assignmentName.obs.value,
                      //     AppString.assignmentsName), */
                      PopupTextField(
                        controller: assignmentController.coursePeriodController,
                        text: AppString.coursePeriod,
                        hintText: 'Enter Course Period',
                        onChanged: (p0) {},
                        onTap: () {},
                        // maxLines: 1,
                        // Height: height(context) * 0.048,
                        // Width: width(context) * 0.176,
                      ),
                    ],
                  ),
                  verticalSpacing(height: Get.height * 0.033),
                  Row(
                    children: [
                      PopupTextField(
                        controller: assignmentController.dueDateController,
                        text: AppString.dueDate,
                        hintText: 'Enter Due-Date',
                        suffixIcon: InkWell(
                          child: Icon(Icons.calendar_month_outlined,
                              color: AppColors.grayColor,
                              size: width(context) * 0.013),
                          onTap: () {
                            // Show the date picker when the icon is tapped
                          },
                        ),
                        onChanged: (p0) {},
                        onTap: () {
                          showDatePickerDialog(
                              context, assignmentController.dueDateController);
                        },
                        maxLines: 1,
                        Height: height(context) * 0.045,
                        Width: width(context) * 0.176,
                      ),
                      const Spacer(),
                      PopupTextField(
                        controller: assignmentController.assignDateController,
                        text: AppString.assignDate,
                        hintText: 'Enter Assign-Date',
                        suffixIcon: InkWell(
                          child: Icon(Icons.calendar_month_outlined,
                              color: AppColors.grayColor,
                              size: width(context) * 0.013),
                          onTap: () {},
                        ),
                        onChanged: (p0) {},
                        onTap: () {
                          showDatePickerDialog(context,
                              assignmentController.assignDateController);
                        },
                      ),
                      const Spacer(),
                      SizedBox(
                        width: Get.width * 0.17,
                      )
                    ],
                  ),
                  verticalSpacing(height: Get.height * 0.033),
                  PopupTextField(
                    Height: Get.height * 0.18,
                    Width: Get.width * 0.369,
                    maxLines: 3,
                    controller: assignmentController.addTextController,
                    text: AppString.addText,
                    hintText: 'Add your text',
                    onChanged: (p0) {},
                    onTap: () {},
                  ),
                  verticalSpacing(height: Get.height * 0.033),
                  Row(
                    children: [
                      Image.asset(
                        AppIcon.attachIcon,
                        height: Get.height * 0.027,
                      ),
                      const Text(
                        AppString.attchment,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: AppColors.blackColor),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: Get.height * 0.033),
                    child: Row(
                      children: [
                        appButton(
                            height: Get.height * 0.053,
                            width: Get.width * 0.11,
                            AppString.selectFile, () {
                          assignmentController.picksinglefile();
                        }, AppColors.blackColor),
                        SizedBox(
                          width: Get.width * 0.01,
                        ),
                        InkWell(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(() => Row(
                                      children: [
                                        Text(assignmentController
                                                .file.value?.name ??
                                            "No file selected"),
                                      ],
                                    )),
                                Obx(() => Text(
                                    assignmentController.size.value ?? "N/A")),
                              ],
                            ),
                            onTap: () {
                              assignmentController.openFile();
                            }),
                      ],
                    ),
                  ),
                  loginCintroller.isAdmin.value == true
                      ? SizedBox()
                      : Align(
                          alignment: Alignment.bottomRight,
                          child: appButton(
                              height: Get.height * 0.053,
                              width: Get.width * 0.089,
                              AppString.add, () async {
                            await assignmentController.fileStore();
                            // log('AssignmentDetail====>${assignmentController.fileLink.value}  ===>${assignmentController.assignDateController.text.trim()}, ===>${assignmentController.dueDateController.text.trim()}, ==>${assignmentController.selectedCourse.value} , ===>${assignmentController.asignmentNameController.text}');

                            var assignmentAdd =
                                firestore.collection('Assignments').doc();
                            await assignmentAdd.set({
                              'id': assignmentAdd.id,
                              'name': assignmentController
                                  .asignmentNameController.value.text
                                  .trim(),
                              'course':
                                  assignmentController.selectedCourse.value,
                              'course_period': assignmentController
                                  .coursePeriodController.text,
                              'due_date': assignmentController
                                  .dueDateController.text
                                  .trim(),
                              'assign_date': assignmentController
                                  .assignDateController.text
                                  .trim(),
                              'add_text': assignmentController
                                  .addTextController.text
                                  .trim(),
                              'file': assignmentController.fileLink.value.trim()
                            }).then((value) {
                              Get.back();
                            });
                          }, AppColors.blueColor),
                        ),
                ],
              ),
            )));
  }
}
