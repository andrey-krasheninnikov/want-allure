# 0003: Want Allure naming and release

Status: accepted.

The shared design system is Want Allure. The existing GitHub repository is renamed to `andrey-krasheninnikov/want-allure`, preserving issues, pull requests and Git history. The first release under the new name is 1.0.0 across all public packages.

Foundation is published as `@want-foundation/allure`; React is `@want-foundation/allure-react` and depends on the exact matching foundation version. Flutter is `want_allure` with the public entrypoint `package:want_allure/want_allure.dart`.

The rename changes package identities, imports, resource package paths, catalogue labels and example application identifiers. Public Want-prefixed Dart APIs, React exports, CSS tokens, component behavior, the approved theme and the shared `want-design` skill retain their names and contracts. No compatibility wrappers or duplicate entrypoints are added to the new packages.

The previous npm packages are deprecated with replacement instructions only after the new packages pass hosted installation checks. The previous Flutter package is marked discontinued with `want_allure` as its suggested replacement. Existing releases remain downloadable; published versions and tags are never overwritten.

The main local checkout moves to `want-allure`. Existing linked worktrees retain their paths and contents, and their Git links are repaired. New work uses the `want-allure-worktrees` parent. Graph state is resolved from the new canonical root, without combining caches from different checkout roots.

Consumer repositories migrate separately using the [1.0.0 migration guide](../migration-1.0.0.md).
