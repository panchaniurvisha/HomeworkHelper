// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homeworkhelper/controller/login_controller.dart';
import 'package:homeworkhelper/utils/app_color.dart';
import 'package:homeworkhelper/utils/app_images.dart';

import 'package:homeworkhelper/widgets/app_text_field.dart';

import '../utils/app_componet.dart';
import '../utils/str_const.dart';
import '../widgets/app_dialog_box.dart';
import '../widgets/media_query.dart';

class StudentController extends GetxController {
  final nameController = TextEditingController().obs;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  final authController = Get.put(LoginController());
  BuildContext? _context;
  final CollectionReference _dataCollection =
      FirebaseFirestore.instance.collection('Students');

  RxList<Map<String, dynamic>> studentData = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> filteredData = <Map<String, dynamic>>[].obs;
  var selectedIds = [].obs;

  @override
  void onInit() {
    super.onInit();
    _fetchData();
  }

  Future<void> _fetchData() async {
    QuerySnapshot querySnapshot = await _dataCollection.get();
    studentData.assignAll(querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList());
    filteredData.assignAll(studentData);
  }

  void applyFilter(String query) {
    if (query.isEmpty) {
      filteredData
          .assignAll(studentData); // If the query is empty, show all data
    } else {
      filteredData.assignAll(studentData.where((data) {
        final name = data['name'].toString().toLowerCase();
        return name.contains(query.toLowerCase());
      }).toList()); // Otherwise, apply the filter
    }
  }

  void setContext(BuildContext context) {
    _context = context;
  }

  void deleteSelectedItems() {
    for (var id in selectedIds) {
      FirebaseFirestore.instance.collection('Students').doc(id).delete();
    }

    selectedIds.clear();
  }

  Widget dataTableWidget(BuildContext context) {
    List<DataColumn> columns = [
      DataColumn(
        label: Text('Student Name', style: appTextStyle()),
      ),
      DataColumn(label: Text('Email', style: appTextStyle())),
      DataColumn(label: Text('Phone', style: appTextStyle())),
      DataColumn(
          label: Text(
        'Course',
        style: appTextStyle(),
      ))
    ];

    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          width: Get.width * 223.93,
          child: StreamBuilder<QuerySnapshot>(
              stream: _dataCollection.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: Center(child: CircularProgressIndicator()));
                }

                return DataTable(
                  columns: columns,
                  // columnSpacing: Get.width * 0.256, // 7986
                  border: TableBorder.all(
                    color: AppColors.colorDEDE,
                  ),
                  rows: filteredData.asMap().entries.map((entry) {
                    final Map<String, dynamic> item = entry.value;

                    return DataRow(
                      cells: [
                        DataCell(Row(
                          children: [
                            Obx(() => Checkbox(
                                  checkColor: AppColors.whiteColor,
                                  activeColor: AppColors.blueColor,
                                  side: MaterialStateBorderSide.resolveWith(
                                    (states) => const BorderSide(
                                        width: 1.0, color: AppColors.colorB1B1),
                                  ),
                                  value: selectedIds.contains(item['id']),
                                  onChanged: (value) {
                                    if (value!) {
                                      selectedIds.add(item['id']);
                                    } else {
                                      selectedIds.remove(item['id']);
                                    }
                                  },
                                )),
                            Image.asset(AppImages.teacherImage,
                                fit: BoxFit.cover, height: Get.height * 0.0333),
                            SizedBox(
                              width: Get.width * 0.01,
                            ),
                            InkWell(
                              child: Text(
                                item['name'].toString(),
                                style: appTextStyle(
                                    color: AppColors.color47FF,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12),
                              ),
                              onTap: () =>
                                  _showStudentInformationDialog(context, item),
                            ),
                          ],
                        )),
                        DataCell(Text(item['mail'].toString(),
                            style: appTextStyle(
                                color: AppColors.color3246,
                                fontWeight: FontWeight.w400,
                                fontSize: 12))),
                        DataCell(
                          Text(item['phone'].toString(),
                              style: appTextStyle(
                                  color: AppColors.color3246,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400)),
                        ),
                        DataCell(
                          Text(item['course'].toString(),
                              style: appTextStyle(
                                  color: AppColors.color3246,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400)),
                        ),
                      ],
                    );
                  }).toList(),
                );
              }),
        ),
      ),
    );
  }

  TextStyle appTextStyle(
      {Color? color, FontWeight? fontWeight, double? fontSize}) {
    return TextStyle(
        overflow: TextOverflow.ellipsis,
        color: color ?? AppColors.blackColor,
        fontWeight: fontWeight ?? FontWeight.w600,
        fontSize: fontSize ?? 14);
  }

  void _showStudentInformationDialog(
      BuildContext context, Map<String, dynamic> item) {
    showDialog(
        context: context,
        builder: ((context) => CustomAlertDialog(
              onTap: () {
                Get.back();
              },
              alertTitle: AppString.studentInformation,
              height: Get.height * 0.573,
              width: Get.width * 0.597,
              mainBody: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PopupTextField(
                        readOnly: true,
                        borderColor: AppColors.colorC0C0,
                        backGrounColor: AppColors.colorD7D7,
                        controller: firstNameController,
                        text: AppString.firstName,
                        hintText: item['name'],
                        onChanged: (p0) {},
                        onTap: () {},
                      ),
                      PopupTextField(
                        readOnly: true,
                        borderColor: AppColors.colorC0C0,
                        backGrounColor: AppColors.colorD7D7,
                        controller: lastNameController,
                        text: AppString.lastName,
                        hintText: item['lastname'],
                        onChanged: (p0) {},
                        onTap: () {},
                      ),
                      PopupTextField(
                        readOnly: true,
                        borderColor: AppColors.colorC0C0,
                        backGrounColor: AppColors.colorD7D7,
                        controller: dateOfBirthController,
                        text: AppString.dateOfBirth,
                        hintText: item['dob'],
                        onChanged: (p0) {},
                        onTap: () {},
                      ),
                    ],
                  ),
                  verticalSpacing(height: Get.height * 0.033),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PopupTextField(
                        readOnly: true,
                        borderColor: AppColors.colorC0C0,
                        backGrounColor: AppColors.colorD7D7,
                        controller: emailController,
                        text: AppString.email,
                        hintText: item['mail'],
                        onChanged: (p0) {},
                        onTap: () {},
                      ),
                      PopupTextField(
                        readOnly: true,
                        borderColor: AppColors.colorC0C0,
                        backGrounColor: AppColors.colorD7D7,
                        controller: phoneNumberController,
                        text: AppString.phone,
                        hintText: item['phone'],
                        onChanged: (p0) {},
                        onTap: () {},
                      ),
                      PopupTextField(
                        readOnly: true,
                        borderColor: AppColors.colorC0C0,
                        backGrounColor: AppColors.colorD7D7,
                        text: AppString.coursename,
                        hintText: item['course'],
                        onChanged: (p0) {},
                        onTap: () {},
                      ),
                    ],
                  ),
                  verticalSpacing(height: Get.height * 0.043),
                  Text(
                    AppString.studentProfile,
                    style:
                        appTextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                  verticalSpacing(height: Get.height * 0.033),
                  Row(
                    children: [
                      ClipRRect(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.grayTwo,
                              width:
                                  2.0, // You can change the border width here
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            AppImages.teacherImage,
                            fit: BoxFit.cover,
                            height: Get.height * 0.08,
                          ),
                        ),
                      ),
                      SizedBox(width: width(context) * 0.01),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${item['name']}  ${item['lastname']}',
                            style: appTextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: AppColors.grayColor,
                            ),
                          ),
                          Text(
                            item['mail'],
                            style: appTextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 10,
                              color: AppColors.grayTwo,
                            ),
                          ),
                          Text(
                            item['phone'],
                            style: appTextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 10,
                              color: AppColors.grayTwo,
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            )));
  }
}
