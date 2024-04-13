import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homeworkhelper/utils/app_style.dart';

import '../utils/app_color.dart';
import '../utils/app_images.dart';

class CustomAppBar extends StatefulWidget {
  final bool? switchValue;
  final void Function(bool)? onSwitchChanged;

  const CustomAppBar({
    Key? key,
    this.switchValue,
    this.onSwitchChanged,
  }) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: Get.height * 0.127,
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.whiteColor,
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Transform.scale(
              //   scale: 0.8,
              //   child: CupertinoSwitch(
              //     value: widget.switchValue!,
              //     activeColor: AppColors.skyBlueOne,
              //     onChanged: widget.onSwitchChanged!,
              //   ),
              // ),
              // SizedBox(width: Get.width * 0.01),
              Image.asset(
                AppImages.notificationImage,
                fit: BoxFit.cover,
                // height: Get.width * 0.06,
                height: Get.width * 0.03,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.01),
                child: Center(
                  child: Text(
                      '${FirebaseAuth.instance.currentUser?.displayName}',
                      overflow: TextOverflow.ellipsis,
                      style: ThemeText.regular),
                ),
              ),
              ClipOval(
                clipBehavior: Clip.antiAlias,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: FirebaseAuth.instance.currentUser?.photoURL != null
                      ? Image.network(
                          FirebaseAuth.instance.currentUser!.photoURL!,
                          // '${FirebaseAuth.instance.currentUser?.photoURL}',
                          fit: BoxFit.cover,
                          height: Get.width * 0.04500,
                        )
                      : Image.asset(
                          AppImages.profileImage1,
                          fit: BoxFit.cover,
                          height: Get.width * 0.04500,
                        ),
                ),
              ),
              SizedBox(width: Get.width * 0.01),
            ],
          ),
        ),
      ],
    );
  }
}
