import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:want_allure/want_allure.dart';

import 'helpers.dart';

void main() {
  testWidgets(
    'password starts concealed and toggles without changing its value',
    (tester) async {
      final controller = TextEditingController(text: 'Example secret');
      addTearDown(controller.dispose);
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        harness(
          WantPasswordInput(
            controller: controller,
            label: const Text('Password'),
            showPasswordLabel: 'Show password',
            hidePasswordLabel: 'Hide password',
          ),
        ),
      );
      expect(
        tester.widget<EditableText>(find.byType(EditableText)).obscureText,
        isTrue,
      );
      await tester.tap(find.bySemanticsLabel('Show password'));
      await tester.pumpAndSettle(const Duration(milliseconds: 200));
      expect(
        tester.widget<EditableText>(find.byType(EditableText)).obscureText,
        isFalse,
      );
      expect(controller.text, 'Example secret');
      await tester.tap(find.bySemanticsLabel('Hide password'));
      await tester.pumpAndSettle(const Duration(milliseconds: 200));
      expect(
        tester.widget<EditableText>(find.byType(EditableText)).obscureText,
        isTrue,
      );
      expect(controller.text, 'Example secret');
      semantics.dispose();
    },
  );

  testWidgets('privacy defaults reach the platform in both visibility states', (
    tester,
  ) async {
    await tester.pumpWidget(
      harness(
        const WantPasswordInput(
          showPasswordLabel: 'Show password',
          hidePasswordLabel: 'Hide password',
        ),
      ),
    );
    await tester.showKeyboard(find.byType(EditableText));
    for (final concealed in [true, false]) {
      final configuration = _lastInputConfiguration(tester);
      expect(configuration['obscureText'], concealed);
      expect(configuration['autocorrect'], isFalse);
      expect(configuration['enableSuggestions'], isFalse);
      expect(configuration['enableIMEPersonalizedLearning'], isFalse);
      expect(configuration['smartDashesType'], '0');
      expect(configuration['smartQuotesType'], '0');
      expect(configuration.containsKey('autofill'), isFalse);
      expect(
        tester
            .widget<EditableText>(find.byType(EditableText))
            .stylusHandwritingEnabled,
        isFalse,
      );
      if (concealed) {
        await tester.tap(find.byType(WantButton));
        await tester.pumpAndSettle(const Duration(milliseconds: 200));
      }
    }
  });

  testWidgets('consumer privacy overrides survive reveal and conceal', (
    tester,
  ) async {
    await tester.pumpWidget(
      harness(
        const WantPasswordInput(
          showPasswordLabel: 'Show',
          hidePasswordLabel: 'Hide',
          autocorrect: true,
          enableSuggestions: true,
          enableIMEPersonalizedLearning: true,
          stylusHandwritingEnabled: true,
          smartDashesType: SmartDashesType.enabled,
          smartQuotesType: SmartQuotesType.enabled,
          autofillHints: [AutofillHints.newPassword],
        ),
      ),
    );
    await tester.showKeyboard(find.byType(EditableText));
    for (var i = 0; i < 3; i++) {
      final configuration = _lastInputConfiguration(tester);
      expect(configuration['autocorrect'], isTrue);
      expect(configuration['enableSuggestions'], isTrue);
      expect(configuration['enableIMEPersonalizedLearning'], isTrue);
      expect(configuration['smartDashesType'], '1');
      expect(configuration['smartQuotesType'], '1');
      expect(configuration['autofill']['hints'], [AutofillHints.newPassword]);
      expect(
        tester
            .widget<EditableText>(find.byType(EditableText))
            .stylusHandwritingEnabled,
        isTrue,
      );
      await tester.tap(find.byType(WantButton));
      await tester.pumpAndSettle(const Duration(milliseconds: 200));
    }
  });

  testWidgets('field forwards editing, focus, errors and submission', (
    tester,
  ) async {
    final controller = TextEditingController(text: 'Before');
    final focus = FocusNode();
    addTearDown(controller.dispose);
    addTearDown(focus.dispose);
    final changes = <String>[];
    String? submitted;
    await tester.pumpWidget(
      harness(
        WantPasswordInput(
          controller: controller,
          focusNode: focus,
          label: const Text('Password'),
          description: const Text('Local input'),
          error: const Text('Try another password'),
          hint: 'Enter password',
          showPasswordLabel: 'Show',
          hidePasswordLabel: 'Hide',
          onChanged: changes.add,
          onSubmitted: (value) => submitted = value,
          textInputAction: TextInputAction.done,
          inputFormatters: [LengthLimitingTextInputFormatter(16)],
        ),
      ),
    );
    await tester.enterText(find.byType(EditableText), 'Replacement');
    expect(changes, ['Replacement']);
    controller.selection = const TextSelection(baseOffset: 2, extentOffset: 6);
    await tester.pumpAndSettle(const Duration(milliseconds: 200));
    await tester.tap(find.byType(WantButton), kind: PointerDeviceKind.mouse);
    await tester.pumpAndSettle(const Duration(milliseconds: 200));
    expect(
      controller.selection,
      const TextSelection(baseOffset: 2, extentOffset: 6),
    );
    expect(focus.hasFocus, isTrue);
    expect(changes, ['Replacement']);
    expect(find.text('Try another password'), findsOneWidget);
    expect(find.text('Local input'), findsOneWidget);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    expect(submitted, 'Replacement');
  });

  testWidgets('keyboard can reach and activate the visibility action', (
    tester,
  ) async {
    final focus = FocusNode();
    addTearDown(focus.dispose);
    await tester.pumpWidget(
      harness(
        WantPasswordInput(
          focusNode: focus,
          showPasswordLabel: 'Show',
          hidePasswordLabel: 'Hide',
        ),
      ),
    );
    focus.requestFocus();
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    expect(focus.hasFocus, isFalse);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).obscureText,
      isFalse,
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pumpAndSettle();
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).obscureText,
      isTrue,
    );
  });

  testWidgets('disabled fields conceal and disable the visibility action', (
    tester,
  ) async {
    await tester.pumpWidget(
      harness(
        const WantPasswordInput(
          initialValue: 'Disabled secret',
          enabled: false,
          showPasswordLabel: 'Show',
          hidePasswordLabel: 'Hide',
        ),
      ),
    );
    expect(
      tester.widget<WantButton>(find.byType(WantButton)).onPressed,
      isNull,
    );
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).readOnly,
      isTrue,
    );
    await tester.tap(find.byType(WantButton), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).obscureText,
      isTrue,
    );
  });

  testWidgets('read-only values can be revealed and keep selection available', (
    tester,
  ) async {
    await tester.pumpWidget(
      harness(
        const WantPasswordInput(
          initialValue: 'Read-only secret',
          readOnly: true,
          showPasswordLabel: 'Show',
          hidePasswordLabel: 'Hide',
        ),
      ),
    );
    await tester.tap(find.byType(WantButton));
    await tester.pumpAndSettle();
    final field = tester.widget<EditableText>(find.byType(EditableText));
    expect(field.readOnly, isTrue);
    expect(field.obscureText, isFalse);
    expect(field.enableInteractiveSelection, isTrue);
    expect(field.controller.text, 'Read-only secret');
  });

  testWidgets('consumer controls the selection toolbar', (tester) async {
    Widget menu(BuildContext context, EditableTextState state) =>
        const Text('Consumer menu');
    await tester.pumpWidget(
      harness(
        WantPasswordInput(
          showPasswordLabel: 'Show',
          hidePasswordLabel: 'Hide',
          contextMenuBuilder: menu,
          enableInteractiveSelection: false,
        ),
      ),
    );
    for (var i = 0; i < 2; i++) {
      final field = tester.widget<EditableText>(find.byType(EditableText));
      expect(field.contextMenuBuilder, same(menu));
      expect(field.enableInteractiveSelection, isFalse);
      await tester.tap(find.byType(WantButton));
      await tester.pumpAndSettle();
    }
  });

  testWidgets(
    'both themes retain secret semantics and 44 px actions in RTL at 200%',
    (tester) async {
      tester.view.physicalSize = const Size(320, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final semantics = tester.ensureSemantics();
      for (final brightness in Brightness.values) {
        await tester.pumpWidget(
          harness(
            const WantPasswordInput(
              initialValue: 'Private value',
              label: Text('كلمة المرور'),
              showPasswordLabel: 'إظهار كلمة المرور',
              hidePasswordLabel: 'إخفاء كلمة المرور',
            ),
            brightness: brightness,
            direction: TextDirection.rtl,
            textScale: 2,
          ),
        );
        await tester.pumpAndSettle();
        final data = tester
            .getSemantics(find.byType(EditableText))
            .getSemanticsData();
        expect(data.flagsCollection.isObscured, isTrue);
        expect(data.value, isNot(contains('Private value')));
        final size = tester.getSize(find.byType(WantButton));
        expect(size.width, greaterThanOrEqualTo(44));
        expect(size.height, greaterThanOrEqualTo(44));
        expect(tester.takeException(), isNull);
        await tester.tap(find.byType(WantButton));
        await tester.pumpAndSettle();
        expect(
          tester.widget<EditableText>(find.byType(EditableText)).obscureText,
          isFalse,
        );
        await tester.pumpWidget(const SizedBox.shrink());
      }
      semantics.dispose();
    },
  );

  testWidgets('application find excludes the password even when revealed', (
    tester,
  ) async {
    await tester.pumpWidget(
      harness(
        Column(
          children: [
            const Text('Find entry'),
            const WantPasswordInput(
              initialValue: 'HiddenSearchNeedle',
              showPasswordLabel: 'Show',
              hidePasswordLabel: 'Hide',
            ),
            Builder(
              builder: (context) => WantButton(
                onPressed: () => WantWebScope.openFind(context),
                child: const Text('Open find'),
              ),
            ),
          ],
        ),
        web: true,
        find: true,
      ),
    );
    await tester.tap(find.byType(WantButton).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open find'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(EditableText).last,
      'HiddenSearchNeedle',
    );
    await tester.pumpAndSettle();
    expect(find.text('No matches'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });

  testWidgets(
    'replacing a caller-owned controller preserves ownership and callbacks',
    (tester) async {
      final first = TextEditingController(text: 'First value');
      final second = TextEditingController(text: 'Second value');
      addTearDown(first.dispose);
      addTearDown(second.dispose);
      final changes = <String>[];
      Widget field(TextEditingController controller) => harness(
        WantPasswordInput(
          controller: controller,
          initialValue: 'Ignored initial value',
          showPasswordLabel: 'Show',
          hidePasswordLabel: 'Hide',
          onChanged: changes.add,
        ),
      );
      await tester.pumpWidget(field(first));
      await tester.pumpWidget(field(second));
      expect(
        tester.widget<EditableText>(find.byType(EditableText)).controller,
        same(second),
      );
      expect(changes, isEmpty);
      second.selection = const TextSelection.collapsed(offset: 3);
      await tester.pumpAndSettle();
      expect(changes, isEmpty);
      await tester.enterText(find.byType(EditableText), 'Edited value');
      expect(changes, ['Edited value']);
      await tester.pumpWidget(const SizedBox.shrink());
      first.text = 'Still owned by caller';
      second.text = 'Still usable';
      expect(first.text, 'Still owned by caller');
      expect(second.text, 'Still usable');
    },
  );
}

Map<String, dynamic> _lastInputConfiguration(WidgetTester tester) {
  final call = tester.testTextInput.log.lastWhere(
    (call) =>
        call.method == 'TextInput.setClient' ||
        call.method == 'TextInput.updateConfig',
  );
  return Map<String, dynamic>.from(
    call.method == 'TextInput.setClient'
        ? call.arguments[1] as Map
        : call.arguments as Map,
  );
}
