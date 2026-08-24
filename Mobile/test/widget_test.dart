// Widget test untuk aplikasi WARGA 20
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:warga20/main.dart';

void main() {
  testWidgets('Warga20 app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const Warga20App());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
