# Price Drop Alert System - Architecture Overview

## 🏗️ System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                      UI Layer                                   │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ProductDetailScreen          NotificationsScreen              │
│  ├─ Bell Icon Button    [🔔]  ├─ Price Drop Alerts            │
│  ├─ Watch/Unwatch      [✓]    ├─ Timestamp Display            │
│  └─ Feedback Snackbar         └─ Color-coded Status           │
│                                                                 │
│  PriceAlertButton (Reusable Widget)                           │
│  ├─ Icon state (filled/outlined)                              │
│  ├─ Tap handler                                               │
│  └─ Snackbar feedback                                         │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
                              ↕
┌─────────────────────────────────────────────────────────────────┐
│                  State Management (GetX)                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  PriceAlertController (GetxController)                        │
│  ├─ RxSet<String> watchedProductIds  [Reactive State]        │
│  ├─ RxList<PriceAlertModel> userAlerts                        │
│  │                                                             │
│  ├─ toggleAlert(userId, product)     [Add/Remove Watch]      │
│  ├─ isWatching(productId)            [Check Status]          │
│  ├─ loadUserAlerts(userId)           [Load from DB]          │
│  └─ checkAlertsForProduct(userId, product)                   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
                              ↕
┌─────────────────────────────────────────────────────────────────┐
│                    Business Logic Layer                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  PriceAlertService (Static Methods)                           │
│  ├─ Core Operations:                                          │
│  │  ├─ addAlert(userId, product)        [Create Watch]       │
│  │  ├─ removeAlert(userId, productId)   [Delete Watch]       │
│  │  ├─ isWatching(userId, productId)    [Read Status]        │
│  │  ├─ getUserAlerts(userId)            [Fetch List]         │
│  │  │                                                         │
│  │  └─ checkAndNotify(userId, product)  [Main Detection]     │
│  │     ├─ _getAlert() - fetch alert    │                    │
│  │     ├─ isPriceDrop() - detect drop  │ Price Drop           │
│  │     ├─ _createNotification() - save │ Detection            │
│  │     └─ _deactivateAlert() - mark    │ Pipeline             │
│  │                                                             │
│  ├─ Price Logic:                                              │
│  │  ├─ isPriceDrop(watched, current, threshold)              │
│  │  │  └─ Returns: true if (current ≤ watched × (1-t%))     │
│  │  └─ calculateDropPercent(watched, current)                │
│  │     └─ Returns: integer % dropped                         │
│  │                                                             │
│  └─ Helper Methods:                                           │
│     ├─ _getAlert(userId, productId)                          │
│     ├─ _createNotification(userId, alert, price)            │
│     └─ _deactivateAlert(alertId)                             │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
                              ↕
┌─────────────────────────────────────────────────────────────────┐
│                      Data Layer                                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  PriceAlertModel (Data Class)                                 │
│  ├─ id: String           [userId-productId]                  │
│  ├─ userId: String                                            │
│  ├─ productId: String                                         │
│  ├─ productTitle: String                                      │
│  ├─ watchedPrice: int    [Price at time of watch]            │
│  ├─ targetDropPercent: int [Default: 5%]                    │
│  ├─ isActive: bool       [One-time alert flag]               │
│  ├─ createdAt: DateTime                                       │
│  │                                                             │
│  ├─ getTargetPrice() → int                                   │
│  ├─ toJson() / fromJson()                                    │
│  └─ copyWith()                                                │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
                              ↕
┌─────────────────────────────────────────────────────────────────┐
│                  Firestore Database                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Collections:                                                  │
│  │                                                             │
│  ├─ price_alerts/                     [Watched Products]      │
│  │  └─ {userId}-{productId}          [Document ID]          │
│  │     ├─ userId                                              │
│  │     ├─ productId                                           │
│  │     ├─ productTitle                                        │
│  │     ├─ watchedPrice                                        │
│  │     ├─ targetDropPercent                                   │
│  │     ├─ isActive                    [One-time flag]        │
│  │     └─ createdAt                                           │
│  │                                                             │
│  └─ notifications/                    [All Alerts & Messages] │
│     └─ {notificationId}               [Document ID]          │
│        ├─ userId                                              │
│        ├─ type: "price_drop"                                  │
│        ├─ title                                               │
│        ├─ message                                             │
│        ├─ relatedProductId                                    │
│        ├─ isRead                                              │
│        └─ createdAt                                           │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🔄 Data Flow Diagrams

### Watch Product Flow
```
User Taps Bell Icon
        ↓
PriceAlertButton._toggleAlert()
        ↓
Check: User logged in?
├─ NO → Show "Please log in"
└─ YES → Continue
        ↓
alertController.toggleAlert(userId, product)
        ↓
PriceAlertService.addAlert(userId, product)
        ↓
Create PriceAlertModel {
  id: userId-productId
  watchedPrice: product.priceValue
  isActive: true
}
        ↓
Firestore: Write to price_alerts collection
        ↓
RxSet.add(productId) → Reactive update
        ↓
Icon turns Blue [🔵🔔]
        ↓
Show Snackbar: "Price alert set!"
```

### Price Drop Detection Flow
```
ProductDetailScreen opens
        ↓
initState() calls _checkPriceAlerts()
        ↓
priceAlertController.checkAlertsForProduct(userId, product)
        ↓
PriceAlertService.checkAndNotify(userId, product)
        ↓
_getAlert(userId, product.id)
├─ Firestore query: price_alerts/{userId}-{productId}
└─ Returns: PriceAlertModel or null
        ↓
Alert exists? 
├─ NO → Exit early
└─ YES → Continue
        ↓
isPriceDrop(alert.watchedPrice, product.priceValue, alert.targetDropPercent)
        ↓
Calculate: targetPrice = watchedPrice × (1 - dropPercent/100).round()
        ↓
Check: currentPrice ≤ targetPrice?
├─ NO → Exit (no drop)
└─ YES → Price dropped!
        ↓
_createNotification(userId, alert, currentPrice)
        ↓
Create NotificationModel {
  type: "price_drop"
  title: "Price Drop: {productTitle}"
  message: "Price dropped by X%! Now PKR {price}"
  relatedProductId: alert.productId
}
        ↓
Firestore: Write to notifications collection
        ↓
_deactivateAlert(alertId)
        ↓
Firestore: Update price_alerts/{alertId} {isActive: false}
        ↓
NotificationsScreen updates (real-time via StreamBuilder)
        ↓
✅ User sees new alert with green badge
```

### View Notifications Flow
```
User taps Notifications icon
        ↓
Navigate to NotificationsScreen()
        ↓
StreamBuilder listens to:
  Firestore: notifications
  └─ where: userId == currentUser.id
  └─ orderBy: createdAt (descending)
        ↓
Real-time updates:
  ├─ New notification added → Appears instantly
  ├─ Notification read → Icon updates
  └─ Empty state → Shows helpful message
        ↓
Display:
  ├─ Green badge for price_drop type
  ├─ Relative timestamp (2h ago)
  ├─ Price drop details
  └─ Tap to navigate to product
```

---

## 📦 Module Dependencies

```
UI Layer
├─ PriceAlertButton
│  └─ depends on: PriceAlertController, AuthController
│
├─ ProductDetailScreen
│  └─ depends on: PriceAlertButton, PriceAlertController, PriceAlertService
│
└─ NotificationsScreen
   └─ depends on: NotificationModel, Firestore

State Management
└─ PriceAlertController
   └─ depends on: PriceAlertService, PriceAlertModel

Business Logic
└─ PriceAlertService (static methods)
   ├─ depends on: PriceAlertModel, Product
   └─ depends on: Firestore, NotificationModel

Data Models
├─ PriceAlertModel
│  └─ depends on: (none)
├─ NotificationModel (existing)
│  └─ depends on: (none)
└─ Product (existing)
   └─ depends on: (none)

External Services
└─ Firebase Firestore
   ├─ price_alerts collection
   └─ notifications collection
```

---

## 🧪 Testing Architecture

```
test/price_alert_service_test.dart (280 lines, 28 tests)
├─ Unit Tests (no Firestore dependency)
├─ Tests PriceAlertService static methods
├─ Tests PriceAlertModel serialization
│
├─ Price Drop Logic Tests (7)
│  ├─ isPriceDrop() with various thresholds
│  ├─ Boundary conditions
│  └─ Edge cases
│
├─ Percentage Calculation Tests (7)
│  ├─ calculateDropPercent() accuracy
│  └─ Rounding behavior
│
├─ Model Tests (8)
│  ├─ JSON serialization/deserialization
│  ├─ getTargetPrice() calculations
│  ├─ copyWith() functionality
│  └─ Default value handling
│
└─ Edge Case Tests (6)
   ├─ Floating-point precision
   ├─ Extreme values
   ├─ Realistic scenarios
   └─ All tests passing ✅ (28/28)
```

---

## 🔌 Integration Points

### 1. MainScreen Registration
```dart
// lib/presentation/main_screen.dart
Get.put(PriceAlertController());  // Initialize controller
```

### 2. ProductDetailScreen Integration
```dart
// lib/presentation/product_detail/product_detail_screen.dart

// In AppBar
PriceAlertButton(product: widget.product)

// In initState
Future<void> _checkPriceAlerts() async {
  final userId = authController.currentUser.value?.id;
  if (userId != null) {
    await alertController.checkAlertsForProduct(userId, widget.product);
  }
}
```

### 3. Notification Display
```dart
// lib/presentation/notifications/notifications_screen.dart
StreamBuilder(
  stream: FirebaseFirestore.instance
    .collection('notifications')
    .where('userId', isEqualTo: userId)
    .orderBy('createdAt', descending: true)
    .snapshots(),
  builder: (context, snapshot) { ... }
)
```

---

## 🔐 Firestore Security Rules (Example)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Price alerts: user can only access their own
    match /price_alerts/{document=**} {
      allow read, write: if request.auth.uid == resource.data.userId;
      allow create: if request.auth.uid == request.resource.data.userId;
    }
    
    // Notifications: user can read their own
    match /notifications/{document=**} {
      allow read: if request.auth.uid == resource.data.userId;
      allow create: if request.auth.uid == request.resource.data.userId;
    }
  }
}
```

---

## 📊 Performance Characteristics

| Operation | Time | Method |
|-----------|------|--------|
| Toggle watch | ~200ms | Firestore write |
| Check price | ~500ms | Firestore query |
| Create notification | ~300ms | Firestore write |
| UI update | <50ms | GetX reactivity |
| Notification display | <100ms | StreamBuilder |

---

## 🎯 Key Design Decisions

### 1. Static Methods in Service
**Why:** Simplifies API, no need to initialize service instance

### 2. One-Time Notifications
**Why:** Prevents notification spam, user can re-watch anytime

### 3. Client-Side Price Check
**Why:** Real-time on product view, no backend triggers needed

### 4. GetX Reactive State
**Why:** Instant UI updates when watch status changes

### 5. RxSet for Watched IDs
**Why:** Efficient set operations, reactive updates, clean API

### 6. Floating-Point Rounding
**Why:** Accurate price drop detection despite floating-point arithmetic

---

## 🚀 Deployment Checklist

- [x] All files created and integrated
- [x] 28 unit tests passing
- [x] Controller registered in MainScreen
- [x] Button integrated in ProductDetailScreen
- [x] Notifications screen implemented
- [x] Error handling in place
- [x] Firestore collections ready
- [x] User feedback (snackbars) implemented
- [x] Real-time updates working

---

## 📈 Future Architecture Enhancements

1. **Threshold Management**
   - Allow users to set custom drop thresholds per alert
   - Multiple thresholds for same product

2. **Price History**
   - Store price history in Firestore
   - Display price trend graph in notifications

3. **Smart Notifications**
   - Quiet hours setting
   - Batch notifications
   - Digest mode (daily summary)

4. **Category Alerts**
   - Alert on entire device model
   - Brand-wide alerts
   - Price range alerts

5. **Backend Optimization**
   - Cloud Functions for price monitoring
   - Scheduled batch notifications
   - Push notifications via FCM

---

**Architecture Version:** 1.0  
**Last Updated:** 2026-04-29  
**Status:** Production Ready ✅
