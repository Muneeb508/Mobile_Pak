import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/controllers/scan_controller.dart';
import 'widgets/detected_device_card.dart';
import 'sell_screen.dart';

class DetectionResultScreen extends StatelessWidget {
  const DetectionResultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scanCtrl = Get.find<ScanController>();
    final specs = scanCtrl.detectedSpecs.value;

    if (specs == null) {
      return const Scaffold(
        body: Center(child: Text('No device detected')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Detected'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppDimensions.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Device card
            DetectedDeviceCard(specs: specs),
            SizedBox(height: AppDimensions.padding),

            // Instructions
            Text(
              'Review and edit your listing details below:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: AppDimensions.gapMedium),

            // Edit fields preview
            Container(
              padding: EdgeInsets.all(AppDimensions.paddingSmall),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius:
                    BorderRadius.circular(AppDimensions.borderRadius),
              ),
              child: Column(
                children: [
                  _SpecRow('Brand', specs.brand),
                  Divider(height: 1),
                  _SpecRow('Model', specs.model),
                  Divider(height: 1),
                  _SpecRow('Storage', specs.storage),
                  Divider(height: 1),
                  _SpecRow('Estimated Price',
                      'Rs ${specs.estimatedPrice.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',')}'),
                ],
              ),
            ),
            SizedBox(height: AppDimensions.padding),

            // Action buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check),
                label: const Text('Confirm & Continue'),
                onPressed: () {
                  Get.off(() => SellScreen(initialSpecs: specs));
                },
              ),
            ),
            SizedBox(height: AppDimensions.gapMedium),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  scanCtrl.reset();
                  Get.back();
                },
                child: const Text('Scan Again'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpecRow extends StatelessWidget {
  final String label;
  final String value;

  const _SpecRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingSmall,
        vertical: AppDimensions.gapSmall,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.secondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
