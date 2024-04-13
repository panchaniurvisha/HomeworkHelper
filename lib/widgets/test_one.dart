import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/app_images.dart';
import 'custome_dialog.dart';

class TestScreen extends StatelessWidget {
  final GlobalKey _key = GlobalKey();
  OverlayEntry? overlayEntry;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // Handle click if needed
        },
        child: Image.asset(
          AppIcon.deleteIcon,
          fit: BoxFit.cover,
          height: Get.height * 0.0416,
          key: _key,
        ),
      ),
      onEnter: (_) {
        showOverlay(context);
      },
    );
  }

  void showOverlay(BuildContext context) {
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: getTopPosition(),
        left: getLeftPosition(),
        child: GestureDetector(
          onTap: () {
            // Handle tap inside overlay
          },
          child: MouseRegion(
            onExit: (_) {
              removeOverlay();
            },
            child: CustomeDialog(),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry!);
  }

  void removeOverlay() {
    overlayEntry?.remove();
  }

  double getTopPosition() {
    final RenderBox renderBox =
        _key.currentContext?.findRenderObject() as RenderBox;
    double padding = 20;
    return renderBox.localToGlobal(Offset(0, padding)).dy;
  }

  double getLeftPosition() {
    final RenderBox renderBox =
        _key.currentContext?.findRenderObject() as RenderBox;

    double padding = -260.0;

    return renderBox.localToGlobal(Offset(padding, 0)).dx;
  }
}
