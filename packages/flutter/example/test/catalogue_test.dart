import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:want_allure_example/main.dart';

void main() {
  testWidgets('standalone catalogue changes language and preserves controls', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const WantCatalogue());
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('One Want. Every platform.'), findsOneWidget);
    await tester.tap(find.text('Switch to Russian'));
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('Один Want. На любой платформе.'), findsOneWidget);
    expect(find.text('Кнопки'), findsOneWidget);
    expect(find.text('Переключить на английский'), findsOneWidget);
    expect(find.text('Open dialog'), findsNothing);
    expect(
      tester
          .widget<EditableText>(find.byType(EditableText).first)
          .controller
          .text,
      'Фиолетовый горизонт',
    );
    await tester.enterText(find.byType(EditableText).first, 'Custom title');
    await tester.ensureVisible(find.text('Переключить на английский'));
    await tester.tap(find.text('Переключить на английский'));
    await tester.pump(const Duration(milliseconds: 600));
    expect(
      tester
          .widget<EditableText>(find.byType(EditableText).first)
          .controller
          .text,
      'Custom title',
    );
    expect(find.text('Brand and theme'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
  });
}
