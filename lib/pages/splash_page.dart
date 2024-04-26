import 'dart:async';

import 'package:describe_me_ai/controllers/device_camera_controller.dart';
import 'package:describe_me_ai/pages/describer_page.dart';
import 'package:describe_me_ai/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final deviceCameraController = Get.find<DeviceCameraController>();

  @override
  void initState() {
    super.initState();
    deviceCameraController.initCamera();
    Timer.periodic(const Duration(seconds: 2), (_) {
      Get.off(() => const DescriberPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tertiaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.white,
              ),
              child: Image.asset(
                "assets/images/icon_app.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            "Animal Scientist",
            style: semiBoldTextStyle.copyWith(
              color: Colors.white,
              fontSize: 34,
            ),
          ),
        ],
      ),
    );
  }
}
