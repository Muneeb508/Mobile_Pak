import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/device_specs.dart';
import '../../services/device_recognition_service.dart';

enum ScanState { idle, scanning, done, failed }

class ScanController extends GetxController {
  final Rx<ScanState> state = ScanState.idle.obs;
  final Rx<DeviceSpecs?> detectedSpecs = Rx<DeviceSpecs?>(null);
  final RxString errorMessage = ''.obs;

  final ImagePicker _imagePicker = ImagePicker();

  Future<void> scanFromCamera() async {
    final image = await _imagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      await _processImage(image);
    }
  }

  Future<void> scanFromGallery() async {
    final image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      await _processImage(image);
    }
  }

  Future<void> _processImage(XFile image) async {
    state.value = ScanState.scanning;
    try {
      final specs = await DeviceRecognitionService.recognizeFromImage(image);
      if (specs != null) {
        detectedSpecs.value = specs;
        state.value = ScanState.done;
      } else {
        errorMessage.value = 'Could not recognize device. Please try another image.';
        state.value = ScanState.failed;
      }
    } catch (e) {
      errorMessage.value = 'Error processing image: $e';
      state.value = ScanState.failed;
    }
  }

  void reset() {
    state.value = ScanState.idle;
    detectedSpecs.value = null;
    errorMessage.value = '';
  }
}
