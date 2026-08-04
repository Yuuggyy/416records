import 'package:flutter_test/flutter_test.dart';
import 'package:records416/main.dart';

void main() {
  testWidgets('App builds', (WidgetTester tester) async {
    await tester.pumpWidget(const Records416App());
    expect(find.text('416 Records'), findsOneWidget);
  });
}
