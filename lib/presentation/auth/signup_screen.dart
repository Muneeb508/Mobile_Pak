import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/controllers/auth_controller.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _handleSignup() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields', backgroundColor: AppColors.error, colorText: Colors.white);
      return;
    }

    setState(() => _isLoading = true);
    final authController = Get.find<AuthController>();
    final success = await authController.register(_nameController.text, _emailController.text, _passwordController.text);
    setState(() => _isLoading = false);

    if (success) {
      Get.off(() => const LoginScreen());
      Get.snackbar('Success', 'Account created! Please log in.', backgroundColor: AppColors.accent, colorText: Colors.white);
    } else {
      Get.snackbar('Error', 'Email already in use.', backgroundColor: AppColors.error, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppDimensions.padding * 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.person_add_outlined, size: 60, color: AppColors.accent),
              SizedBox(height: AppDimensions.padding),
              Text('Create Account', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
              SizedBox(height: AppDimensions.gapSmall),
              Text('Sign up to start buying and selling', style: TextStyle(color: AppColors.secondary, fontSize: 16)),
              SizedBox(height: AppDimensions.padding * 2),
              
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.borderRadius)),
                ),
              ),
              SizedBox(height: AppDimensions.gapMedium),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.borderRadius)),
                ),
              ),
              SizedBox(height: AppDimensions.gapMedium),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.borderRadius)),
                ),
              ),
              SizedBox(height: AppDimensions.padding * 2),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSignup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.borderRadius)),
                  ),
                  child: _isLoading 
                      ? SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text('Sign Up', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              
              SizedBox(height: AppDimensions.padding),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? ", style: TextStyle(color: AppColors.secondary)),
                    TextButton(
                      onPressed: () => Get.off(() => const LoginScreen()),
                      child: Text('Log In', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
