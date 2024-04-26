// ignore_for_file: avoid_print

import 'dart:io';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:camera/camera.dart';
import 'package:describe_me_ai/controllers/ai_controller.dart';
import 'package:describe_me_ai/controllers/device_camera_controller.dart';
import 'package:describe_me_ai/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class DescriberPage extends StatefulWidget {
  const DescriberPage({super.key});

  @override
  State<DescriberPage> createState() => _DescriberPageState();
}

class _DescriberPageState extends State<DescriberPage> {
  final deviceCameraController = Get.find<DeviceCameraController>();
  final aiController = Get.find<AiController>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    deviceCameraController.cameraController!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print("CameraAccessDenied: $e");
            break;
          default:
            print(e);
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            "Animal Scientist",
            style: boldTextStyle.copyWith(
              color: primaryColor,
              fontSize: 40,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 22),
            child: GetBuilder(
              init: AiController(),
              builder: (controller) {
                return AnimatedToggleSwitch<bool>.dual(
                  current: controller.bahasaPromnt,
                  first: false,
                  second: true,
                  spacing: 0,
                  style: ToggleStyle(
                    borderColor: primaryColor,
                  ),
                  borderWidth: 2.0,
                  height: 40,
                  onChanged: (value) => controller.bahasaPromnt = value,
                  styleBuilder: (value) => ToggleStyle(
                    indicatorColor: value ? primaryColor : tertiaryColor,
                  ),
                  iconBuilder: (value) => value
                      ? const Icon(
                          Icons.translate,
                          color: Colors.white,
                          size: 24,
                        )
                      : const Icon(
                          Icons.translate,
                          color: Colors.white,
                          size: 24,
                        ),
                  textBuilder: (value) => value
                      ? Center(
                          child: Text(
                            'ID',
                            style: normalTextStyle.copyWith(
                              color: primaryColor,
                              fontSize: 30,
                            ),
                          ),
                        )
                      : Center(
                          child: Text(
                            'EN',
                            style: normalTextStyle.copyWith(
                              color: tertiaryColor,
                              fontSize: 30,
                            ),
                          ),
                        ),
                );
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                GetBuilder(
                  init: DeviceCameraController(),
                  builder: (controller) {
                    return AspectRatio(
                      aspectRatio: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: controller.fileImage == null
                            ? CameraPreview(
                                deviceCameraController.cameraController!,
                              )
                            : InteractiveViewer(
                                panEnabled: false,
                                minScale: 0.5,
                                child: Image.file(
                                  File(controller.fileImage!.path),
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 3,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: tertiaryColor,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        "The Animal Is!",
                        style: boldTextStyle.copyWith(
                          fontSize: 30,
                          color: primaryColor,
                        ),
                      ),
                      const Divider(color: Colors.white),
                      const SizedBox(height: 5),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Align(
                            alignment: Alignment.center,
                            child: (isLoading)
                                ? const Center(
                                    child: SpinKitThreeBounce(
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  )
                                : aiController.myResult.isEmpty
                                    ? Text(
                                        "Ambil Gambar Hewan Disekitar Mu!",
                                        style: mediumTextStyle.copyWith(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      )
                                    : Text(
                                        aiController.myResult,
                                        style: normalTextStyle.copyWith(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                        textAlign: TextAlign.justify,
                                      ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: isLoading
          ? Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            )
          : Container(
              width: 210,
              margin: const EdgeInsets.only(bottom: 10),
              child: GetBuilder(
                init: DeviceCameraController(),
                builder: (controller) {
                  if (controller.fileImage == null) {
                    return FloatingActionButton(
                      backgroundColor: primaryColor,
                      onPressed: () async {
                        setState(() => isLoading = !isLoading);
                        deviceCameraController.cameraController!
                            .setFlashMode(FlashMode.off);
                        XFile picture = await deviceCameraController
                            .cameraController!
                            .takePicture();
                        deviceCameraController.fileImage = picture;
                        await aiController
                            .getdata(
                              picture,
                              aiController.bahasaPromnt
                                  ? "Jelaskan hewan apa itu, jika itu bukan hewan maka tampilkan pesan 'Itu bukan hewan mohon identify kembali'"
                                  : "Explains the details what animal it is , if it is not an animal then displays the message 'It is not an animal, please re-identify'",
                            )
                            .then(
                              (_) => setState(() => isLoading = !isLoading),
                            );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.camera_alt_rounded,
                            size: 30,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Identify Animal",
                            style: mediumTextStyle.copyWith(
                              color: Colors.white,
                              fontSize: 30,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return FloatingActionButton(
                      backgroundColor: primaryColor,
                      onPressed: () async {
                        controller.fileImage = null;
                        setState(() {});
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.search_rounded,
                            size: 30,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Identify Again!",
                            style: mediumTextStyle.copyWith(
                              color: Colors.white,
                              fontSize: 30,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
    );
  }
}
