import 'package:get/get.dart';
import '../../data/models/user_model.dart';
import '../../data/models/product_model.dart';

class AuthController extends GetxController {
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxList<Product> userProducts = RxList<Product>([]);

  bool get isLoggedIn => currentUser.value != null;

  // Verification states
  final RxBool isIdVerified = false.obs;
  final RxBool isPhoneVerified = false.obs;

  // Mock database
  final Map<String, String> _registeredUsers = {}; // email -> password
  final Map<String, UserModel> _userProfiles = {}; // email -> UserModel
  final Map<String, List<Product>> _userListings = {}; // email -> products

  Future<bool> register(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network request
    if (_registeredUsers.containsKey(email)) {
      return false; // User already exists
    }
    _registeredUsers[email] = password;
    _userProfiles[email] = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      avatar: 'https://i.pravatar.cc/150?u=$email',
      joinedAt: DateTime.now(),
      isPhoneVerified: false,
      isCnicVerified: false,
      totalListings: 0,
      successfulDeals: 0,
      rating: 0.0,
    );
    _userListings[email] = [];
    return true;
  }

  Future<bool> loginWithCredentials(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network request
    if (_registeredUsers[email] == password) {
      currentUser.value = _userProfiles[email];
      isIdVerified.value = currentUser.value?.isCnicVerified ?? false;
      isPhoneVerified.value = currentUser.value?.isPhoneVerified ?? false;
      _loadUserProducts(email);
      return true;
    }
    return false;
  }

  void login() {
    // Fallback mock login (for testing without credentials)
    final user = UserModel(
      id: 'mock_user_1',
      name: 'Test User',
      avatar: 'https://i.pravatar.cc/150?img=12',
      joinedAt: DateTime(2023, 6, 15),
      isPhoneVerified: isPhoneVerified.value,
      isCnicVerified: isIdVerified.value,
      totalListings: 5,
      successfulDeals: 18,
      rating: 4.8,
      isTrustedSeller: true,
    );
    currentUser.value = user;
    _loadUserProducts('demo@test.com');
  }

  void logout() {
    currentUser.value = null;
    userProducts.clear();
    isIdVerified.value = false;
    isPhoneVerified.value = false;
  }

  void _loadUserProducts(String email) {
    if (!_userListings.containsKey(email)) {
      _userListings[email] = _createDemoProducts();
    }
    userProducts.assignAll(_userListings[email]!);
  }

  List<Product> _createDemoProducts() {
    final user = currentUser.value!;
    return [
      Product(
        id: '1',
        title: 'iPhone 13 Pro',
        description: 'Excellent condition, original box included. No scratches.',
        priceValue: 95000,
        images: [
          'https://images.unsplash.com/photo-1592286927505-1def25115558?w=500',
          'https://images.unsplash.com/photo-1511707267537-b85faf00021e?w=500',
        ],
        specs: ['128GB', 'Sierra Blue', 'Face ID', 'ProMotion Display'],
        location: 'Karachi, Sindh',
        distance: '2 km away',
        seller: user,
        postedAt: DateTime.now().subtract(const Duration(days: 2)),
        isVerified: true,
        isPtaApproved: true,
        isHotDeal: true,
        condition: 'Excellent',
        batteryHealth: '92%',
        storage: '128GB',
      ),
      Product(
        id: '2',
        title: 'Samsung Galaxy S21',
        description: 'Used for 8 months, like new condition. Minor wear on edges.',
        priceValue: 65000,
        images: [
          'https://images.unsplash.com/photo-1610945415295-d9bbf373f991?w=500',
          'https://images.unsplash.com/photo-1598327105666-5b89351aff97?w=500',
        ],
        specs: ['256GB', 'Phantom Violet', 'AMOLED', '120Hz Display'],
        location: 'Lahore, Punjab',
        distance: '5 km away',
        seller: user,
        postedAt: DateTime.now().subtract(const Duration(days: 5)),
        isVerified: true,
        condition: 'Very Good',
        batteryHealth: '88%',
        storage: '256GB',
      ),
      Product(
        id: '3',
        title: 'MacBook Air M1',
        description: 'Brand new, sealed box. Perfect for students and professionals.',
        priceValue: 185000,
        images: [
          'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=500',
          'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=500',
        ],
        specs: ['8GB RAM', '256GB SSD', 'Space Gray', 'M1 Chip'],
        location: 'Islamabad, ICT',
        distance: '1.5 km away',
        seller: user,
        postedAt: DateTime.now().subtract(const Duration(days: 1)),
        isVerified: true,
        isPtaApproved: true,
        condition: 'New',
        batteryHealth: '100%',
        storage: '256GB',
      ),
      Product(
        id: '4',
        title: 'iPad Pro 12.9"',
        description: 'WiFi + Cellular model, comes with Apple Pencil and case.',
        priceValue: 120000,
        images: [
          'https://images.unsplash.com/photo-1561070791-2526d30994b5?w=500',
          'https://images.unsplash.com/photo-1574438479914-5b28bc1fcd7f?w=500',
        ],
        specs: ['128GB', 'Space Gray', 'M1 Chip', 'ProMotion'],
        location: 'Karachi, Sindh',
        distance: '3 km away',
        seller: user,
        postedAt: DateTime.now().subtract(const Duration(days: 3)),
        isVerified: true,
        condition: 'Good',
        batteryHealth: '85%',
        storage: '128GB',
      ),
      Product(
        id: '5',
        title: 'Sony WH-1000XM4 Headphones',
        description: 'Noise-cancelling wireless headphones, excellent sound quality.',
        priceValue: 25000,
        images: [
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500',
          'https://images.unsplash.com/photo-1484704849700-f032a568e944?w=500',
        ],
        specs: ['Wireless', 'ANC', '30hr Battery', 'Touch Controls'],
        location: 'Lahore, Punjab',
        distance: '4 km away',
        seller: user,
        postedAt: DateTime.now().subtract(const Duration(days: 7)),
        isVerified: true,
        condition: 'Like New',
        batteryHealth: '95%',
        storage: 'N/A',
      ),
    ];
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
