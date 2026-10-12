import 'package:flutter_test/flutter_test.dart';
import 'package:medicare_connect/widgets/custom_button.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('CustomButton shows label when not loading',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomButton(
                label: 'TEST BUTTON',
                onPressed: () {},
              ),
            ),
          ),
        );
        expect(find.text('TEST BUTTON'), findsOneWidget);
      });

  testWidgets('CustomButton shows spinner when loading',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomButton(
                label: 'TEST BUTTON',
                isLoading: true,
                onPressed: () {},
              ),
            ),
          ),
        );
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

  testWidgets('CustomButton is disabled when onPressed is null',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomButton(
                label: 'DISABLED',
                onPressed: null,
              ),
            ),
          ),
        );
        final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
        expect(button.onPressed, isNull);
      });
}