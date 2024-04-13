import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homeworkhelper/utils/app_color.dart';
import 'package:homeworkhelper/utils/app_componet.dart';
import 'package:homeworkhelper/utils/app_style.dart';

Widget dropdownMenu(List<String> item, String text,
    {Color? backGroundColor, Color? borderColor, Widget? icon}) {
  RxString dropdownvalue = item.first.obs; // Default selected value
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      appText(
          text: text,
          fontSize: 12,
          fontColor: AppColors.blackColor,
          fontWeight: FontWeight.w400),
      verticalSpacing(height: Get.height * 0.013),
      Container(
        height: Get.height * 0.045,
        width: Get.width * 0.17,
        decoration: BoxDecoration(
            border: Border.all(color: borderColor ?? Colors.transparent),
            borderRadius: BorderRadius.circular(2),
            color: backGroundColor ?? AppColors.colorF3F3),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: Obx(
              () => DropdownButton(
                style: appTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    txtColor: AppColors.grayColor),
                iconDisabledColor: AppColors.blackColor,
                value: dropdownvalue.value,
                icon: Flexible(
                  fit: FlexFit.loose,
                  child: icon ??
                      Icon(
                        Icons.arrow_drop_down_rounded,
                        size: Get.width * 0.018,
                        color: AppColors.color3246,
                      ),
                ),
                items: item.map((menu) {
                  return DropdownMenuItem(
                    value: menu,
                    child: Text(
                      menu,
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  dropdownvalue.value = newValue!;
                },
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

// ignore: must_be_immutable
class DropDownWidget extends StatelessWidget {
  String? value;
  final List<DropdownMenuItem<String>>? items;
  final String dropDowntitle;
  final String? hinttext;
  final Function(dynamic newValue) onChanged;
  DropDownWidget(
      {super.key,
      this.items,
      this.hinttext,
      this.value,
      required this.onChanged,
      required this.dropDowntitle});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        appText(
            text: dropDowntitle,
            fontSize: 12,
            fontColor: AppColors.blackColor,
            fontWeight: FontWeight.w400),
        verticalSpacing(height: Get.height * 0.013),
        Container(
          height: Get.height * 0.045,
          width: Get.width * 0.17,
          decoration: BoxDecoration(
              // border: Border.all(color: borderColor ?? Colors.transparent),
              borderRadius: BorderRadius.circular(2),
              color: AppColors.colorF3F3),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton<String>(
                hint: Text(
                  hinttext ?? "",
                  // style:
                  // nterReguler.copyWith(color: AppColor.buledark),
                ),
                style: appTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    txtColor: AppColors.grayColor),
                iconDisabledColor: AppColors.blackColor,
                icon: Flexible(
                  fit: FlexFit.loose,
                  child: Icon(
                    Icons.arrow_drop_down_rounded,
                    size: Get.width * 0.018,
                    color: AppColors.color3246,
                  ),
                ),
                isExpanded: true,
                value: value,
                onChanged: onChanged,
                items: items,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
