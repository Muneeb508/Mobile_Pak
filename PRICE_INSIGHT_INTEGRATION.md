# Smart Price Insight System - Integration Guide

## Overview
The Smart Price Insight system analyzes product prices and provides intelligent feedback to buyers about whether a price is good, high, or below market.

## Files Created

### 1. **Data Models**
- **`lib/data/models/price_insight.dart`** - Model class holding label, color, icon, and insight text

### 2. **Services**
- **`lib/services/price_insight_service.dart`** - Core logic with three main methods:
  - `analyzePriceInsight()` - Main method to get price insight
  - `calculatePercentageDifference()` - Calculate % difference from average
  - `isPriceWithinMarketRange()` - Check if price is within market bounds
  
- **`lib/services/price_insight_examples.dart`** - Example usage patterns

### 3. **UI Components**
- **`lib/presentation/shared/price_insight_widget.dart`** - Reusable Flutter widget

### 4. **Tests**
- **`test/price_insight_service_test.dart`** - 16 comprehensive unit tests (all passing ✅)

---

## Price Insight Thresholds

| Status | Condition | Label | Icon | Color |
|--------|-----------|-------|------|-------|
| **Good Price** | -15% to +10% from avg | ✅ Good price | check_circle | Green |
| **High Price** | > +10% from avg | ⚠️ High price | warning_amber | Orange |
| **Below Market** | ≤ -25% from avg | 🔥 Below market | flash_on | Bright Orange |
| **Unknown** | No market data | 📊 Unknown | info_outline | Gray |

---

## Usage Examples

### Basic Usage in Flutter Widget

```dart
import 'package:mobile_pak/services/price_insight_service.dart';
import 'package:mobile_pak/presentation/shared/price_insight_widget.dart';

// Method 1: Get insight data directly
final insight = PriceInsightService.analyzePriceInsight(
  listingPrice: 45000,
  historicalAveragePrice: 50000,
  marketMinPrice: 40000,
  marketMaxPrice: 60000,
);

print(insight.label);    // "Good price ✅"
print(insight.color);    // Green
print(insight.icon);     // check_circle
print(insight.insight);  // "Fairly priced compared to market average"

// Method 2: Use the pre-built widget in your UI
PriceInsightWidget(
  listingPrice: product.priceValue,
  historicalAveragePrice: 50000,
  marketMinPrice: 40000,
  marketMaxPrice: 60000,
  showDetails: true,
)

// Method 3: Calculate percentage difference
double percentDiff = PriceInsightService.calculatePercentageDifference(
  45000, // listing price
  50000, // average price
); // Returns: -10.0
```

### Integration in Product Detail Screen

```dart
// In product_detail_screen.dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Column(
      children: [
        // ... existing code ...
        
        // Add price insight widget
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: PriceInsightWidget(
            listingPrice: product.priceValue,
            historicalAveragePrice: 50000, // Fetch from API/database
            marketMinPrice: 40000,          // Fetch from API/database
            marketMaxPrice: 60000,          // Fetch from API/database
            showDetails: true,
          ),
        ),
        
        // ... rest of the UI ...
      ],
    ),
  );
}
```

### Using with Firebase/API Data

```dart
// Example: Fetching market data from Firestore
Future<void> loadPriceInsights() async {
  final productRef = FirebaseFirestore.instance
    .collection('products')
    .doc(product.id);
  
  final marketData = await productRef.collection('marketData').doc('stats').get();
  
  final insight = PriceInsightService.analyzePriceInsight(
    listingPrice: product.priceValue,
    historicalAveragePrice: marketData['averagePrice'],
    marketMinPrice: marketData['minPrice'],
    marketMaxPrice: marketData['maxPrice'],
  );
}
```

---

## Method Documentation

### `analyzePriceInsight()`
```dart
static PriceInsight analyzePriceInsight({
  required int listingPrice,
  required int historicalAveragePrice,
  required int marketMinPrice,
  required int marketMaxPrice,
})
```
**Returns:** `PriceInsight` object with label, color, icon, and detailed insight

**Parameters:**
- `listingPrice`: Current listing price in rupees
- `historicalAveragePrice`: Average price for the same product model
- `marketMinPrice`: Lowest price in current market
- `marketMaxPrice`: Highest price in current market

---

### `calculatePercentageDifference()`
```dart
static double calculatePercentageDifference(int listingPrice, int averagePrice)
```
**Returns:** Percentage difference (-100 to ∞)

**Example:**
- `calculatePercentageDifference(45000, 50000)` → `-10.0`
- `calculatePercentageDifference(55000, 50000)` → `10.0`

---

### `isPriceWithinMarketRange()`
```dart
static bool isPriceWithinMarketRange(int listingPrice, int minPrice, int maxPrice)
```
**Returns:** `true` if price is between min and max (inclusive)

---

## Test Results

All 16 unit tests passed ✅:
- 7 tests for `analyzePriceInsight()` including edge cases
- 4 tests for `calculatePercentageDifference()`
- 5 tests for `isPriceWithinMarketRange()`

Run tests with:
```bash
flutter test test/price_insight_service_test.dart
```

---

## Real-World Example

```dart
// iPhone 13 Pro case study
Product listing: Rs 85,000
Historical average: Rs 100,000
Market range: Rs 80,000 - Rs 120,000

Result: "Below market 🔥 - This is 15% below average - great deal!"
Color: Bright Orange
Icon: Flash bolt
```

---

## Customization

To adjust thresholds, modify constants in `price_insight_service.dart`:

```dart
static const double _goodPriceLowerBound = -15;  // Change to -20 for more lenient
static const double _goodPriceUpperBound = 10;   // Change to 15 for more range
static const double _bellowMarketThreshold = -25; // Change to -30 for stricter
```

---

## Next Steps

1. **Add market data fetching** - Connect to Firebase/API to get historical averages
2. **Cache market data** - Store locally to reduce API calls
3. **Analytics** - Track which products use price insights
4. **A/B testing** - Test different threshold values with users
