import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homeworkhelper/controller/login_controller.dart';
import 'package:homeworkhelper/controller/school_sdmin_controller.dart';
import 'package:homeworkhelper/utils/app_color.dart';
import 'package:homeworkhelper/utils/app_componet.dart';
import 'package:homeworkhelper/utils/app_images.dart';
import 'package:homeworkhelper/utils/str_const.dart';
import 'package:homeworkhelper/widgets/app_dialog_box.dart';
import 'package:homeworkhelper/widgets/app_elevated_button.dart';
import 'package:homeworkhelper/widgets/app_text_field.dart';
import 'package:homeworkhelper/widgets/dropDownMenu.dart';

class TeacherController extends GetxController {
  final schoolSdminController = Get.put(SchoolAdminController());
  final loginController = Get.put(LoginController());
  final CollectionReference _dataCollection =
      FirebaseFirestore.instance.collection('Teachers');
  TextEditingController nameController = TextEditingController();
  TextEditingController teacherNameController = TextEditingController();
  TextEditingController studentNameController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  RxList<Map<String, dynamic>> data = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> filteredData = <Map<String, dynamic>>[].obs;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  var selectedteacherCourse = ''.obs;
  var selectedteachersubject = ''.obs;
  var selectedCourseName = ''.obs;
  var selectedTeacherIds = [].obs;
  final RxList<bool> checkedItems = List.generate(5, (index) => false).obs;
  RxBool isAnyChecked = false.obs;
  var courseList = [].obs;
  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  // void updateIsAnyChecked() {
  //   final RxList<bool> checkedItems = List.generate(6, (index) => false).obs;
  //   isAnyChecked.value = checkedItems.any((isChecked) => isChecked);
  // }

  void deleteSelectedTeacherItems() {
    for (var id in selectedTeacherIds) {
      _dataCollection.doc(id).delete();
    }

    selectedTeacherIds.clear();
  }

  void enrollStudentInCourse(String courseName) async {
    try {
      QuerySnapshot coursesSnapshot = await firestore
          .collection('Teachers')
          .where('course', isEqualTo: courseName)
          .get();

      if (coursesSnapshot.docs.isNotEmpty) {
        String courseId = coursesSnapshot.docs.first.id;

        QuerySnapshot studentsSnapshot = await firestore
            .collection('Students')
            .where('course', isEqualTo: courseName)
            .get();

        List<String> studentIds = [];
        studentsSnapshot.docs.forEach((studentDoc) {
          studentIds.add(studentDoc.id);
        });

        await firestore.collection('Teachers').doc(courseId).update({
          'students': FieldValue.arrayUnion(studentIds),
        });

        WriteBatch batch = firestore.batch();
        studentIds.forEach((studentId) {
          DocumentReference studentRef =
              firestore.collection('Students').doc(studentId);
          batch.update(studentRef, {'course': courseName});
        });
        await batch.commit();
      } else {}
    } catch (e) {}
  }

  Future<void> fetchData() async {
    QuerySnapshot querySnapshot = await _dataCollection.get();
    data.assignAll(querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList());
    filteredData.assignAll(data);

    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('Courses').get();

    List<String> items = [];

    snapshot.docs.forEach((doc) {
      items.add(doc.get(
          'course')); // Adjust 'field_name' to your field name in Firestore
    });

    courseList.value = items;
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

  Widget dataTableWidget(BuildContext context) {
    List<DataColumn> columns = [
      DataColumn(
        label: Text('Teacher Name', style: appTextStyle()),
      ),
      DataColumn(label: Text('Course', style: appTextStyle())),
      // DataColumn(label: Text('Subjects', style: appTextStyle())),
      DataColumn(label: Text('Students', style: appTextStyle())),
    ];
    return Expanded(
      flex: 1,
      child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SizedBox(
            width: Get.width * 223.93,
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Teachers')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                        child: Center(
                            child: CircularProgressIndicator(
                                color: AppColors.color47FF)));
                  }

                  return DataTable(
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
                              Obx(
                                () => Checkbox(
                                  checkColor: AppColors.whiteColor,
                                  activeColor: AppColors.blueColor,
                                  side: MaterialStateBorderSide.resolveWith(
                                    (states) => const BorderSide(
                                        width: 1.0, color: AppColors.colorB1B1),
                                  ),
                                  value:
                                      selectedTeacherIds.contains(item['id']),
                                  onChanged: (value) {
                                    if (value!) {
                                      selectedTeacherIds.add(item['id']);
                                    } else {
                                      selectedTeacherIds.remove(item['id']);
                                    }
                                  },
                                ),
                              ),
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
                                  showDialog(
                                    context: context,
                                    builder: (context) => CustomAlertDialog(
                                        height: Get.height * 0.465,
                                        width: Get.width * 0.597,
                                        alertTitle: item['name'],
                                        onTap: () {
                                          Get.back();
                                          teacherNameController.text = '';

                                          selectedCourseName.value = '';

                                          experienceController.text = '';
                                        },
                                        mainBody: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                PopupTextField(
                                                  controller:
                                                      teacherNameController,
                                                  text: AppString.teacherName,
                                                  hintText: item['name'],
                                                  onChanged: (p0) {},
                                                  onTap: () {},
                                                ),
                                                // Spacer(),
                                                horizonatlSpacing(
                                                    width: Get.width * 0.017),

                                                Obx(
                                                  () => DropDownWidget(
                                                    dropDowntitle:
                                                        'Course Name',
                                                    onChanged: (value) {
                                                      selectedCourseName.value =
                                                          value ?? '';
                                                    },
                                                    hinttext: 'Course Name',
                                                    value: selectedCourseName
                                                                .value ==
                                                            ""
                                                        ? null
                                                        : selectedCourseName
                                                            .value,
                                                    items: courseList.map((e) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: e,
                                                        child: Text(e),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),

                                                horizonatlSpacing(
                                                    width: Get.width * 0.017),
                                                SizedBox(
                                                  width: Get.width * 0.17,
                                                  // color: Colors.amber,
                                                )
                                                /* dropdownMenu(
                                                      courseController.subject.obs.value,
                                                      AppString.subjectName), */
                                              ],
                                            ),
                                            verticalSpacing(
                                                height: Get.height * 0.033),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                PopupTextField(
                                                  controller:
                                                      studentNameController,
                                                  text: AppString.student,
                                                  hintText: 'Enter Student',
                                                  onChanged: (p0) {},
                                                  onTap: () {},
                                                ),
                                                horizonatlSpacing(
                                                    width: Get.width * 0.017),
                                                PopupTextField(
                                                  controller:
                                                      experienceController,
                                                  text: AppString.experience,
                                                  hintText: '1 Years',
                                                  onChanged: (p0) {},
                                                  onTap: () {},
                                                ),
                                                horizonatlSpacing(
                                                    width: Get.width * 0.017),
                                                SizedBox(
                                                  width: Get.width * 0.17,
                                                  // color: Colors.amber,
                                                )
                                              ],
                                            ),
                                            verticalSpacing(
                                                height: Get.height * 0.072),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                loginController.isAdmin.value ==
                                                        true
                                                    ? SizedBox()
                                                    : appButton(AppString.edit,
                                                        () {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'Teachers')
                                                            .doc(item['id'])
                                                            .update({
                                                          'name':
                                                              teacherNameController
                                                                  .value.text
                                                                  .trim(),
                                                          'course':
                                                              selectedCourseName
                                                                  .value
                                                                  .trim(),
                                                          'experience':
                                                              experienceController
                                                                  .value.text
                                                                  .trim()
                                                        }).then((value) =>
                                                                Get.back());
                                                      }, AppColors.blueColor),
                                              ],
                                            )
                                          ],
                                        )),
                                  );
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
                                    fit: BoxFit.cover,
                                    height: Get.height * 0.0416),
                                onTap: () {
                                  _showStudentDialog(context);
                                },
                              ),
                            ],
                          )),
                        ],
                      );
                    }).toList(),
                  );
                }),
          )),
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
                        const Text(
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
                  studentDataTable(
                    context,
                  )
                ],
              ),
            ),
          ),
        );
        // Adjust this based on your actual dialog widget
      },
    );
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

    return Expanded(
      flex: 1,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          // width: Get.width * 223.93,
          width: Get.width * 0.546,
          child: DataTable(
            columns: columns,
            border: const TableBorder(
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
      ),
    );
  }

  TextStyle appTextStyle({
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
  }) {
    return TextStyle(
        color: color ?? AppColors.blackColor,
        fontWeight: fontWeight ?? FontWeight.w600,
        overflow: TextOverflow.ellipsis,
        fontSize: fontSize ?? 14);
  }

  @override
  void dispose() {
    nameController.clear();
    super.dispose();
  }
}
