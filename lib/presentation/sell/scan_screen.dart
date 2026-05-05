import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/controllers/scan_controller.dart';
import 'widgets/scan_overlay.dart';
import 'widgets/detected_device_card.dart';
import 'detection_result_screen.dart';
import 'sell_screen.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with TickerProviderStateMixin {
  late final ScanController scanCtrl = Get.find<ScanController>();
  late AnimationController _entryController;

  @override
  void initState() {
    super.initState();

    // Entry fade-in animation
    _entryController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _entryController.forward();

    // Listen for scan completion
    ever(scanCtrl.state, (state) {
      if (state == ScanState.done) {
        Get.to(() => const DetectionResultScreen());
      } else if (state == ScanState.failed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(scanCtrl.errorMessage.value),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Device'),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => Get.to(() => const SellScreen()),
            child: Text(
              'Skip',
              style: TextStyle(color: AppColors.accent),
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: CurvedAnimation(parent: _entryController, curve: Curves.easeIn),
        child: Obx(() {
          final isScanning = scanCtrl.state.value == ScanState.scanning;

          return Stack(
            fit: StackFit.expand,
            children: [
              // Camera placeholder / overlay
              if (scanCtrl.state.value == ScanState.idle ||
                  scanCtrl.state.value == ScanState.scanning)
                ScanOverlay(isScanning: isScanning)
              else
                Container(color: Colors.black),

              // Analyzing shimmer text
              if (isScanning)
                Center(
                  child: Shimmer.fromColors(
                    baseColor: AppColors.accent,
                    highlightColor: AppColors.accent.withOpacity(0.4),
                    child: Text(
                      'Analyzing your device...',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                ),

              // Bottom action panel
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(AppDimensions.padding),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.only(
                      topLeft:
                          Radius.circular(AppDimensions.borderRadiusLarge),
                      topRight:
                          Radius.circular(AppDimensions.borderRadiusLarge),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.camera_alt),
                              label: const Text('Scan with Camera'),
                              onPressed: isScanning
                                  ? null
                                  : () => scanCtrl.scanFromCamera(),
                            ),
                          ),
                          SizedBox(width: AppDimensions.gapMedium),
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.image),
                              label: const Text('Upload from Gallery'),
                              onPressed: isScanning
                                  ? null
                                  : () => scanCtrl.scanFromGallery(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppDimensions.gapMedium),
                      Text(
                        'Tip: Hold your phone so the back is visible',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.secondary,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
