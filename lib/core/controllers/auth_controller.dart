import 'package:get/get.dart';
import '../../data/models/user_model.dart';

class AuthController extends GetxController {
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  
  bool get isLoggedIn => currentUser.value != null;
  
  // Verification states
  final RxBool isIdVerified = false.obs;
  final RxBool isPhoneVerified = false.obs;

  // Mock database
  final Map<String, String> _registeredUsers = {}; // email -> password
  final Map<String, UserModel> _userProfiles = {}; // email -> UserModel

  Future<bool> register(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network request
    if (_registeredUsers.containsKey(email)) {
      return false; // User already exists
    }
    _registeredUsers[email] = password;
    _userProfiles[email] = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      avatar: '',
      joinedAt: DateTime.now(),
      isPhoneVerified: false,
      isCnicVerified: false,
    );
    return true;
  }

  Future<bool> loginWithCredentials(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network request
    if (_registeredUsers[email] == password) {
      currentUser.value = _userProfiles[email];
      isIdVerified.value = currentUser.value?.isCnicVerified ?? false;
      isPhoneVerified.value = currentUser.value?.isPhoneVerified ?? false;
      return true;
    }
    return false;
  }

  void login() {
    // Fallback mock login (for testing without credentials)
    currentUser.value = UserModel(
      id: 'mock_user_1',
      name: 'Test User',
      avatar: '',
      joinedAt: DateTime.now(),
      isPhoneVerified: isPhoneVerified.value,
      isCnicVerified: isIdVerified.value,
    );
  }

  void logout() {
    currentUser.value = null;
    isIdVerified.value = false;
    isPhoneVerified.value = false;
  }
  
  void verifyIdCard() {
    isIdVerified.value = true;
    if (currentUser.value != null) {
      currentUser.value = currentUser.value!.copyWith(isCnicVerified: true);
    }
  }

  void verifyPhoneOtp() {
    isPhoneVerified.value = true;
    if (currentUser.value != null) {
      currentUser.value = currentUser.value!.copyWith(isPhoneVerified: true);
    }
  }
}
