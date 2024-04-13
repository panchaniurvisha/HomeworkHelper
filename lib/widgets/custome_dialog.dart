import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/app_color.dart';

class CustomeDialog extends StatelessWidget {
  const CustomeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return _ShapedWidget();
  }
}

class _ShapedWidget extends StatelessWidget {
  final double padding = 4.0;

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.antiAlias,
      shape: _ShapedWidgetBorder(
          borderRadius: BorderRadius.all(Radius.circular(padding)),
          padding: padding),
      elevation: 4.0,
      child: SizedBox(
        width: Get.width * 0.186,
        height: Get.height * 0.165,
        child: Padding(
          padding: EdgeInsets.all(Get.width * 0.01),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.error_outline),
                  Text("Do you want to delete ?",
                      style: appTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.color3246,
                      )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  textButton(
                    text: "No",
                    backGroundColor: AppColors.whiteColor,
                    textColor: AppColors.blackColor,
                  ),
                  SizedBox(width: Get.width * 0.01),
                  textButton(
                    text: "Yes",
                  ),
                ],
              ),
            ],
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
        fontSize: fontSize ?? 14);
  }

  Widget textButton({String? text, Color? backGroundColor, Color? textColor}) {
    return InkWell(
      child: Container(
          decoration: BoxDecoration(
            color: backGroundColor ?? AppColors.blueColor,
            border: Border.all(color: AppColors.blackColor),
            borderRadius: BorderRadius.circular(Get.width * 0.004),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: Get.height * 0.01, horizontal: Get.width * 0.02),
            child: Text(text!,
                style: appTextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: textColor ?? AppColors.whiteColor)),
          )),
    );
  }
}

class _ShapedWidgetBorder extends RoundedRectangleBorder {
  _ShapedWidgetBorder({
    required this.padding,
    side = BorderSide.none,
    borderRadius = BorderRadius.zero,
  }) : super(side: side, borderRadius: borderRadius);
  final double padding;

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path path = Path()
      ..moveTo(rect.width - 8.0, rect.top)
      ..lineTo(rect.width - 20.0, rect.top - 16.0)
      ..lineTo(rect.width - 32.0, rect.top)
      ..addRRect(borderRadius.resolve(textDirection).toRRect(
            Rect.fromLTWH(
              rect.left,
              rect.top,
              rect.width,
              rect.height - padding,
            ),
          ));

    // Add the inner path
    path.addPath(getInnerPath(rect, textDirection: textDirection), Offset.zero);

    return path;
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      // Define the inner path as needed
      ..addRect(Rect.fromLTWH(
        rect.left + padding,
        rect.top + padding,
        rect.width - 2 * padding,
        rect.height - 2 * padding,
      ));
  }
}
