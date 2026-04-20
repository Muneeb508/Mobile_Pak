import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/controllers/auth_controller.dart';

class VerificationBottomSheet extends StatefulWidget {
  const VerificationBottomSheet({Key? key}) : super(key: key);

  @override
  State<VerificationBottomSheet> createState() => _VerificationBottomSheetState();
}

class _VerificationBottomSheetState extends State<VerificationBottomSheet> {
  bool _isUploading = false;

  void _simulateUpload() async {
    setState(() => _isUploading = true);
    await Future.delayed(const Duration(seconds: 2));
    Get.find<AuthController>().verifyIdCard();
    Get.back();
    Get.snackbar(
      'Success',
      'ID Card verified successfully!',
      backgroundColor: AppColors.accent,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.padding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ID Card Verification',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Get.back(),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.gapMedium),
          Text(
            'Please upload clear photos of your ID Card front and back.',
            style: TextStyle(color: AppColors.secondary),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppDimensions.padding),
          Row(
            children: [
              Expanded(child: _buildUploadBox('Front Side')),
              SizedBox(width: AppDimensions.padding),
              Expanded(child: _buildUploadBox('Back Side')),
            ],
          ),
          SizedBox(height: AppDimensions.padding * 2),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isUploading ? null : _simulateUpload,
              child: _isUploading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Text('Submit for Verification'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadBox(String label) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.border, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.camera_alt, color: AppColors.secondary),
          SizedBox(height: 8),
          Text(label, style: TextStyle(color: AppColors.secondary)),
        ],
      ),
    );
  }
}
