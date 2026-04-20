import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_pak/app/app.dart';

void main() {
  testWidgets('App launches without error', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(MyApp), findsOneWidget);
  });
}
