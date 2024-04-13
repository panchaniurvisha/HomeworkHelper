import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homeworkhelper/utils/app_color.dart';
import 'package:homeworkhelper/utils/app_style.dart';
import 'package:homeworkhelper/utils/str_const.dart';
import 'package:homeworkhelper/widgets/app_card.dart';
import 'package:homeworkhelper/widgets/custome_app_bar.dart';
import 'package:homeworkhelper/widgets/media_query.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:table_calendar/table_calendar.dart';

import '../controller/teacher_dashboard_controller.dart';
import '../widgets/app_elevated_button.dart';

class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  final teacherDashBoardController = Get.put(TeacherDashBoardController());
  late List<_ChartData> data;
  late List<_ChartData> data2;
  late TooltipBehavior _tooltip;
  DateTime today = DateTime.now();
  void _onDaySelected(DateTime day, DateTime focusDay) {
    setState(() {
      today = day;
    });
  }

  @override
  void initState() {
    data = [
      _ChartData('Jan', 20),
      _ChartData('Feb', 42),
      _ChartData('Mar', 52),
      _ChartData('Apr', 29),
      _ChartData('May', 30),
      _ChartData('Jun', 49),
      _ChartData('Jul', 20)
    ];
    data2 = [
      _ChartData('Jan', 45),
      _ChartData('Feb', 60),
      _ChartData('Mar', 72),
      _ChartData('Apr', 50),
      _ChartData('May', 41),
      _ChartData('Jun', 40),
      _ChartData('Jul', 20)
    ];
    _tooltip = TooltipBehavior(enable: true);
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(AppString.screenTitle, style: ThemeText.header),
                  Text(' ${FirebaseAuth.instance.currentUser?.displayName}!',
                      style: ThemeText.header)
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
                child: SizedBox(
                  height: Get.height * 0.12,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          StreamBuilder<QuerySnapshot>(
                              stream: teacherDashBoardController
                                  .getStreamForIndex(index),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData)
                                  return const CircularProgressIndicator();
                                final count = snapshot.data!.docs.length;
                                return AppCard(
                                  title: teacherDashBoardController
                                      .getTitleForIndex(index, count),
                                  subtitle: count.toString(),
                                  imageName: teacherDashBoardController
                                      .getImageForIndex(index, count),
                                );
                              }),
                          SizedBox(
                            width: Get.width * 0.01,
                          )
                        ],
                      );
                    },
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: height(context) * 1.32,
                    width: Get.width * 0.48,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              flex: 2,
                              child: upCommingCard(),
                            ),
                            SizedBox(width: Get.width * 0.001),
                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                height: Get.height * 0.325,
                                width: Get.width * 0.185,
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: Get.width * 0.01,
                                      vertical: Get.height * 0.02),
                                  decoration: BoxDecoration(
                                      color: AppColors.whiteColor,
                                      borderRadius: BorderRadius.circular(
                                          Get.width * 0.008)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: Get.height * 0.01,
                                          left: Get.width * 0.01,
                                        ),
                                        child: titleText(
                                            AppString.assignmentProgress,
                                            fontSize: 14),
                                      ),
                                      SizedBox(
                                        height: Get.height * 0.02,
                                      ),
                                      Center(
                                        child: CircularPercentIndicator(
                                          // radius: Get.width * 0.04,
                                          radius: Get.width * 0.04,
                                          reverse: true,
                                          lineWidth: 6.0,
                                          backgroundWidth: 4.0,
                                          percent: 0.6,
                                          center: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              titleText(
                                                AppString.score,
                                                //fontSize: 14
                                                fontSize: Get.width * 0.011,
                                              ),
                                              titleText(
                                                  AppString.progressorText,
                                                  // fontSize: 8,
                                                  fontSize: Get.width * 0.008,
                                                  color: AppColors.grayColor),
                                            ],
                                          ),
                                          backgroundColor: AppColors.E5E5E5,
                                          progressColor: AppColors.blueColor,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(right: Get.width * 0.01),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius:
                                BorderRadius.circular(Get.width * 0.006),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                titleText(AppString.assignmentActivity,
                                    fontSize: 14),
                                SizedBox(
                                  height: Get.height * 0.04,
                                ),
                                SfCartesianChart(
                                  primaryXAxis: const CategoryAxis(
                                    labelStyle:
                                        TextStyle(color: AppColors.blackColor),
                                    majorGridLines: MajorGridLines(
                                        color: Colors.transparent),
                                  ),
                                  primaryYAxis: const NumericAxis(
                                    labelStyle:
                                        TextStyle(color: AppColors.blackColor),
                                    minimum: 20,
                                    maximum: 80,
                                    interval: 10,
                                    majorGridLines: MajorGridLines(width: 0.5),
                                  ),
                                  axes: const <ChartAxis>[
                                    NumericAxis(
                                      name: 'secondaryYAxis',
                                      isVisible:
                                          false, // Hide the secondary Y-axis
                                    ),
                                    CategoryAxis(
                                      name: 'secondaryXAxis',
                                      isVisible:
                                          false, // Hide the secondary X-axis
                                    ),
                                  ],
                                  tooltipBehavior: _tooltip,
                                  series: <CartesianSeries<_ChartData, String>>[
                                    AreaSeries<_ChartData, String>(
                                      dataSource: data,
                                      xValueMapper: (_ChartData data, _) =>
                                          data.x,
                                      yValueMapper: (_ChartData data, _) =>
                                          data.y,
                                      name: 'Gold',
                                      borderWidth: 2,
                                      borderColor: const Color(0xff47ACB9),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Colors
                                              .white, // Start color (transparent)
                                          AppColors.lightGreen // End color
                                        ],
                                        stops: [0.0, 1.0], // Gradient stops
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                      ),
                                    ),
                                    AreaSeries<_ChartData, String>(
                                      dataSource: data2,
                                      borderWidth: 2,
                                      borderColor: AppColors.blueColor,
                                      xValueMapper: (_ChartData data, _) =>
                                          data.x,
                                      yValueMapper: (_ChartData data, _) =>
                                          data.y,
                                      name: 'Silver',
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.white.withOpacity(
                                              0.2), // Start color (transparent)
                                          AppColors.lightPurple // End color
                                        ],
                                        stops: [0.0, 1.0], // Gradient stops
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                      ),
                                      yAxisName: 'secondaryYAxis',
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.circle,
                                        size: Get.width * 0.01,
                                        color: AppColors.blueColor),
                                    const SizedBox(width: 5),
                                    subTitleText(AppString.teacher),
                                    const SizedBox(width: 20),
                                    Icon(Icons.circle,
                                        size: Get.width * 0.01,
                                        color: AppColors.lightGreen),
                                    const SizedBox(width: 5),
                                    subTitleText(AppString.student),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        assignmentHistoryCard(),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: height(context) * 1.32,
                      width: Get.width * 0.296,
                      child: Container(
                        margin: EdgeInsets.only(top: Get.height * 0.02),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius:
                              BorderRadius.circular(Get.width * 0.006),
                        ),
                        child: Column(
                          children: [
                            TableCalendar(
                              availableGestures: AvailableGestures.all,
                              onDaySelected: _onDaySelected,
                              selectedDayPredicate: (day) =>
                                  isSameDay(day, today),
                              headerStyle: const HeaderStyle(
                                  formatButtonVisible: false,
                                  titleTextStyle: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14),
                                  titleCentered: true),
                              focusedDay: today,
                              locale: "en_US",
                              rowHeight: Get.height * 0.06,
                              firstDay: DateTime.utc(2010, 16, 10),
                              lastDay: DateTime.utc(2030, 16, 10),
                              calendarStyle: const CalendarStyle(
                                selectedDecoration: BoxDecoration(
                                  color: AppColors.blueColor,
                                  shape: BoxShape.circle,
                                ),
                                selectedTextStyle: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.whiteColor,
                                ),
                                outsideTextStyle: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.blackColor,
                                ),
                                // Add more customization options as needed
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: Get.width * 0.01,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: titleText(
                                        AppString.submittedAssignment,
                                        fontSize: 13),
                                  ),
                                  const Flexible(
                                    child: Card(
                                        elevation: 0.5,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(2))),
                                        color: AppColors.lightWhite2,
                                        child: Icon(Icons.add,
                                            color: AppColors.grayTwo)),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: ListView.builder(
                                itemBuilder: (context, index) => SizedBox(
                                  height: Get.height * 0.25,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(
                                          Get.width * 0.01,
                                        ),
                                        child: Row(
                                          children: [
                                            subTitleText(AppString.date,
                                                fontSize: 12),
                                            SizedBox(
                                              width: Get.width * 0.02,
                                            ),
                                            const Expanded(
                                              flex: 2,
                                              child: Divider(
                                                color: AppColors.lightWhite1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: index == 0
                                              ? 2
                                              : 6, // Number of times to repeat the row
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Row(
                                                children: [
                                                  subTitleText(AppString.time,
                                                      fontSize: 9,
                                                      color:
                                                          AppColors.grayColor),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                Get.width *
                                                                    0.006),
                                                    child: SizedBox(
                                                      height:
                                                          Get.height * 0.046,
                                                      width: Get.width * 0.0023,
                                                      child:
                                                          const VerticalDivider(
                                                        color:
                                                            AppColors.blueColor,
                                                        thickness: 3,
                                                      ),
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        AppString.subject,
                                                        style: TextStyle(
                                                            color: AppColors
                                                                .blackColor,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                      subTitleText(
                                                          AppString
                                                              .subTitleOfSubject,
                                                          fontSize: 9,
                                                          color: AppColors
                                                              .grayColor),
                                                    ],
                                                  ),
                                                  const Spacer(),
                                                  Expanded(
                                                    flex: 1,
                                                    child: subTitleText(
                                                        AppString.time1,
                                                        fontSize: 9,
                                                        color: AppColors
                                                            .grayColor),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                shrinkWrap: true,
                                itemCount: 1,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget upCommingCard() {
    return SizedBox(
      height: Get.height * 0.325,
      width: width(context) * 0.387,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: Get.height * 0.02),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(Get.width * 0.006),
        ),
        child: Padding(
          padding: EdgeInsets.all(Get.width * 0.01),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      child: titleText(AppString.upcommingAssignment,
                          fontSize: 14)),
                  Flexible(
                    child: subTitleText(AppString.ViewAllCourses,
                        color: AppColors.blueColor),
                  ),
                ],
              ),
              Expanded(
                flex: 1,
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Assignments')
                        .where('assign_date',
                            isGreaterThan: DateTime.now().toIso8601String())
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var doc = snapshot.data?.docs[index];

                            return Padding(
                              padding: EdgeInsets.only(top: Get.height * 0.03),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      subTitleText(doc?['name'], fontSize: 12),
                                      subTitleText(AppString.confimed,
                                          color: AppColors.blueColor,
                                          fontSize: 11),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(doc?['add_text'],
                                              style: ThemeText.subHeader),
                                          Row(
                                            children: [
                                              Icon(
                                                  Icons.calendar_today_outlined,
                                                  color: AppColors.grayTwo,
                                                  size: Get.width * 0.01),
                                              SizedBox(
                                                width: Get.width * 0.005,
                                              ),
                                              subTitleText(doc?['due_date'],
                                                  color: AppColors.grayTwo),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: Get.width * 0.001,
                                                ),
                                                child: const SizedBox(
                                                  //  width: Get.width * 0.005,
                                                  height: 15,
                                                  child: VerticalDivider(
                                                    color: AppColors.grayTwo,
                                                    thickness: 2,
                                                  ),
                                                ),
                                              ),
                                              Icon(Icons.access_time,
                                                  color: AppColors.grayTwo,
                                                  size: Get.width * 0.013),
                                              subTitleText(
                                                AppString.accessTime,
                                                color: AppColors.grayTwo,
                                                fontSize: Get.width * 0.01,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      AppSmallButton(
                                        text: AppString.reschedule,
                                        color: AppColors.whiteColor,
                                        backGroundColor: AppColors.blueColor,
                                        height: height(context) * 0.041,
                                        width: width(context) * 0.056,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            );
                          });
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget assignmentHistoryCard() {
    return Expanded(
      flex: 1,
      child: SizedBox(
        height: Get.height * 0.335,

        // width: Get.width * 0.585,
        child: Container(
          margin: const EdgeInsets.symmetric()
              .copyWith(right: Get.width * 0.01, top: Get.height * 0.02),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(Get.width * 0.006),
          ),
          child: Padding(
            padding: EdgeInsets.all(Get.width * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titleText(AppString.assignmentHistory, fontSize: 14),
                SizedBox(
                  height: Get.height * 0.03,
                ),
                Expanded(
                  flex: 1,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 3,
                    itemBuilder: (context, index) => Wrap(
                      children: [
                        subTitleText(AppString.monthYear, fontSize: 12),
                        Column(
                          children: [
                            Icon(
                              Icons.circle_outlined,
                              color: AppColors.blueColor,
                              size: Get.width * 0.01,
                            ),
                            SizedBox(
                              height: Get.height * 0.06,
                              width: 10,
                              child: const VerticalDivider(
                                color: AppColors.AEAEAE,
                                thickness: 1.5,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: Get.width * 0.004),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              titleText(AppString.historySubject, fontSize: 14),
                              Wrap(
                                children: [
                                  Icon(Icons.calendar_today_outlined,
                                      color: AppColors.grayTwo,
                                      size: Get.width * 0.01),
                                  SizedBox(
                                    width: Get.width * 0.005,
                                  ),
                                  subTitleText(AppString.historyDate,
                                      color: AppColors.grayTwo),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: Get.width * 0.01,
                                    ),
                                    child: const SizedBox(
                                      width: 2,
                                      height: 15,
                                      child: VerticalDivider(
                                        color: AppColors.grayTwo,
                                        thickness: 2,
                                      ),
                                    ),
                                  ),
                                  Icon(Icons.access_time,
                                      color: AppColors.grayTwo,
                                      size: Get.width * 0.013),
                                  subTitleText(AppString.historyTime,
                                      color: AppColors.grayTwo),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: width(context) * 0.06,
                        ),
                        AppSmallButton(
                          text: AppString.InProgress,
                          color: AppColors.blackColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          backGroundColor: AppColors.EFFEFF,
                          height: height(context) * 0.04,
                          width: width(context) * 0.083,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget titleText(String? text, {Color? color, double? fontSize}) {
    return Text(text!,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: fontSize ?? 10,
          overflow: TextOverflow.ellipsis,
          color: color ?? AppColors.blackColor,
        ));
  }

  Widget subTitleText(String? text,
      {Color? color, double? fontSize, FontWeight? fontWeight}) {
    return Text(text!,
        style: TextStyle(
          fontWeight: fontWeight ?? FontWeight.w400,
          overflow: TextOverflow.ellipsis,
          fontSize: fontSize ?? 10,
          color: color ?? AppColors.blackColor,
        ));
  }

  Widget regularText(String? text, {Color? color}) {
    return Text(text!,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: Get.width * 0.0120,
          color: color ?? AppColors.grayColor,
        ));
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
