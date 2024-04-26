import 'package:describe_me_ai/controllers/ai_controller.dart';
import 'package:describe_me_ai/controllers/device_camera_controller.dart';
import 'package:describe_me_ai/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(DeviceCameraController());
    Get.lazyPut(() => AiController());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const SplashPage(),
    );
  }
}
