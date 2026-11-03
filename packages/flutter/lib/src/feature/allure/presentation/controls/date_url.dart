import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';
import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';

enum WantDateFieldMode { date, dateTime }

bool isWantDateInRange(DateTime value) => value.year >= 1 && value.year <= 9999;

class WantDateField extends StatefulWidget {
  final DateTime? value, today;
  final ValueChanged<DateTime?> onChanged;
  final ValueChanged<DateTime?>? onCommit;
  final WantDateFieldMode mode;
  final Widget label;
  final Widget? timeLabel;
  final String? hint, todayLabel;
  final bool enabled;
  const WantDateField({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.mode = WantDateFieldMode.date,
    this.onCommit,
    this.today,
    this.todayLabel,
    this.timeLabel,
    this.hint,
    this.enabled = true,
  }) : assert(mode == WantDateFieldMode.date || timeLabel != null);
  @override
  State<WantDateField> createState() => _WantDateFieldState();
}

class _WantDateFieldState extends State<WantDateField> {
  DateTime? _latest, _committed;
  @override
  void initState() {
    super.initState();
    _latest = _committed = widget.value;
  }

  @override
  void didUpdateWidget(WantDateField old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value) {
      if (_latest != widget.value) _committed = widget.value;
      _latest = widget.value;
    }
  }

  void _change(DateTime? value) {
    _latest = value;
    widget.onChanged(value);
  }

  void _commit() {
    if (_committed != _latest) {
      _committed = _latest;
      widget.onCommit?.call(_latest);
    }
  }

  @override
  Widget build(BuildContext context) {
    final value = widget.value;
    if (value != null && !isWantDateInRange(value)) {
      throw ArgumentError.value(
        value,
        'value',
        'Date must be within years 0001–9999',
      );
    }
    final today = widget.today ?? DateTime.now();
    if (!isWantDateInRange(today)) {
      throw ArgumentError.value(
        today,
        'today',
        'Date must be within years 0001–9999',
      );
    }
    return Focus(
      onFocusChange: (focused) {
        if (!focused) _commit();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          FDateField.calendar(
            label: widget.label,
            hint: widget.hint,
            enabled: widget.enabled,
            calendar: FDateFieldGridCalendarProperties(
              control: FGridCalendarControl(
                start: DateTime.utc(1),
                end: DateTime.utc(9999, 12, 31),
                initial: value ?? today,
                today: today,
              ),
            ),
            popoverControl: FPopoverControl.managed(
              onChange: (shown) {
                if (!shown) _commit();
              },
            ),
            selectionControl: FDateSelectionControl.liftedSingle(
              value: value,
              toggleable: false,
              onChange: (day) {
                if (day == null) {
                  _change(null);
                } else {
                  final source = value ?? today;
                  _change(
                    source.copyWith(
                      year: day.year,
                      month: day.month,
                      day: day.day,
                      hour: widget.mode == WantDateFieldMode.date
                          ? 0
                          : source.hour,
                      minute: widget.mode == WantDateFieldMode.date
                          ? 0
                          : source.minute,
                      second: 0,
                      millisecond: 0,
                      microsecond: 0,
                    ),
                  );
                }
                _commit();
              },
            ),
          ),
          if (widget.mode == WantDateFieldMode.dateTime)
            FTimeField(
              label: widget.timeLabel,
              enabled: widget.enabled,
              hour24: true,
              control: FTimeFieldControl.lifted(
                time: value == null ? null : FTime(value.hour, value.minute),
                onChange: (time) {
                  if (time != null) {
                    _change(
                      (value ?? today).copyWith(
                        hour: time.hour,
                        minute: time.minute,
                        second: 0,
                        millisecond: 0,
                        microsecond: 0,
                      ),
                    );
                  }
                },
              ),
              onEditingComplete: _commit,
            ),
          if (widget.todayLabel != null)
            WantButton(
              variant: WantButtonVariant.secondary,
              onPressed: !widget.enabled
                  ? null
                  : () {
                      _change(
                        widget.mode == WantDateFieldMode.date
                            ? today.copyWith(
                                hour: 0,
                                minute: 0,
                                second: 0,
                                millisecond: 0,
                                microsecond: 0,
                              )
                            : today.copyWith(
                                second: 0,
                                millisecond: 0,
                                microsecond: 0,
                              ),
                      );
                      _commit();
                    },
              child: Text(widget.todayLabel!),
            ),
        ],
      ),
    );
  }
}

bool isHttpUrl(String value) {
  final uri = Uri.tryParse(value.trim());
  return uri != null &&
      (uri.scheme == 'https' || uri.scheme == 'http') &&
      uri.hasAuthority &&
      uri.host.isNotEmpty;
}

class WantOpenUrl extends StatelessWidget {
  final String url, label;
  final ValueChanged<Uri> onOpen;
  const WantOpenUrl({
    super.key,
    required this.url,
    required this.label,
    required this.onOpen,
  });
  @override
  Widget build(BuildContext context) => isHttpUrl(url)
      ? WantButton(
          variant: WantButtonVariant.secondary,
          size: WantButtonSize.icon,
          semanticsLabel: label,
          onPressed: () => onOpen(Uri.parse(url.trim())),
          child: const Icon(WantIcons.arrowUpRight),
        )
      : const SizedBox.shrink();
}

class WantUrlField extends StatelessWidget {
  final TextEditingController controller;
  final Widget label;
  final String openLabel;
  final ValueChanged<Uri> onOpen;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  const WantUrlField({
    super.key,
    required this.controller,
    required this.label,
    required this.openLabel,
    required this.onOpen,
    this.onChanged,
    this.enabled = true,
  });
  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
    valueListenable: controller,
    builder: (context, value, _) => Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      spacing: 8,
      children: [
        Expanded(
          child: WantInput(
            controller: controller,
            label: label,
            hint: 'https://',
            enabled: enabled,
            onChanged: onChanged,
            keyboardType: TextInputType.url,
            textDirection: TextDirection.ltr,
          ),
        ),
        if (enabled)
          WantOpenUrl(url: value.text, label: openLabel, onOpen: onOpen),
      ],
    ),
  );
}
