import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:want_allure/want_allure.dart';
import 'package:want_allure_example/main.dart';

void main() {
  testWidgets('categories preserve edited values across language changes', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const WantCatalogue());
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('Components in action'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) => widget is EditableText && !widget.readOnly,
      ),
      findsNothing,
    );
    tester
        .widget<WantSelect<String>>(find.byType(WantSelect<String>).first)
        .onChanged!('ru');
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('Компоненты в действии'), findsOneWidget);
    await tester.tap(find.text('Ввод'));
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.byType(WantRangeSlider), findsOneWidget);
    final field = find
        .byWidgetPredicate(
          (widget) => widget is EditableText && !widget.readOnly,
        )
        .first;
    await tester.ensureVisible(field);
    expect(
      tester.widget<EditableText>(field).controller.text,
      'Фиолетовый горизонт',
    );
    await tester.enterText(field, 'Custom title');
    final inputFocus = tester.widget<EditableText>(field).focusNode;
    expect(inputFocus.hasFocus, isTrue);
    tester.widget<WantTabs>(find.byType(WantTabs).first).onChanged(0);
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('Бренд и тема'), findsOneWidget);
    expect(inputFocus.hasFocus, isFalse);
    tester
        .widget<WantSelect<String>>(find.byType(WantSelect<String>).first)
        .onChanged!('en');
    await tester.pump(const Duration(milliseconds: 600));
    await tester.ensureVisible(find.text('Inputs'));
    await tester.tap(find.text('Inputs'));
    await tester.pump(const Duration(milliseconds: 600));
    expect(
      tester
          .widget<EditableText>(
            find
                .byWidgetPredicate(
                  (widget) => widget is EditableText && !widget.readOnly,
                )
                .first,
          )
          .controller
          .text,
      'Custom title',
    );
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
  });
  testWidgets('global effects pause synchronizes the sphere and lightning', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const WantCatalogue());
    await tester.pump(const Duration(milliseconds: 600));
    tester.widget<WantTabs>(find.byType(WantTabs).first).onChanged(5);
    await tester.pump(const Duration(milliseconds: 600));
    final controller = tester
        .widget<WantBackgroundMotion>(find.byType(WantBackgroundMotion))
        .controller;
    expect(controller.paused, isFalse);
    tester
        .widget<WantButton>(
          find.widgetWithText(WantButton, 'Pause effects').first,
        )
        .onPressed!();
    await tester.pump();
    expect(controller.paused, isTrue);
    expect(
      tester
          .widget<WantLightningBackground>(find.byType(WantLightningBackground))
          .paused,
      isTrue,
    );
    tester
        .widget<WantButton>(
          find.widgetWithText(WantButton, 'Resume effects').first,
        )
        .onPressed!();
    await tester.pump();
    expect(controller.paused, isFalse);
    controller.pause();
    tester.widget<WantTabs>(find.byType(WantTabs).first).onChanged(0);
    await tester.pump();
    tester.widget<WantTabs>(find.byType(WantTabs).first).onChanged(5);
    await tester.pump();
    expect(controller.paused, isTrue);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
  });
}
