import 'dart:math';
import 'package:image_picker/image_picker.dart';
import '../data/models/device_specs.dart';

class DeviceRecognitionService {
  static final Random _random = Random();

  static const List<DeviceSpecs> _database = [
    DeviceSpecs(
      brand: 'Apple',
      model: 'iPhone 14 Pro Max',
      storage: '256GB',
      ram: '6GB',
      batteryHealth: '95%',
      isPtaApproved: true,
      estimatedPrice: 180000,
      confidence: 0.92,
      condition: 'Like New',
    ),
    DeviceSpecs(
      brand: 'Apple',
      model: 'iPhone 13 Pro',
      storage: '128GB',
      ram: '6GB',
      batteryHealth: '82%',
      isPtaApproved: true,
      estimatedPrice: 120000,
      confidence: 0.89,
      condition: 'Good',
    ),
    DeviceSpecs(
      brand: 'Samsung',
      model: 'Galaxy S24',
      storage: '128GB',
      ram: '8GB',
      batteryHealth: '88%',
      isPtaApproved: true,
      estimatedPrice: 140000,
      confidence: 0.91,
      condition: 'Good',
    ),
    DeviceSpecs(
      brand: 'Samsung',
      model: 'Galaxy A54',
      storage: '128GB',
      ram: '6GB',
      batteryHealth: '91%',
      isPtaApproved: false,
      estimatedPrice: 65000,
      confidence: 0.87,
      condition: 'Excellent',
    ),
    DeviceSpecs(
      brand: 'OnePlus',
      model: 'OnePlus 12',
      storage: '256GB',
      ram: '12GB',
      batteryHealth: '91%',
      isPtaApproved: false,
      estimatedPrice: 85000,
      confidence: 0.90,
      condition: 'Excellent',
    ),
    DeviceSpecs(
      brand: 'OnePlus',
      model: 'OnePlus Nord 3',
      storage: '128GB',
      ram: '8GB',
      batteryHealth: '86%',
      isPtaApproved: false,
      estimatedPrice: 52000,
      confidence: 0.85,
      condition: 'Good',
    ),
    DeviceSpecs(
      brand: 'Google',
      model: 'Pixel 8 Pro',
      storage: '256GB',
      ram: '12GB',
      batteryHealth: '100%',
      isPtaApproved: true,
      estimatedPrice: 175000,
      confidence: 0.93,
      condition: 'Like New',
    ),
    DeviceSpecs(
      brand: 'Xiaomi',
      model: 'Xiaomi 14 Ultra',
      storage: '512GB',
      ram: '16GB',
      batteryHealth: '85%',
      isPtaApproved: false,
      estimatedPrice: 95000,
      confidence: 0.88,
      condition: 'Good',
    ),
    DeviceSpecs(
      brand: 'Oppo',
      model: 'Oppo Reno 11',
      storage: '256GB',
      ram: '8GB',
      batteryHealth: '89%',
      isPtaApproved: false,
      estimatedPrice: 58000,
      confidence: 0.84,
      condition: 'Good',
    ),
    DeviceSpecs(
      brand: 'Vivo',
      model: 'Vivo V29',
      storage: '256GB',
      ram: '8GB',
      batteryHealth: '93%',
      isPtaApproved: false,
      estimatedPrice: 48000,
      confidence: 0.86,
      condition: 'Excellent',
    ),
    DeviceSpecs(
      brand: 'Nokia',
      model: 'Nokia G60',
      storage: '128GB',
      ram: '6GB',
      batteryHealth: '97%',
      isPtaApproved: true,
      estimatedPrice: 32000,
      confidence: 0.83,
      condition: 'Like New',
    ),
    DeviceSpecs(
      brand: 'Apple',
      model: 'iPhone 12',
      storage: '64GB',
      ram: '4GB',
      batteryHealth: '79%',
      isPtaApproved: true,
      estimatedPrice: 75000,
      confidence: 0.88,
      condition: 'Good',
    ),
    DeviceSpecs(
      brand: 'Samsung',
      model: 'Galaxy S23 Ultra',
      storage: '256GB',
      ram: '12GB',
      batteryHealth: '84%',
      isPtaApproved: true,
      estimatedPrice: 155000,
      confidence: 0.92,
      condition: 'Good',
    ),
    DeviceSpecs(
      brand: 'Realme',
      model: 'Realme GT 5',
      storage: '256GB',
      ram: '16GB',
      batteryHealth: '90%',
      isPtaApproved: false,
      estimatedPrice: 62000,
      confidence: 0.87,
      condition: 'Excellent',
    ),
    DeviceSpecs(
      brand: 'Apple',
      model: 'iPhone SE 3rd Gen',
      storage: '128GB',
      ram: '4GB',
      batteryHealth: '88%',
      isPtaApproved: true,
      estimatedPrice: 88000,
      confidence: 0.86,
      condition: 'Good',
    ),
  ];

  static Future<DeviceSpecs?> recognizeFromImage(XFile image) async {
    await Future.delayed(const Duration(seconds: 2));

    // 5% chance of unrecognized device
    if (_random.nextDouble() < 0.05) {
      return null;
    }

    final randomIndex = _random.nextInt(_database.length);
    final device = _database[randomIndex];

    // Vary confidence slightly (0.75-0.97)
    final adjustedConfidence = 0.75 + _random.nextDouble() * 0.22;

    return DeviceSpecs(
      brand: device.brand,
      model: device.model,
      storage: device.storage,
      ram: device.ram,
      batteryHealth: device.batteryHealth,
      isPtaApproved: device.isPtaApproved,
      estimatedPrice: device.estimatedPrice,
      confidence: adjustedConfidence,
      condition: device.condition,
    );
  }
}
