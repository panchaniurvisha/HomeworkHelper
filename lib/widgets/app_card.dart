import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homeworkhelper/utils/app_color.dart';

import '../utils/app_style.dart';

class AppCard extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? imageName;
  const AppCard({
    super.key,
    this.title,
    this.subtitle,
    this.imageName,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width * 0.189,
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Get.width * 0.008),
        ),
        tileColor: AppColors.whiteColor,
        title: Text(
          title ?? '',
          maxLines: 2,
          style: ThemeText.subHeader,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(subtitle ?? '',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.blackColor,
                fontSize: Get.width * 0.01)),
        trailing: Image.asset(imageName ?? '', height: Get.height * 0.06),
      ),
    );
  }
}
