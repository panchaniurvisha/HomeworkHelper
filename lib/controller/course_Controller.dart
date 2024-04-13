import 'dart:convert';
import 'dart:developer';
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homeworkhelper/controller/login_controller.dart';
import 'package:homeworkhelper/model/course_model.dart';
import 'package:homeworkhelper/utils/app_color.dart';
import 'package:homeworkhelper/utils/app_componet.dart';
import 'package:homeworkhelper/utils/app_images.dart';
import 'package:homeworkhelper/utils/str_const.dart';
import 'package:homeworkhelper/widgets/app_dialog_box.dart';
import 'package:homeworkhelper/widgets/app_elevated_button.dart';
import 'package:homeworkhelper/widgets/app_text_field.dart';
import 'package:homeworkhelper/widgets/dropDownMenu.dart';

import '../widgets/app_date_picker.dart';
import '../widgets/media_query.dart';

class CourseController extends GetxController {
  RxBool isChecked = false.obs;
  final loginController = Get.put(LoginController());

  TextEditingController teacherController = TextEditingController();
  TextEditingController classAssignmentController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();
  TextEditingController assignDateController = TextEditingController();
  TextEditingController coursePeriodController = TextEditingController();
  TextEditingController courseController1 = TextEditingController();
  TextEditingController addTextController = TextEditingController();
  TextEditingController coursePeriod1Controller = TextEditingController();
  TextEditingController teacher1Controller = TextEditingController();
  TextEditingController courseNameController = TextEditingController();
  final RxList<bool> checkedItems = List.generate(6, (index) => false).obs;
  RxBool isAnyChecked = false.obs;
  TextEditingController studentsListController = TextEditingController();
  TextEditingController assignmentNameController = TextEditingController();
  var selectedAssignmentCourseName = ''.obs;
  var fileLink = ''.obs;
  Rx<PlatformFile?> file = Rx<PlatformFile?>(null);
  RxString size = ''.obs;
  UploadTask? uploadTask;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  CoursesModel coursesModel = CoursesModel();

  @override
  void onInit() {
    fetchData();
    fetchCourseData();
    super.onInit();
  }

  void updateIsAnyChecked() {
    isAnyChecked.value = checkedItems.any((isChecked) => isChecked);
  }

  Future<void> picksinglefile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile selectedFile = result.files.first;
      if (selectedFile.size <= 5 * 1024 * 1024) {
        file.value = selectedFile;
        final kb = file.value!.size / 1024;
        final mb = kb / 1024;
        final fileSize = (mb >= 1)
            ? '${mb.toStringAsFixed(2)} MB'
            : '${kb.toStringAsFixed(2)} KB';

        update();
      } else {
        // Fluttertoast.showToast(
        //     msg: 'Please select a file with a size of 5 MB or less.',
        //     backgroundColor: AppColors.color4040,
        //     textColor: AppColors.whiteColor,
        //     toastLength: Toast.LENGTH_LONG,
        //     gravity: ToastGravity.CENTER);
        Get.snackbar(
          'File Size Limit Exceeded',
          'Please select a file with a size of 5 MB or less.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  void enrollStudentInCourse(String courseName) async {
    try {
      QuerySnapshot coursesSnapshot = await firestore
          .collection('Courses')
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

        await firestore.collection('Courses').doc(courseId).update({
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

  void openFile() async {
    if (file.value != null) {
      if (file.value!.bytes != null) {
        final Uint8List fileBytes = file.value!.bytes!;
        String extension = file.value!.name!.split('.').last.toLowerCase();
        List<String> supportedTypes = [
          'pdf',
          'png',
          'jpg',
          'jpeg',
          'txt',
          'doc',
          'docx',
          'dart'
        ];
        final blob = html.Blob([fileBytes]);
        if (supportedTypes.contains(extension)) {
          if (extension == 'pdf') {
            final pdfViewerUrl = 'https://example.com/pdf-viewer?url=';
            final pdfUrl = Uri.dataFromBytes(
              fileBytes,
              mimeType: 'application/pdf',
            ).toString();
            html.window.open('$pdfViewerUrl$pdfUrl', '_blank');
          } else if (['png', 'jpg', 'jpeg'].contains(extension)) {
            try {
              final blob = html.Blob([fileBytes], 'image/$extension');
              final imageUrl = html.Url.createObjectUrlFromBlob(blob);
              html.window.open(imageUrl, '_blank');
            } catch (e) {
              Get.snackbar(
                'Error',
                'Failed to open the image: $e',
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          } else if (['txt', 'doc', 'docx', 'dart'].contains(extension)) {
            final url = html.Url.createObjectUrlFromBlob(blob);
            html.window.open(url, '_blank');
          }
        } else {
          Get.snackbar(
            'Error',
            'Unsupported file type: $extension',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        // Handle the case when the file bytes are null
        Get.snackbar(
          'Error',
          'File content is null',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  fileStore() async {
    final path = 'files/${file.value?.name}';
    final Uint8List? bytes1 = file.value?.bytes;

    final ref = FirebaseStorage.instance.ref().child(path);
    debugPrint('reffff====>$ref');
    uploadTask = ref.putData(bytes1!);
    debugPrint('uploadTask====>$uploadTask');
    final snapshot = await uploadTask!.whenComplete(() {
      debugPrint('working On===>');
    });

    debugPrint('snapshot====>$snapshot');
    final fileurlDownload = await snapshot.ref.getDownloadURL();
    fileLink.value = fileurlDownload;

    debugPrint('FileUrlDownload===>${fileLink.value}');
  }

  var selectedteacherCourse = ''.obs;
  var selectedCourse = ''.obs;
  var selectedteachersubject = ''.obs;

  var selectedTeacherName = ''.obs;
  var selectedCourseName = ''.obs;
  var selectedStudentName = ''.obs;
  var teacherList = [].obs;
  var courseList = [].obs;
  var studentList = [].obs;
  var coursePeriodList = [].obs;
  var selectedCoursePeriod = ''.obs;

  void selectedTeacher(String value) {
    selectedTeacherName.value = value;
  }

  Future<void> fetchData() async {
    // Fetch data from Firestore
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('Teachers').get();

    List<String> items = [];

    snapshot.docs.forEach((doc) {
      items.add(doc
          .get('name')); // Adjust 'field_name' to your field name in Firestore
    });

    teacherList.value = items;
  }

  Future<void> fetchCourseData() async {
    // Fetch data from Firestore
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('Courses').get();

    List<String> courseName = [];
    List<String> coursePeriod = [];
    List<String> sudentListt = [];

    snapshot.docs.forEach((doc) {
      courseName.add(doc.get('course'));
      coursePeriod.add(doc.get('course_period'));
      sudentListt.add(doc.get('students'));
      // Adjust 'field_name' to your field name in Firestore
    });

    studentList.value = sudentListt;

    courseList.value = courseName;
    coursePeriodList.value = coursePeriod;
  }

  var courseName = [
    "Web Development",
    "App Development",
    "Game Development",
    "Web-App Development"
  ].obs;

  var subjectName = [
    'Maths',
    'States',
    'Economics',
    'History',
    'Social ',
  ].obs;

  var assignmentName = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ].obs;
  var classPeriod = [
    'First',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ].obs;
  var subject = [
    'Data Structure',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ].obs;
  var experience = [
    'Mayur rathi',
    'item2',
    'item3',
  ].obs;
  var student = [
    'Mayur',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ].obs;

  var selectedTeacherId = ''.obs;

  void selectedteacherCourseValue(String value) {
    selectedteacherCourse.value = value;
  }

  void selectedCourseValue(String value) {
    selectedCourse.value = value;
  }

  void selectedteachersubjectValue(String value) {
    selectedteachersubject.value = value;
  }

  Widget dataTableWidget(BuildContext context) {
    List<DataColumn> columns = [
      DataColumn(
        label: Text('Course', style: appTextStyle()),
      ),
      DataColumn(label: Text('Courses Period', style: appTextStyle())),
      DataColumn(label: Text('Students', style: appTextStyle())),
      DataColumn(label: Text('Assignment', style: appTextStyle())),
    ];

    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          width: Get.width * 223.93,
          child: StreamBuilder<QuerySnapshot>(
              stream: firestore.collection('Courses').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: Center(child: CircularProgressIndicator()));
                }
                List<DataRow> rows = [];

                snapshot.data!.docs.forEach((doc) {
                  String courseName = doc['course'];
                  String coursePeriod = doc['course_period'];
                  var courseID = doc['id'];

                  List studentList = doc['students'];

                  rows.add(DataRow(cells: [
                    DataCell(Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /* Obx(
                              () => Checkbox(
                                checkColor: AppColors.whiteColor,
                                activeColor: AppColors.blueColor,
                                side: MaterialStateBorderSide.resolveWith(
                                  (states) => const BorderSide(
                                      width: 1.0, color: AppColors.colorB1B1),
                                ),
                                value: checkedItems[index],
                                onChanged: (value) {
                                  checkedItems[index] = value ?? false;
                                  updateIsAnyChecked();
                                },
                              ),
                            ), */

                        Flexible(
                          child: Text(courseName,
                              style: appTextStyle(
                                  color: AppColors.color47FF,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12)),
                        ),
                        horizonatlSpacing(width: Get.width * 0.008),
                        InkWell(
                          onTap: () {},
                          child: Image.asset(
                            AppIcon.basecodeIcon,
                            height: Get.height * 0.05,
                            width: Get.width * 0.023,
                          ),
                        )
                      ],
                    )),
                    DataCell(Text(coursePeriod,
                        style: appTextStyle(
                            color: AppColors.color3246,
                            fontSize: 12,
                            fontWeight: FontWeight.w400))),
                    DataCell(Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(studentList.length.toString(),
                            style: appTextStyle(
                                color: AppColors.color3246,
                                fontSize: 12,
                                fontWeight: FontWeight.w400)),
                        horizonatlSpacing(width: Get.width * 0.07),
                        InkWell(
                          child: Image.asset(AppIcon.eyeIcon,
                              fit: BoxFit.cover, height: Get.height * 0.0416),
                          onTap: () => _showStudentDialog(
                              context, studentList, courseID),
                        )
                      ],
                    )),
                    DataCell(Row(
                      children: [
                        InkWell(
                            child: Text(
                              '+ Add',
                              style: appTextStyle(
                                  color: AppColors.color3246,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            onTap: () {
                              if (loginController.isAdmin.value == true) {
                                Get.snackbar(
                                    'Alert', 'Your Are Not Permission for Add');
                              } else {
                                fileStore();
                                _addAssignmentDialog(context, doc);
                              }
                            }),
                        SizedBox(width: Get.width * 0.01),
                        InkWell(
                          onTap: () {
                            if (loginController.isAdmin.value == true) {
                              Get.snackbar(
                                  'Alert', 'Your Are Not Permission for edit');
                            } else {
                              showDialog(
                                  context: context,
                                  builder: ((context) => CustomAlertDialog(
                                        onTap: () {
                                          Get.back();
                                        },
                                        alertTitle: AppString.webDevelopment,
                                        height: Get.height * 0.437,
                                        width: Get.width * 0.597,
                                        mainBody: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Obx(
                                                  () => DropDownWidget(
                                                    dropDowntitle:
                                                        AppString.coursename,
                                                    onChanged: (value) {
                                                      selectedCourseName.value =
                                                          value ?? '';
                                                    },
                                                    hinttext: doc['course'],
                                                    value: selectedCourseName
                                                                .value ==
                                                            ""
                                                        ? null
                                                        : selectedCourseName
                                                            .value,
                                                    items: courseController
                                                        .courseList
                                                        .map((e) {
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
                                                dropdownMenu(
                                                    courseController
                                                        .classPeriod.obs.value,
                                                    AppString.classPeriod),
                                                horizonatlSpacing(
                                                    width: Get.width * 0.017),
                                                Obx(
                                                  () => DropDownWidget(
                                                    dropDowntitle:
                                                        AppString.student,
                                                    onChanged: (value) {
                                                      selectedStudentName
                                                          .value = value ?? '';
                                                    },
                                                    hinttext: AppString.student,
                                                    value: selectedStudentName
                                                                .value ==
                                                            ""
                                                        ? null
                                                        : selectedStudentName
                                                            .value,
                                                    items: studentList.map((e) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: e,
                                                        child: Text(e),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
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
                                                  controller: teacherController,
                                                  text: AppString.teacher,
                                                  hintText: 'Nikunj',
                                                  onChanged: (p0) {},
                                                  onTap: () {},
                                                ),
                                                horizonatlSpacing(
                                                    width: Get.width * 0.017),
                                                PopupTextField(
                                                  controller:
                                                      classAssignmentController,
                                                  text:
                                                      AppString.classAssignment,
                                                  hintText: 'Maths',
                                                  onChanged: (p0) {},
                                                  onTap: () {},
                                                ),
                                                horizonatlSpacing(
                                                    width: Get.width * 0.017),
                                                PopupTextField(
                                                  controller:
                                                      assignDateController,
                                                  text: AppString
                                                      .assignmentDueDate,
                                                  hintText: '22/032024',
                                                  onChanged: (p0) {},
                                                  onTap: () {
                                                    showDatePickerDialog(
                                                        context,
                                                        assignDateController);
                                                  },
                                                ),
                                              ],
                                            ),
                                            verticalSpacing(
                                                height: Get.height * 0.043),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                appButton(AppString.delete,
                                                    () {}, AppColors.color2121),
                                                appButton(AppString.edit, () {},
                                                    AppColors.blueColor),
                                              ],
                                            )
                                          ],
                                        ),
                                      )));
                            }
                          },
                          child: Image.asset(AppIcon.editIcon,
                              fit: BoxFit.cover, height: Get.height * 0.0416),
                        ),
                      ],
                    )),
                  ]));
                });
                return DataTable(
                    columns: columns,
                    // columnSpacing: Get.width * 0.081, // 7986
                    border: TableBorder.all(
                      color: AppColors.colorDEDE,
                    ),
                    rows: rows

                    /*  data.asMap().entries.map((entry) {
                    final int index = entry.key;
                    final Map<String, dynamic> item = entry.value;
                    return DataRow(
                      cells: [
                        DataCell(Row(
                          children: [
                            Obx(
                              () => Checkbox(
                                checkColor: AppColors.whiteColor,
                                activeColor: AppColors.blueColor,
                                side: MaterialStateBorderSide.resolveWith(
                                  (states) => const BorderSide(
                                      width: 1.0, color: AppColors.colorB1B1),
                                ),
                                value: checkedItems[index],
                                onChanged: (value) {
                                  checkedItems[index] = value ?? false;
                                  updateIsAnyChecked();
                                },
                              ),
                            ),
                            horizonatlSpacing(width: Get.width * 0.008),
                            Flexible(
                              child: Text(item['Course'].toString(),
                                  style: appTextStyle(
                                      color: AppColors.color47FF,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12)),
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () {},
                              child: Image.asset(
                                AppIcon.basecodeIcon,
                                height: Get.height * 0.05,
                                width: Get.width * 0.023,
                              ),
                            )
                          ],
                        )),
                        DataCell(Text(item['Courses Period'].toString(),
                            style: appTextStyle(
                                color: AppColors.color3246,
                                fontSize: 12,
                                fontWeight: FontWeight.w400))),
                        DataCell(Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(item['Students'].toString(),
                                style: appTextStyle(
                                    color: AppColors.color3246,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400)),
                            horizonatlSpacing(width: Get.width * 0.07),
                            InkWell(
                              child: Image.asset(AppIcon.eyeIcon,
                                  fit: BoxFit.cover,
                                  height: Get.height * 0.0416),
                              onTap: () => _showStudentDialog(context),
                            )
                          ],
                        )),
                        DataCell(Row(
                          children: [
                            InkWell(
                                child: Text(
                                  '+ Add',
                                  style: appTextStyle(
                                      color: AppColors.color3246,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                onTap: () {
                                  if (loginController.isAdmin.value == true) {
                                    Get.snackbar('Alert',
                                        'Your Are Not Permission for Add');
                                  } else {
                                    _addAssignmentDialog(context);
                                  }
                                }),
                            SizedBox(width: Get.width * 0.01),
                            InkWell(
                              onTap: () {
                                if (loginController.isAdmin.value == true) {
                                  Get.snackbar('Alert',
                                      'Your Are Not Permission for edit');
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: ((context) => CustomAlertDialog(
                                            onTap: () {},
                                            alertTitle:
                                                AppString.webDevelopment,
                                            height: Get.height * 0.437,
                                            width: Get.width * 0.597,
                                            mainBody: Column(
                                              children: [
                                                Row(
                                                  // mainAxisAlignment:
                                                  //     MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: dropdownMenu(
                                                          courseController
                                                              .courseName
                                                              .obs
                                                              .value,
                                                          AppString.coursename),
                                                    ),
                                                    horizonatlSpacing(
                                                        width:
                                                            Get.width * 0.017),
                                                    Expanded(
                                                      child: dropdownMenu(
                                                          courseController
                                                              .classPeriod
                                                              .obs
                                                              .value,
                                                          AppString
                                                              .classPeriod),
                                                    ),
                                                    horizonatlSpacing(
                                                        width:
                                                            Get.width * 0.017),
                                                    Expanded(
                                                      child: dropdownMenu(
                                                          courseController
                                                              .student
                                                              .obs
                                                              .value,
                                                          AppString.student),
                                                    )
                                                  ],
                                                ),
                                                verticalSpacing(
                                                    height: Get.height * 0.033),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: PopupTextField(
                                                        controller:
                                                            teacherController,
                                                        text: AppString.teacher,
                                                        hintText: 'Nikunj',
                                                        onChanged: (p0) {},
                                                        onTap: () {},
                                                      ),
                                                    ),
                                                    horizonatlSpacing(
                                                        width:
                                                            Get.width * 0.017),
                                                    Expanded(
                                                      child: PopupTextField(
                                                        controller:
                                                            classAssignmentController,
                                                        text: AppString
                                                            .classAssignment,
                                                        hintText: 'Maths',
                                                        onChanged: (p0) {},
                                                        onTap: () {},
                                                      ),
                                                    ),
                                                    horizonatlSpacing(
                                                        width:
                                                            Get.width * 0.017),
                                                    Expanded(
                                                      child: PopupTextField(
                                                        controller:
                                                            assignDateController,
                                                        text: AppString
                                                            .assignmentDueDate,
                                                        hintText: '22/032024',
                                                        onChanged: (p0) {},
                                                        onTap: () {
                                                          showDatePickerDialog(
                                                              context,
                                                              assignDateController);
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                verticalSpacing(
                                                    height: Get.height * 0.043),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    appButton(
                                                        AppString.delete,
                                                        () {},
                                                        AppColors.color2121),
                                                    appButton(
                                                        AppString.edit,
                                                        () {},
                                                        AppColors.blueColor),
                                                  ],
                                                )
                                              ],
                                            ),
                                          )));
                                }
                              },
                              child: Image.asset(AppIcon.editIcon,
                                  fit: BoxFit.cover,
                                  height: Get.height * 0.0416),
                            ),
                          ],
                        )),
                      ],
                    );
                  }).toList(),
                 */
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

  void _addAssignmentDialog(BuildContext context, var doc) {
    showDialog(
        context: context,
        builder: ((context) => CustomAlertDialog(
              onTap: () {
                Get.back();
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
                      PopupTextField(
                        readOnly: true,
                        text: AppString.assignmentsName,
                        hintText: doc['course'],
                        onChanged: (p0) {},
                        onTap: () {},
                      ),
                      /*  Obx(
                        () => DropDownWidget(
                          dropDowntitle: AppString.coursename,
                          onChanged: (value) {
                            selectedAssignmentCourseName.value = value ?? '';
                          },
                          hinttext: 'Course Name',
                          value: selectedAssignmentCourseName.value == ""
                              ? null
                              : selectedAssignmentCourseName.value,
                          items: courseList.map((e) {
                            return DropdownMenuItem<String>(
                              value: e,
                              child: Text(e),
                            );
                          }).toList(),
                        ),
                      ), */
                      PopupTextField(
                        controller: assignmentNameController,
                        text: AppString.assignmentsName,
                        hintText: 'Enter Assignment Name',
                        onChanged: (p0) {},
                        onTap: () {},
                      ),
                      PopupTextField(
                        controller: coursePeriodController,
                        text: AppString.coursePeriod,
                        hintText: 'Enter Course Period',
                        onChanged: (p0) {},
                        onTap: () {},
                      ),
                    ],
                  ),
                  verticalSpacing(height: Get.height * 0.033),
                  Row(
                    children: [
                      PopupTextField(
                        keyboardType: TextInputType.datetime,
                        controller: dueDateController,
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
                          showDatePickerDialog(context, dueDateController);
                        },
                      ),
                      const Spacer(),
                      PopupTextField(
                        keyboardType: TextInputType.datetime,
                        controller: assignDateController,
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
                          showDatePickerDialog(context, assignDateController);
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
                    controller: addTextController,
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
                          picksinglefile();
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
                                        Text(file.value?.name ??
                                            "No file selected"),
                                      ],
                                    )),
                                Obx(() => Text(size.value ?? "N/A")),
                              ],
                            ),
                            onTap: () {
                              openFile();
                            }),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: appButton(
                        height: Get.height * 0.053,
                        width: Get.width * 0.089,
                        AppString.add, () async {
                      var assignmentAdd =
                          firestore.collection('Assignments').doc();
                      await assignmentAdd.set({
                        'id': assignmentAdd.id,
                        'name': assignmentNameController.value.text.trim(),
                        'course': doc['course'],
                        'course_period': coursePeriodController.text,
                        'due_date': dueDateController.text.trim(),
                        'assign_date': assignDateController.text.trim(),
                        'add_text': addTextController.text.trim(),
                        'file': fileLink.value.trim()
                      }).then((value) {
                        Get.back();
                      });
                    }, AppColors.blueColor),
                  ),
                ],
              ),
            )));
  }

  void _showStudentDialog(
      BuildContext context, List<dynamic> studentIds, var courseID) {
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
                  studentDataTable(context, studentIds, courseID)
                ],
              ),
            ),
          ),
        );
        // Adjust this based on your actual dialog widget
      },
    );
  }

  Future<List<Map<String, String>>> fetchStudentsDetails(
      List<dynamic> studentIds, String courseID) async {
    List<Map<String, String>> students = [];
    for (String studentId in studentIds) {
      DocumentSnapshot studentSnapshot = await FirebaseFirestore.instance
          .collection('Students')
          .doc(studentId)
          .get();
      if (studentSnapshot.exists) {
        students.add({
          'name': studentSnapshot['name'],
          'mail': studentSnapshot['mail'],
        });
      } else {
        await FirebaseFirestore.instance
            .collection('Courses')
            .doc(courseID)
            .update({
          'students': FieldValue.arrayRemove([studentId]),
        });
      }
    }
    return students;
  }

  Widget studentDataTable(BuildContext context, List studentId, var courseID) {
    List<DataColumn> columns = [
      DataColumn(
        label: Text('Student Name', style: appTextStyle()),
      ),
      DataColumn(label: Text('Email', style: appTextStyle())),
    ];

    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          // width: Get.width * 223.93,
          width: Get.width * 0.546,
          child: FutureBuilder<List<Map<String, String>>>(
              future: fetchStudentsDetails(studentId, courseID),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return DataTable(
                    border: const TableBorder(
                      verticalInside:
                          BorderSide(width: 1, color: AppColors.colorDEDE),
                      top: BorderSide(width: 1, color: AppColors.colorDEDE),
                      bottom: BorderSide(width: 1, color: AppColors.colorDEDE),
                    ),
                    columns: columns,
                    rows: snapshot.data!
                        .map((student) => DataRow(cells: [
                              DataCell(Row(
                                children: [
                                  Image.asset(AppImages.teacherImage,
                                      fit: BoxFit.cover,
                                      height: Get.height * 0.0333),
                                  SizedBox(
                                    width: Get.width * 0.01,
                                  ),
                                  Text(student['name'] ?? '',
                                      style: appTextStyle(
                                          color: AppColors.color47FF,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12)),
                                ],
                              )),
                              DataCell(Text(student['mail'] ?? '')),
                            ]))
                        .toList(),
                  );
                }
              }),
        ),
      ),
    );
  }
}
