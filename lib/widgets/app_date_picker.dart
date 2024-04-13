import 'package:flutter/material.dart';

Future<DateTime?> showDatePickerDialog(
    BuildContext context, TextEditingController controller) async {
  DateTime initialDate = DateTime.now();

  // If the controller has a valid date, use it as the initial date
  if (controller.text.isNotEmpty) {
    final List<String> dateParts = controller.text.split('-');
    if (dateParts.length == 3) {
      initialDate = DateTime(int.parse(dateParts[2]), int.parse(dateParts[1]),
          int.parse(dateParts[0]));
    }
  }

  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: DateTime(1900),
    lastDate: DateTime(2040),
  );

  if (picked != null && picked != initialDate) {
    // Update the text field with the selected date
    controller.text = "${picked.day}-${picked.month}-${picked.year}";
  }

  return picked;
}
