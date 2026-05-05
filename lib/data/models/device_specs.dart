class DeviceSpecs {
  final String brand;
  final String model;
  final String storage;
  final String ram;
  final String batteryHealth;
  final bool isPtaApproved;
  final int estimatedPrice;
  final double confidence;
  final String condition;

  const DeviceSpecs({
    required this.brand,
    required this.model,
    required this.storage,
    required this.ram,
    required this.batteryHealth,
    required this.isPtaApproved,
    required this.estimatedPrice,
    required this.confidence,
    required this.condition,
  });

  factory DeviceSpecs.fromJson(Map<String, dynamic> json) {
    return DeviceSpecs(
      brand: json['brand'] as String,
      model: json['model'] as String,
      storage: json['storage'] as String,
      ram: json['ram'] as String,
      batteryHealth: json['batteryHealth'] as String,
      isPtaApproved: json['isPtaApproved'] as bool,
      estimatedPrice: json['estimatedPrice'] as int,
      confidence: json['confidence'] as double,
      condition: json['condition'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'brand': brand,
      'model': model,
      'storage': storage,
      'ram': ram,
      'batteryHealth': batteryHealth,
      'isPtaApproved': isPtaApproved,
      'estimatedPrice': estimatedPrice,
      'confidence': confidence,
      'condition': condition,
    };
  }
}
