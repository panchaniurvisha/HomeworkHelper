import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homeworkhelper/pref/shared_pref.dart';
import 'package:homeworkhelper/services/firebase_services.dart';
import 'package:homeworkhelper/utils/str_const.dart';
import 'package:homeworkhelper/widgets/app_elevated_button.dart';
import 'package:homeworkhelper/widgets/app_textformField.dart';

import '../controller/login_controller.dart';
import '../utils/app_color.dart';
import '../utils/app_images.dart';
import '../utils/app_style.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final authController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: authController.formKey.value,
        child: Center(
          child: Container(
            height: Get.height / 1.4,
            width: Get.width / 3,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: AppColors.whiteColor,
              boxShadow: [
                BoxShadow(
                  color: AppColors.blackColor.withOpacity(0.2), // Shadow color
                  blurRadius: 10, // Spread radius
                  offset: const Offset(0, 0), // Offset in x and y axes
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(AppString.loginTitle, style: ThemeText.header),
                  Text(AppString.loginSubTitle, style: ThemeText.subHeader),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: Get.height * 0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(
                          () => Radio(
                            value: true,
                            groupValue: authController.isAdmin.value,
                            activeColor: AppColors.blueColor,
                            onChanged: (value) {
                              authController.toggleAdmin(value ?? false);
                              log('is ADmin 0====>${authController.isAdmin.value}');
                            },
                          ),
                        ),
                        const Text(
                          'Admin',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(width: Get.width * 0.01),
                        Obx(
                          () => Radio(
                            value: false,
                            groupValue: authController.isAdmin.value,
                            activeColor: AppColors.blueColor,
                            onChanged: (value) {
                              authController.toggleAdmin(value ?? false);
                              log('is ADmin ====>${authController.isAdmin.value}');
                            },
                          ),
                        ),
                        const Text(
                          'Teacher',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Get.width * 0.015),
                    child: AppTextFormField(
                        labelText: AppString.labelOfEmail,
                        hintText: AppString.labelOfEmail,
                        controller: authController.emailController.value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return authController.emailValid.hasMatch(value)
                              ? null
                              : 'Please enter a valid email address';
                        },
                        keyboardType: TextInputType.emailAddress),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.015)
                        .copyWith(top: Get.height * 0.02),
                    child: AppElevatedButton(
                        onPressed: () {
                          if (authController.formKey.value.currentState!
                              .validate()) {
                            if (authController.emailController.value.text
                                    .trim() !=
                                '') {
                              FirebaseServices().checkAndCreateUser(
                                  authController.emailController.value.text
                                      .trim(),
                                  context);
                            }
                          }
                        },
                        text: AppString.titleOfLoginButton,
                        backGroundColor: AppColors.blueColor,
                        color: AppColors.whiteColor),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Get.width * 0.01,
                        vertical: Get.height * 0.02),
                    child: const Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Divider(
                            color: AppColors.lightWhite1,
                          ),
                        ),
                        Text("or",
                            style: TextStyle(
                                color: AppColors.grayOne,
                                fontWeight: FontWeight.w600)),
                        Expanded(
                          flex: 2,
                          child: Divider(
                            color: AppColors.lightWhite1,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Get.width * 0.015),
                    child: Obx(
                      () => authController.isLoading.value
                          ? const CircularProgressIndicator()
                          : AppElevatedButton(
                              onPressed: () async {
                                if (authController.isAdmin.value == true) {
                                  log('userType====> admin');

                                  await authController.googleSignIn(
                                      context, UserType.admin);

                                  SharedPref.setIsAdminloggin();
                                } else {
                                  log('userType====> teacher');
                                  await authController.googleSignIn(
                                      context, UserType.teacher);
                                }

                                // await FirebaseServices().signInWithGoogle();
                              },
                              text: AppString.titleOfGoogleButton,
                              imageName: AppImages.googleLogo,
                            ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.015)
                        .copyWith(top: Get.height * 0.02),
                    child: AppElevatedButton(
                      onPressed: () async {
                        await FirebaseServices().signInWithApple();
                      },
                      text: AppString.titleOfAppleButton,
                      imageName: AppImages.appleLogo,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
