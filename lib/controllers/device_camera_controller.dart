import 'package:camera/camera.dart';
import 'package:get/get.dart';

class DeviceCameraController extends GetxController {
  List<CameraDescription>? _cameras;
  CameraController? _cameraController;
  XFile? _fileImage;

  List<CameraDescription>? get cameras => _cameras;
  CameraController? get cameraController => _cameraController;
  XFile? get fileImage => _fileImage;

  set cameraController(CameraController? newCameraController) {
    _cameraController = newCameraController;
    update();
  }

  set fileImage(XFile? newFileImage) {
    _fileImage = newFileImage;
    update();
  }

  void initCamera() async {
    _cameras = await availableCameras();

    _cameraController = CameraController(
      cameras![0],
      ResolutionPreset.ultraHigh,
    );
  }
}
