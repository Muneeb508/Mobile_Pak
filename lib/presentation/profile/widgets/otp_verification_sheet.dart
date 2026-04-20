import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/controllers/auth_controller.dart';

class OtpVerificationSheet extends StatefulWidget {
  const OtpVerificationSheet({Key? key}) : super(key: key);

  @override
  State<OtpVerificationSheet> createState() => _OtpVerificationSheetState();
}

class _OtpVerificationSheetState extends State<OtpVerificationSheet> {
  bool _otpSent = false;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: AppDimensions.padding,
        right: AppDimensions.padding,
        top: AppDimensions.padding,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppDimensions.padding,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Phone Verification',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Get.back(),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.padding),
          if (!_otpSent) ...[
            Text('Enter your phone number to receive a one-time password.', style: TextStyle(color: AppColors.secondary)),
            SizedBox(height: AppDimensions.gapMedium),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                prefixText: '+92 ',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: AppDimensions.padding),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() => _otpSent = true);
                },
                child: Text('Send OTP'),
              ),
            ),
          ] else ...[
            Text('Enter the 4-digit OTP sent to your phone.', style: TextStyle(color: AppColors.secondary)),
            SizedBox(height: AppDimensions.gapMedium),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, letterSpacing: 8),
              decoration: InputDecoration(
                hintText: '----',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: AppDimensions.padding),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.find<AuthController>().verifyPhoneOtp();
                  Get.back();
                  Get.snackbar(
                    'Success',
                    'Phone number verified!',
                    backgroundColor: AppColors.accent,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                child: Text('Verify OTP'),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () => setState(() => _otpSent = false),
                child: Text('Use a different number'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
