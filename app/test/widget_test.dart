import 'package:flutter_test/flutter_test.dart';
import 'package:kuwaitsouq/main.dart';

void main() {
  testWidgets('KuwaitSouq app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const KuwaitSouqApp());
    expect(find.byType(KuwaitSouqApp), findsOneWidget);
  });
}
