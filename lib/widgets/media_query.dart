import 'package:flutter/material.dart';

height(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

width(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

class resposiceSize extends StatelessWidget {
  const resposiceSize({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      constraints: BoxConstraints(
        maxHeight: screenHeight,
        maxWidth: screenWidth,
        minHeight: screenHeight * 0.5,
        minWidth: screenWidth * 0.5,
      ),
    );
  }
}
