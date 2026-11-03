import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';

import 'dart:async';
import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:file_selector/file_selector.dart' as selector;
import 'package:flutter/widgets.dart';
import 'package:mime/mime.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

class WantFileUploadLabels {
  final String choose, drop, readFailed;
  final String Function(String name) remove, invalidType;
  final String Function(String name, int bytes) tooLarge;
  final String Function(int count) tooMany;
  const WantFileUploadLabels({
    required this.choose,
    required this.drop,
    required this.readFailed,
    required this.remove,
    required this.invalidType,
    required this.tooLarge,
    required this.tooMany,
  });
}

Future<String?> validateWantFiles(
  List<XFile> incoming, {
  required List<XFile> existing,
  required WantFileUploadLabels labels,
  List<String> extensions = const [],
  List<String> mimeTypes = const [],
  int? maxSize,
  int? maxFiles,
  bool multiple = true,
}) async {
  if (maxSize != null && maxSize < 0) {
    throw ArgumentError.value(maxSize, 'maxSize');
  }
  if (maxFiles != null && maxFiles < 1) {
    throw ArgumentError.value(maxFiles, 'maxFiles');
  }
  for (final file in incoming) {
    final name = file.name.toLowerCase(),
        mime = (file.mimeType ?? lookupMimeType(file.name) ?? '').toLowerCase();
    final allowed =
        extensions.isEmpty && mimeTypes.isEmpty ||
        extensions.any(
          (extension) => name.endsWith(
            '.${extension.replaceFirst(RegExp(r'^\.'), '').toLowerCase()}',
          ),
        ) ||
        mimeTypes.any(
          (type) => type.endsWith('/*')
              ? mime.startsWith(type.substring(0, type.length - 1))
              : mime == type,
        );
    if (!allowed) return labels.invalidType(file.name);
    try {
      if (maxSize != null && await file.length() > maxSize) {
        return labels.tooLarge(file.name, maxSize);
      }
    } catch (_) {
      return labels.readFailed;
    }
  }
  final count = multiple ? existing.length + incoming.length : incoming.length;
  final limit = multiple ? maxFiles : 1;
  return limit != null && count > limit ? labels.tooMany(limit) : null;
}

class WantFileUpload extends StatefulWidget {
  final List<XFile> files;
  final ValueChanged<List<XFile>> onChanged;
  final Widget label;
  final WantFileUploadLabels labels;
  final List<String> extensions, mimeTypes;
  final int? maxSize, maxFiles;
  final bool multiple, enabled;
  const WantFileUpload({
    super.key,
    required this.files,
    required this.onChanged,
    required this.label,
    required this.labels,
    this.extensions = const [],
    this.mimeTypes = const [],
    this.maxSize,
    this.maxFiles,
    this.multiple = true,
    this.enabled = true,
  });
  @override
  State<WantFileUpload> createState() => _WantFileUploadState();
}

class _WantFileUploadState extends State<WantFileUpload> {
  String? _error;
  bool _dragging = false, _busy = false;
  final _cancelReads = <VoidCallback>{};

  @override
  void dispose() {
    for (final cancel in _cancelReads.toList()) {
      cancel();
    }
    _cancelReads.clear();
    super.dispose();
  }

  Future<void> _add(List<XFile> incoming) async {
    if (!widget.enabled || _busy || incoming.isEmpty) return;
    setState(() => _busy = true);
    try {
      final error = await validateWantFiles(
        incoming,
        existing: widget.files,
        labels: widget.labels,
        extensions: widget.extensions,
        mimeTypes: widget.mimeTypes,
        maxSize: widget.maxSize,
        maxFiles: widget.maxFiles,
        multiple: widget.multiple,
      );
      if (!mounted || !widget.enabled) return;
      final next = widget.multiple ? [...widget.files, ...incoming] : incoming;
      final limit = widget.multiple ? widget.maxFiles : 1;
      final currentError =
          error ??
          (limit != null && next.length > limit
              ? widget.labels.tooMany(limit)
              : null);
      setState(() => _error = currentError);
      if (currentError == null) widget.onChanged(List.unmodifiable(next));
    } catch (_) {
      if (mounted) setState(() => _error = widget.labels.readFailed);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _pick() async {
    try {
      final groups = widget.extensions.isEmpty
          ? const <selector.XTypeGroup>[]
          : [
              selector.XTypeGroup(
                extensions: widget.extensions
                    .map((e) => e.replaceFirst(RegExp(r'^\.'), ''))
                    .toList(),
              ),
            ];
      final files = widget.multiple
          ? await selector.openFiles(acceptedTypeGroups: groups)
          : [?await selector.openFile(acceptedTypeGroups: groups)];
      if (mounted) await _add(files);
    } catch (_) {
      if (mounted) setState(() => _error = widget.labels.readFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final active =
        widget.enabled &&
        !_busy &&
        (ModalRoute.of(context)?.isCurrent ?? true) &&
        TickerMode.valuesOf(context).enabled;
    return WantField(
      label: widget.label,
      error: _error == null ? null : Text(_error!),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          DropRegion(
            formats: Formats.standardFormats,
            onDropOver: (event) =>
                active &&
                    event.session.allowedOperations.contains(DropOperation.copy)
                ? DropOperation.copy
                : DropOperation.none,
            onDropEnter: (_) {
              if (mounted) setState(() => _dragging = true);
            },
            onDropLeave: (_) {
              if (mounted) setState(() => _dragging = false);
            },
            onPerformDrop: (event) async {
              if (!mounted || !active) return;
              setState(() => _dragging = false);
              final files = <XFile>[];
              try {
                for (final item in event.session.items) {
                  final reader = item.dataReader;
                  if (reader == null) {
                    throw StateError('Drop data is unavailable');
                  }
                  final result = Completer<XFile>();
                  final progress = reader.getFile(null, (file) async {
                    try {
                      final picked = await readDroppedFile(
                        file.getStream(),
                        file.fileName ?? 'file',
                        maxSize: widget.maxSize,
                        isActive: () => mounted && widget.enabled,
                      );
                      if (!result.isCompleted) result.complete(picked);
                    } catch (error, stack) {
                      if (!result.isCompleted) {
                        result.completeError(error, stack);
                      }
                    }
                  }, onError: result.completeError);
                  if (progress == null) {
                    throw StateError('Drop does not contain a file');
                  }
                  void cancel() {
                    if (progress.cancellable.value) progress.cancel();
                    if (!result.isCompleted) {
                      result.completeError(
                        StateError('Drop owner was disposed'),
                      );
                    }
                  }

                  _cancelReads.add(cancel);
                  try {
                    files.add(await result.future);
                  } finally {
                    _cancelReads.remove(cancel);
                  }
                }
                if (mounted) await _add(files);
              } on FileReadLimitExceeded catch (error) {
                if (mounted) {
                  setState(
                    () => _error = widget.labels.tooLarge(
                      error.name,
                      error.limit,
                    ),
                  );
                }
              } catch (_) {
                if (mounted) setState(() => _error = widget.labels.readFailed);
              }
            },
            child: AnimatedContainer(
              duration: WantTheme.reducedMotionOf(context)
                  ? Duration.zero
                  : const Duration(milliseconds: 120),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: WantTheme.of(context)
                    .color(_dragging && active ? 'accent' : 'secondary'),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 12,
                children: [
                  Text(widget.labels.drop, textAlign: TextAlign.center),
                  WantButton(
                    onPressed: active ? _pick : null,
                    variant: WantButtonVariant.secondary,
                    child: Text(widget.labels.choose),
                  ),
                ],
              ),
            ),
          ),
          for (var index = 0; index < widget.files.length; index++)
            WantMotionBuilder(
              key: ValueKey((widget.files[index], index)),
              duration: const Duration(milliseconds: 180),
              repeat: false,
              builder: (context, phase) {
                final t = WantTheme.reducedMotionOf(context)
                    ? 1.0
                    : Curves.easeOutCubic.transform(phase);
                return Opacity(
                  opacity: t,
                  child: Transform.translate(
                    offset: Offset(0, (1 - t) * 4),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: WantTheme.of(context).color('card'),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        spacing: 12,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: ColoredBox(
                              color: WantTheme.of(context).color('secondary'),
                              child: _FilePreview(file: widget.files[index]),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 4,
                              children: [
                                Text(
                                  widget.files[index].name,
                                  softWrap: true,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    height: 1.4,
                                  ),
                                ),
                                if (widget.files[index].name.contains('.'))
                                  Text(
                                    widget.files[index].name
                                        .split('.')
                                        .last
                                        .toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: WantTheme.of(context)
                                          .color('muted-foreground'),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          WantButton(
                            size: WantButtonSize.icon,
                            variant: WantButtonVariant.ghost,
                            semanticsLabel: widget.labels.remove(
                              widget.files[index].name,
                            ),
                            onPressed: !active
                                ? null
                                : () {
                                    setState(() => _error = null);
                                    widget.onChanged(
                                      List.unmodifiable([
                                        for (
                                          var at = 0;
                                          at < widget.files.length;
                                          at++
                                        )
                                          if (at != index) widget.files[at],
                                      ]),
                                    );
                                  },
                            child: const WantIcon(WantIcons.x, size: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _FilePreview extends StatefulWidget {
  final XFile file;
  const _FilePreview({required this.file});
  @override
  State<_FilePreview> createState() => _FilePreviewState();
}

class _FilePreviewState extends State<_FilePreview> {
  late Future<Uint8List?> _bytes;
  Future<Uint8List?> _read() async {
    final file = widget.file;
    final mime = file.mimeType ?? lookupMimeType(file.name) ?? '';
    // shortcut: previews above 10 MiB use an icon; add thumbnail decoding if larger previews are needed.
    if (!mime.startsWith('image/') || await file.length() > 10 * 1024 * 1024) {
      return null;
    }
    return file.readAsBytes();
  }

  @override
  void initState() {
    super.initState();
    _bytes = _read();
  }

  @override
  void didUpdateWidget(_FilePreview old) {
    super.didUpdateWidget(old);
    if (old.file != widget.file) _bytes = _read();
  }

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: SizedBox(
      width: 52,
      height: 52,
      child: FutureBuilder(
        future: _bytes,
        builder: (context, snapshot) => snapshot.data == null
            ? const WantIcon(WantIcons.file, size: 24)
            : Image.memory(
                snapshot.data!,
                fit: BoxFit.cover,
                cacheWidth: 104,
                errorBuilder: (_, error, stack) =>
                    const WantIcon(WantIcons.file, size: 24),
              ),
      ),
    ),
  );
}
