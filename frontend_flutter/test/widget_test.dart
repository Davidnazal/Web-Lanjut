import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/main.dart';

void main() {
  testWidgets('App load test', (WidgetTester tester) async {
    await tester.pumpWidget(const VixionModsApp());
    expect(find.byType(VixionModsApp), findsOneWidget);
  });
}
