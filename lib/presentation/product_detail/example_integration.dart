// Copy this code into your ProductDetailScreen to integrate Price Insight

// Add these imports at the top of product_detail_screen.dart:
// import 'package:mobile_pak/presentation/shared/price_insight_widget.dart';

// Example: Integration into the build method
/*
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('Product Details')),
    body: SingleChildScrollView(
      child: Column(
        children: [
          // ... existing image slider and product details ...

          // Add Price Insight Widget here (after price section)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: PriceInsightWidget(
              listingPrice: product.priceValue,
              historicalAveragePrice: 50000,  // TODO: Fetch from API/Firebase
              marketMinPrice: 40000,           // TODO: Fetch from API/Firebase
              marketMaxPrice: 60000,           // TODO: Fetch from API/Firebase
              showDetails: true,
            ),
          ),

          // ... rest of product details (specs, seller info, etc.) ...
        ],
      ),
    ),
  );
}
*/

// Full Example with Firebase integration:
/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_pak/presentation/shared/price_insight_widget.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Future<MarketData> _marketDataFuture;

  @override
  void initState() {
    super.initState();
    // Extract model name from product title (e.g., "iPhone 13 Pro")
    final modelName = _extractModel(widget.product.title);
    _marketDataFuture = _fetchMarketData(modelName);
  }

  Future<MarketData> _fetchMarketData(String modelName) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('marketData')
          .doc(modelName.toLowerCase().replaceAll(' ', '_'))
          .get();

      if (doc.exists) {
        return MarketData(
          averagePrice: doc['averagePrice'] ?? 50000,
          minPrice: doc['minPrice'] ?? 40000,
          maxPrice: doc['maxPrice'] ?? 60000,
        );
      }
    } catch (e) {
      print('Error fetching market data: $e');
    }

    // Fallback data
    return MarketData(
      averagePrice: 50000,
      minPrice: 40000,
      maxPrice: 60000,
    );
  }

  String _extractModel(String title) {
    // Simple extraction - adjust based on your naming convention
    final parts = title.split(' ');
    return parts.take(2).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ... existing widgets ...

            // Price Insight with Firebase data
            FutureBuilder<MarketData>(
              future: _marketDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasData) {
                  final marketData = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: PriceInsightWidget(
                      listingPrice: widget.product.priceValue,
                      historicalAveragePrice: marketData.averagePrice,
                      marketMinPrice: marketData.minPrice,
                      marketMaxPrice: marketData.maxPrice,
                      showDetails: true,
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),

            // ... rest of product details ...
          ],
        ),
      ),
    );
  }
}

class MarketData {
  final int averagePrice;
  final int minPrice;
  final int maxPrice;

  MarketData({
    required this.averagePrice,
    required this.minPrice,
    required this.maxPrice,
  });
}
*/

// Firestore Document Structure (create this in your Firebase console):
/*
Collection: marketData
Document: iphone_13_pro (or customize based on product name)
{
  "averagePrice": 100000,
  "minPrice": 80000,
  "maxPrice": 120000,
  "condition": "Good",
  "lastUpdated": Timestamp.now(),
  "totalListings": 42
}
*/

// Example with API Endpoint:
/*
Future<MarketData> _fetchMarketDataFromAPI(String productId) async {
  try {
    final response = await http.get(
      Uri.parse('https://your-api.com/api/market-data/$productId'),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return MarketData(
        averagePrice: json['averagePrice'],
        minPrice: json['minPrice'],
        maxPrice: json['maxPrice'],
      );
    }
  } catch (e) {
    print('Error: $e');
  }

  return MarketData(
    averagePrice: 50000,
    minPrice: 40000,
    maxPrice: 60000,
  );
}
*/
