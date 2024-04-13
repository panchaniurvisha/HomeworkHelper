import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:homeworkhelper/utils/app_images.dart';

class TeacherDashBoardController extends GetxController {
  RxBool switchValue = true.obs;

  Stream<QuerySnapshot> getStreamForIndex(int index) {
    switch (index) {
      case 0:
        return FirebaseFirestore.instance.collection('Courses').snapshots();
      case 1:
        return FirebaseFirestore.instance.collection('Students').snapshots();
      case 2:
        return FirebaseFirestore.instance.collection('Assignments').snapshots();
      case 3:
        return FirebaseFirestore.instance.collection('Teachers').snapshots();
      default:
        throw Exception('Invalid index');
    }
  }

  String getTitleForIndex(int index, int count) {
    switch (index) {
      case 0:
        return 'Total Courses';
      case 1:
        return 'Total Students';
      case 2:
        return 'Total Assignments';
      case 3:
        return 'Total Teachers';
      default:
        throw Exception('Invalid index');
    }
  }

  String getImageForIndex(int index, int count) {
    switch (index) {
      case 0:
        return AppImages.totalClasses;
      case 1:
        return AppImages.totalStudents;
      case 2:
        return AppImages.totalAssignments;
      case 3:
        return AppImages.totalHours;
      default:
        throw Exception('Invalid index');
    }
  }

/* 
   Future<void> fetchData() async {
    // Fetch data from Firestore
   
    QuerySnapshot snapshotAssignment =
        await FirebaseFirestore.instance.collection('Assignments').get();

 QuerySnapshot snapshotCourse =
        await FirebaseFirestore.instance.collection('Courses').get();

 QuerySnapshot snapshotStudent =
        await FirebaseFirestore.instance.collection('Students').get();

   

   /*  snapshot.docs.forEach((doc) {
      items.add(doc
          .get('name')); // Adjust 'field_name' to your field name in Firestore
    }); */

   
  } */
}
