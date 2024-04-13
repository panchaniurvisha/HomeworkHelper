import 'dart:html' as html;
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homeworkhelper/utils/app_color.dart';
import 'package:homeworkhelper/utils/app_componet.dart';
import 'package:homeworkhelper/utils/app_style.dart';
import 'package:homeworkhelper/utils/str_const.dart';
import 'package:homeworkhelper/widgets/app_dialog_box.dart';
import 'package:homeworkhelper/widgets/app_text_field.dart';
import 'package:homeworkhelper/widgets/media_query.dart';

class AssignmentController extends GetxController {
  final CollectionReference _dataCollection =
      FirebaseFirestore.instance.collection('Assignments');
  TextEditingController dueDateController = TextEditingController();

  TextEditingController assignDateController = TextEditingController();
  TextEditingController addTextController = TextEditingController();
  Rx<PlatformFile?> file = Rx<PlatformFile?>(null);
  RxString size = ''.obs;
  TextEditingController asignmentNameController = TextEditingController();
  TextEditingController coursePeriodController = TextEditingController();
  TextEditingController assignDate = TextEditingController();
  TextEditingController dueDate = TextEditingController();
  UploadTask? uploadTask;
  RxList<Map<String, dynamic>> assignData = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> assignmetnFilter = <Map<String, dynamic>>[].obs;
  var selectedCourse = ''.obs;
  var fileLink = ''.obs;
  var coursesList = [].obs;
  final RxList<bool> checkedItems = List.generate(6, (index) => false).obs;
  RxBool isAnyChecked = false.obs;

  void updateIsAnyChecked() {
    isAnyChecked.value = checkedItems.any((isChecked) => isChecked);
  }

  @override
  void onInit() {
    super.onInit();
    fetchData();
    fetchCourseListData();
  }

  Future<void> fetchData() async {
    QuerySnapshot querySnapshot = await _dataCollection.get();
    assignData.assignAll(querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList());
    assignmetnFilter.assignAll(assignData);
  }

  Future<void> fetchCourseListData() async {
    // Fetch data from Firestore
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('Courses').get();

    List<String> items = [];

    snapshot.docs.forEach((doc) {
      items.add(doc.get(
          'course')); // Adjust 'field_name' to your field name in Firestore
    });

    coursesList.value = items;
  }

  void applyFilter(String query) {
    if (query.isEmpty) {
      assignmetnFilter
          .assignAll(assignData); // If the query is empty, show all data
    } else {
      assignmetnFilter.assignAll(assignData.where((data) {
        final name = data['name'].toString().toLowerCase();
        return name.contains(query.toLowerCase());
      }).toList()); // Otherwise, apply the filter
    }
  }

  void selectedTeacher(String value) {
    selectedCourse.value = value;
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

        size.value = fileSize;

        update(); // Use update() to trigger a rebuild of the UI
      } else {
        Get.snackbar(
          'File Size Limit Exceeded',
          'Please select a file with a size of 5 MB or less.',
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

  void openFile() async {
    if (file.value != null) {
      if (file.value!.bytes != null) {
        // Extract the file bytes
        final Uint8List fileBytes = file.value!.bytes!;

        // Determine the file type based on its extension
        String extension = file.value!.name!.split('.').last.toLowerCase();

        // Define a list of file types you want to handle
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
        // Check if the file type is supported
        if (supportedTypes.contains(extension)) {
          // Open the file in a new browser window

          if (extension == 'pdf') {
            // For PDF, use a PDF viewer (replace 'pdf_viewer_url' with the actual URL)
            final pdfViewerUrl = 'https://example.com/pdf-viewer?url=';
            final pdfUrl = Uri.dataFromBytes(
              fileBytes,
              mimeType: 'application/pdf',
            ).toString();
            html.window.open('$pdfViewerUrl$pdfUrl', '_blank');
          } else if (['png', 'jpg', 'jpeg'].contains(extension)) {
            try {
              // For image files, create a Blob and open in a new browser window
              final blob = html.Blob([fileBytes], 'image/$extension');
              final imageUrl = html.Url.createObjectUrlFromBlob(blob);

              // Open the image in a new browser window
              html.window.open(imageUrl, '_blank');
            } catch (e) {
              // Handle potential errors
              Get.snackbar(
                'Error',
                'Failed to open the image: $e',
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          } else if (['txt', 'doc', 'docx', 'dart'].contains(extension)) {
            // For text and document files, convert bytes to String and display in a textarea
            final url = html.Url.createObjectUrlFromBlob(blob);
            html.window.open(url, '_blank');
          }
        } else {
          // Handle unsupported file types
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

  Widget dataTableWidget(BuildContext context) {
    List<DataColumn> columns = [
      DataColumn(
        label: Text('Assignment Name', style: appTextStyle()),
      ),
      DataColumn(label: Flexible(child: Text('Course', style: appTextStyle()))),
      DataColumn(
          label: Flexible(child: Text('Course Period', style: appTextStyle()))),
      DataColumn(
          label: Flexible(child: Text('Due-Date', style: appTextStyle()))),
      DataColumn(
          label: Flexible(child: Text('Assign-Date', style: appTextStyle()))),
    ];

    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          width: Get.width * 223.93,
          child: DataTable(
            columns: columns,
            // columnSpacing: Get.width * 0.080, // 7986
            border: TableBorder.all(
              color: AppColors.colorDEDE,
            ),
            rows: assignmetnFilter.asMap().entries.map((entry) {
              final Map<String, dynamic> item = entry.value;

              return DataRow(
                cells: [
                  DataCell(
                    Row(
                      children: [
                        InkWell(
                            child: appText(
                                text: item['name'].toString(),
                                fontColor: AppColors.color47FF,
                                fontWeight: FontWeight.w600,
                                fontSize: 12),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: ((context) => CustomAlertDialog(
                                        onTap: () {
                                          Get.back();
                                        },
                                        alertTitle: item['name'],
                                        height: height(context) * 0.357,
                                        width: width(context) * 0.597,
                                        mainBody: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                PopupTextField(
                                                  readOnly: true,
                                                  text: AppString.courseName,
                                                  hintText: item['course'],
                                                  onChanged: (p0) {},
                                                  onTap: () {
                                                    // showDatePickerDialog(
                                                    //     context, dueDate);
                                                  },
                                                ),
                                                horizonatlSpacing(
                                                    width: Get.width * 0.017),
                                                PopupTextField(
                                                  readOnly: true,
                                                  text: AppString.coursePeriod,
                                                  hintText:
                                                      item['course_period'],
                                                  onChanged: (p0) {},
                                                  onTap: () {
                                                    // showDatePickerDialog(
                                                    //     context, dueDate);
                                                  },
                                                ),
                                                horizonatlSpacing(
                                                    width: Get.width * 0.017),
                                                PopupTextField(
                                                  readOnly: true,
                                                  controller: assignDate,
                                                  text: AppString.assignDate,
                                                  hintText: item['assign_date'],
                                                  onChanged: (p0) {},
                                                  onTap: () {},
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
                                                  readOnly: true,
                                                  controller: dueDate,
                                                  text: AppString.dueDate,
                                                  hintText: item['due_date'],
                                                  onChanged: (p0) {},
                                                  onTap: () {
                                                    // showDatePickerDialog(
                                                    //     context, dueDate);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )));
                            })
                      ],
                    ),
                  ),
                  DataCell(Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: appText(
                            text: item['course'].toString(),
                            fontColor: AppColors.color3246,
                            fontWeight: FontWeight.w400,
                            fontSize: 12),
                      ),
                    ],
                  )),
                  DataCell(
                    appText(
                        text: item['course_period'].toString(),
                        fontColor: AppColors.color3246,
                        fontWeight: FontWeight.w400,
                        fontSize: 12),
                  ),
                  DataCell(
                    appText(
                        text: item['due_date'].toString(),
                        fontColor: AppColors.color3246,
                        fontWeight: FontWeight.w400,
                        fontSize: 12),
                  ),
                  DataCell(
                    appText(
                        text: item['assign_date'].toString(),
                        fontColor: AppColors.color3246,
                        fontWeight: FontWeight.w400,
                        fontSize: 12),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  TextStyle appTextStyle(
      {Color? color, FontWeight? fontWeight, double? fontSize}) {
    return TextStyle(
        color: color ?? AppColors.blackColor,
        fontWeight: fontWeight ?? FontWeight.w600,
        overflow: TextOverflow.ellipsis,
        fontSize: fontSize ?? 14);
  }
}
