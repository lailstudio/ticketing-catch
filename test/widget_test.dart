import 'package:flutter_test/flutter_test.dart';

import 'package:ticketing/app.dart';

void main() {
  testWidgets('앱이 실행되고 placeholder 텍스트를 표시한다', (tester) async {
    await tester.pumpWidget(const TicketingApp());

    expect(find.text('Ticketing Practice'), findsOneWidget);
  });
}
