import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/controllers/auth_controller.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields', backgroundColor: AppColors.error, colorText: Colors.white);
      return;
    }

    setState(() => _isLoading = true);
    final authController = Get.find<AuthController>();
    final success = await authController.loginWithCredentials(_emailController.text, _passwordController.text);
    setState(() => _isLoading = false);

    if (success) {
      Get.back(); // close login screen
      Get.snackbar('Welcome Back', 'Logged in successfully!', backgroundColor: AppColors.accent, colorText: Colors.white);
    } else {
      Get.snackbar('Login Failed', 'Invalid email or password.', backgroundColor: AppColors.error, colorText: Colors.white);
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
              Icon(Icons.lock_outline, size: 60, color: AppColors.accent),
              SizedBox(height: AppDimensions.padding),
              Text('Welcome Back', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
              SizedBox(height: AppDimensions.gapSmall),
              Text('Log in to continue to Mobile Pak', style: TextStyle(color: AppColors.secondary, fontSize: 16)),
              SizedBox(height: AppDimensions.padding * 2),
              
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
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.borderRadius)),
                  ),
                  child: _isLoading 
                      ? SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text('Login', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              
              SizedBox(height: AppDimensions.padding),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? ", style: TextStyle(color: AppColors.secondary)),
                    TextButton(
                      onPressed: () => Get.off(() => const SignupScreen()),
                      child: Text('Sign Up', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
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
