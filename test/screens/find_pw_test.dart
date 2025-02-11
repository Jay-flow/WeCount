import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wecount/screens/find_pw.dart' show FindPw;
import '../test_utils.dart' show TestUtils;

void main() {
  testWidgets("Widget", (WidgetTester tester) async {
    await tester
        .pumpWidget(TestUtils.makeTestableWidget(child: const FindPw()));
    await tester.pumpAndSettle();

    var findByText = find.byType(Text);
//     logger.d(findByText.evaluate());
    expect(findByText.evaluate().isEmpty, false);

    expect(find.text('FIND_PASSWORD'), findsOneWidget);
    expect(find.text('EMAIL'), findsOneWidget);
    expect(find.text('EMAIL_HINT'), findsOneWidget);
  });
  testWidgets("Show [errorEmail] text when email address is not valid form",
      (WidgetTester tester) async {
    await tester
        .pumpWidget(TestUtils.makeTestableWidget(child: const FindPw()));
    await tester.pumpAndSettle();

    Finder emailField = find.byKey(const Key('email'));
    await tester.enterText(emailField, 'aa@aa');

    await tester.tap(find.text('SEND_EMAIL'));
    await tester.pumpAndSettle();

    expect(find.text('NO_VALID_EMAIL'), findsOneWidget);
  });
}
