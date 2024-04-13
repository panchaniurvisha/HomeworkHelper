import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppTextFormField extends StatelessWidget {
  final bool? obscureText;
  final Widget? suffixIcon;
  final String? labelText;
  final String? hintText;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final String? initialValue;
  final bool? readOnly;
  final TextEditingController? controller;

  const AppTextFormField({
    Key? key,
    this.controller,
    this.labelText,
    this.validator,
    this.obscureText,
    this.suffixIcon,
    this.hintText,
    this.keyboardType,
    this.textInputAction,
    this.initialValue,
    this.readOnly,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width * 0.4,
      child: TextFormField(
        initialValue: initialValue,
        obscureText: obscureText ?? false,
        controller: controller,
        readOnly: readOnly ?? false,
        autofocus: true,
        keyboardType: keyboardType,
        textInputAction: textInputAction ?? TextInputAction.next,
        decoration: InputDecoration(
          suffixIcon: suffixIcon ?? const SizedBox(),
          hintText: hintText!,
          contentPadding: EdgeInsets.symmetric(
              vertical: Get.height * 0.01, horizontal: Get.height * 0.02),
          filled: true,
          fillColor: const Color(0xffF4F3F3),
          border: InputBorder.none,
          labelText: labelText ?? "",
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 2, color: Color(0xffF4F3F3)),
            borderRadius: BorderRadius.all(
              Radius.circular(Get.width * 0.004),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 2, color: Colors.blue),
            borderRadius: BorderRadius.all(
              Radius.circular(Get.width * 0.004),
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 2, color: Colors.red),
            borderRadius: BorderRadius.all(
              Radius.circular(Get.width * 0.004),
            ),
          ),
        ),
        validator: validator,
      ),
    );
  }
}
