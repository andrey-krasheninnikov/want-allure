# 0004: Flutter presentation ownership and effects

Status: accepted.

The Flutter adapter remains one shared UI context. Its source lives under `feature/allure/presentation`, grouped by the owner of the component or effect. Each source directory exports direct libraries and child barrels through `_barrel.dart`. Internal consumers import the presentation root barrel. The public entrypoint explicitly selects the supported API so implementation helpers do not become package exports.

Widgets, visual controllers, focus, notification timing, selection, find and shaders belong to presentation. This adapter has no business scenario requiring domain/application orchestration. Architecture and error contracts govern future scenarios when those layers become necessary; empty layers, application DI and a new error foundation are not introduced for UI refactoring.

Notifications use a scoped toastification instance and custom Want surfaces. The public handle retains its existing ForUI-compatible dismiss/showing contract. Bottom sheets use smooth_sheets; top/left/right keep ForUI because smooth_sheets provides vertical bottom-sheet behavior. All directions preserve their public builder and result contract.

Phosphor supplies the current icon set through a Dart-compatible package. Existing Lucide exports remain available. Web interaction is an explicit WantWebScope integration with consumer labels; native platforms opt in. Application find is disabled by default through the consumer-owned `enableFind` flag. It searches rendered content without creating a DOM mirror or indexing editable fields. Shared selection registration lets adjacent text selection include control labels without placing a selection gesture recognizer over their actions. Continuous effects and indeterminate progress own repaint boundaries so they do not repaint static page content.

Shimmer and the background sphere are bundled fragment programs rendered through Canvas, which supports both Skia and Impeller. A surface owns its mutable shader and animation resources; programs are shared. Static fallbacks preserve content during load, failure and accessibility restrictions.

Release versions stay aligned across foundation, React and Flutter. Checks run locally for this release, with GitHub Actions skipped. Platform builds, rendered evidence and physical-device checks remain separate results.
