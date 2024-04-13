// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/app_color.dart';
import '../utils/app_componet.dart';
import '../utils/app_images.dart';
import '../utils/str_const.dart';
import '../widgets/app_dialog_box.dart';
import '../widgets/app_text_field.dart';
import '../widgets/dropDownMenu.dart';
import '../widgets/media_query.dart';

class SchoolAdminController extends GetxController {
  final RxString selectedPage = AppString.dashboard.obs;
  final CollectionReference _dataCollection =
      FirebaseFirestore.instance.collection('Teachers');
  RxList<Map<String, dynamic>> data = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> filteredData = <Map<String, dynamic>>[].obs;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final nameController = TextEditingController().obs;
  TextEditingController teacherNameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool isVisible = false;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    QuerySnapshot querySnapshot = await _dataCollection.get();
    data.assignAll(querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList());
    filteredData.assignAll(data);
  }

  void applyFilter(String query) {
    if (query.isEmpty) {
      filteredData.assignAll(data); // If the query is empty, show all data
    } else {
      filteredData.assignAll(data.where((data) {
        final name = data['name'].toString().toLowerCase();
        return name.contains(query.toLowerCase());
      }).toList()); // Otherwise, apply the filter
    }
  }

  Widget studentDataTable(BuildContext context) {
    List<Map<String, dynamic>> data = [
      {
        'Student Name': 'Savaliya',
        'Email': 'Ronaksavaliya20@gmail.com',
      },
      {
        'Student Name': 'Savaliya',
        'Email': 'Ronaksavaliya20@gmail.com',
      },
      {
        'Student Name': 'Savaliya',
        'Email': 'Ronaksavaliya20@gmail.com',
      },
      {
        'Student Name': 'Savaliya',
        'Email': 'Ronaksavaliya20@gmail.com',
      },
      {
        'Student Name': 'Savaliya',
        'Email': 'Ronaksavaliya20@gmail.com',
      },
      {
        'Student Name': 'Savaliya',
        'Email': 'Ronaksavaliya20@gmail.com',
      },
      {
        'Student Name': 'Savaliya',
        'Email': 'Ronaksavaliya20@gmail.com',
      },
      {
        'Student Name': 'Savaliya',
        'Email': 'Ronaksavaliya20@gmail.com',
      },
      // Add more rows as needed
    ];

    List<DataColumn> columns = [
      DataColumn(
        label: Text('Student Name', style: appTextStyle()),
      ),
      DataColumn(label: Text('Email', style: appTextStyle())),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SizedBox(
        width: Get.width * 223.93,
        child: DataTable(
          columns: columns,
          border: TableBorder(
            verticalInside: BorderSide(width: 1, color: AppColors.colorDEDE),
            top: BorderSide(width: 1, color: AppColors.colorDEDE),
          ),
          rows: data.map((item) {
            return DataRow(
              cells: [
                DataCell(Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(AppImages.teacherImage,
                        fit: BoxFit.cover, height: Get.height * 0.0333),
                    SizedBox(
                      width: Get.width * 0.01,
                    ),
                    Text(
                      item['Student Name'].toString(),
                      style: appTextStyle(
                          color: AppColors.color47FF,
                          fontWeight: FontWeight.w600,
                          fontSize: 12),
                    ),
                  ],
                )),
                DataCell(Text(item['Email'].toString(),
                    style: appTextStyle(
                        color: AppColors.color3246,
                        fontWeight: FontWeight.w400,
                        fontSize: 12))),
              ],
            );
          }).toList(),
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

  Widget dataTableWidget(BuildContext context) {
    List<DataColumn> columns = [
      DataColumn(
        label: Text('Teacher Name', style: appTextStyle()),
      ),
      DataColumn(label: Text('Course', style: appTextStyle())),
      DataColumn(label: Text('Subjects', style: appTextStyle())),
      DataColumn(label: Text('Students', style: appTextStyle())),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SizedBox(
        width: Get.width * 223.93,
        child: DataTable(
          columns: columns,
          // columnSpacing: Get.width * 0.16, // 7986
          border: TableBorder.all(
            color: AppColors.colorDEDE,
          ),
          rows: filteredData.asMap().entries.map((entry) {
            final Map<String, dynamic> item = entry.value;
            return DataRow(
              cells: [
                DataCell(Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Obx(
                    //   () => Checkbox(
                    //     checkColor: AppColors.whiteColor,
                    //     activeColor: AppColors.blueColor,
                    //     side: MaterialStateBorderSide.resolveWith(
                    //       (states) => const BorderSide(
                    //           width: 1.0, color: AppColors.colorB1B1),
                    //     ),
                    //     value: checkedItems[index],
                    //     onChanged: (value) {
                    //       checkedItems[index] = value ?? false;
                    //       updateIsAnyChecked();
                    //     },
                    //   ),
                    // ),
                    horizonatlSpacing(width: Get.width * 0.008),
                    ClipOval(
                      child: item['profileImage'] != null
                          ? Image.network(
                              //  item['profileImage'] ?? '',
                              item['profileImage']!,
                              fit: BoxFit.cover,
                              height: Get.height * 0.0333)
                          : Image.asset(
                              AppImages.profileImage1,
                              fit: BoxFit.cover,
                              height: Get.height * 0.0333,
                            ),
                    ),
                    SizedBox(
                      width: Get.width * 0.01,
                    ),
                    InkWell(
                      onTap: () {
                        _showTeacherInformationDialog(context, item);
                      },
                      child: Text(
                        item['name'] ?? '',
                        style: appTextStyle(
                            color: AppColors.color47FF,
                            fontWeight: FontWeight.w600,
                            fontSize: 12),
                      ),
                    ),
                  ],
                )),
                DataCell(Text(item['course'] ?? '',
                    style: appTextStyle(
                        color: AppColors.color3246,
                        fontWeight: FontWeight.w400,
                        fontSize: 12))),
                DataCell(Text(item['subject'] ?? '',
                    style: appTextStyle(
                        color: AppColors.color3246,
                        fontSize: 12,
                        fontWeight: FontWeight.w400))),
                DataCell(Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(item['student'] ?? '',
                        style: appTextStyle(
                            color: AppColors.color3246,
                            fontSize: 12,
                            fontWeight: FontWeight.w400)),
                    // horizonatlSpacing(width: Get.width * 0.07),
                    InkWell(
                      child: Image.asset(AppIcon.eyeIcon,
                          fit: BoxFit.cover, height: Get.height * 0.0416),
                      onTap: () {
                        _showStudentDialog(context);
                      },
                    ),
                  ],
                )),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showStudentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(Get.width * 0.01),
                ),
              ),
              height: Get.height * 0.573,
              width: Get.width * 0.546,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(Get.width * 0.01),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppString.student,
                          style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        InkWell(
                          child: const Icon(
                            Icons.close,
                            color: AppColors.blackColor,
                          ),
                          onTap: () => Get.back(),
                        )
                      ],
                    ),
                  ),
                  studentDataTable(context)
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showTeacherInformationDialog(BuildContext context, var teacherDoc) {
    showDialog(
        context: context,
        builder: ((context) => CustomAlertDialog(
              onTap: () {
                Get.back();
              },
              alertTitle: AppString.teacherInformation,
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
                        hintText: teacherDoc['name'],
                        onChanged: (p0) {},
                        onTap: () {},
                      ),
                      Spacer(),
                      PopupTextField(
                        readOnly: true,
                        borderColor: AppColors.colorC0C0,
                        backGrounColor: AppColors.colorD7D7,
                        controller: lastNameController,
                        text: AppString.lastName,
                        hintText: teacherDoc['name'],
                        onChanged: (p0) {},
                        onTap: () {},
                      ),
                      Spacer(),
                      PopupTextField(
                        readOnly: true,
                        borderColor: AppColors.colorC0C0,
                        backGrounColor: AppColors.colorD7D7,
                        text: AppString.coursename,
                        hintText: teacherDoc['course'],
                        onChanged: (p0) {},
                        onTap: () {},
                      ),
                      /*  dropdownMenu(
                          borderColor: AppColors.colorC0C0,
                          courseController.courseName.obs.value,
                          backGroundColor: AppColors.colorD7D7,
                          AppString.coursename), */
                    ],
                  ),
                  verticalSpacing(height: Get.height * 0.033),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PopupTextField(
                        readOnly: true,
                        keyboardType: TextInputType.emailAddress,
                        borderColor: AppColors.colorC0C0,
                        backGrounColor: AppColors.colorD7D7,
                        controller: emailController,
                        text: AppString.email,
                        hintText: teacherDoc['name'],
                        onChanged: (p0) {},
                        onTap: () {},
                      ),
                      Spacer(),
                      PopupTextField(
                        readOnly: true,
                        keyboardType: TextInputType.phone,
                        borderColor: AppColors.colorC0C0,
                        backGrounColor: AppColors.colorD7D7,
                        controller: phoneNumberController,
                        text: AppString.phone,
                        hintText: teacherDoc['name'],
                        onChanged: (p0) {},
                        onTap: () {},
                      ),
                      Spacer(),
                      SizedBox(
                        width: Get.width * 0.17,
                      ),
                    ],
                  ),
                  verticalSpacing(height: Get.height * 0.043),
                  Text(
                    AppString.teacherProfile,
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
                            '${teacherDoc['name']} ${teacherDoc['name']}',
                            style: appTextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: AppColors.grayColor,
                            ),
                          ),
                          Text(
                            teacherDoc['name'],
                            style: appTextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 10,
                              color: AppColors.grayTwo,
                            ),
                          ),
                          Text(
                            teacherDoc['name'],
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
