// To parse this JSON data, do
//
//     final coursesModel = coursesModelFromJson(jsonString);

import 'dart:convert';

CoursesModel coursesModelFromJson(String str) => CoursesModel.fromJson(json.decode(str));

String coursesModelToJson(CoursesModel data) => json.encode(data.toJson());

class CoursesModel {
    String? id;
    String? course;
    String? courseperiod;
    List<dynamic>? students;
    String? teacher;
    String? qrCode;

    CoursesModel({
        this.id,
        this.course,
        this.courseperiod,
        this.students,
        this.teacher,
        this.qrCode,
    });

    factory CoursesModel.fromJson(Map<String, dynamic> json) => CoursesModel(
        id: json["id"],
        course: json["course"],
        courseperiod: json["courseperiod"],
        students: json["students"] == null ? [] : List<dynamic>.from(json["students"]!.map((x) => x)),
        teacher: json["teacher"],
        qrCode: json["qr_code"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "course": course,
        "courseperiod": courseperiod,
        "students": students == null ? [] : List<dynamic>.from(students!.map((x) => x)),
        "teacher": teacher,
        "qr_code": qrCode,
    };
}
