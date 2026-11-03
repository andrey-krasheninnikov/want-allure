# Flutter component parity

The 1.1.1 Flutter adapter covers every family exported by the React adapter. Flutter uses native widget composition and callbacks. React-only trigger, portal and content parts map to builders, slots and the framework overlay system.

| Web family | Flutter API | Example section |
| --- | --- | --- |
| `ui/accordion` | `WantAccordion`, `WantAccordionItem` | disclosure |
| `ui/alert` | `WantAlert` | feedback |
| `ui/badge` | `WantBadge` | feedback |
| `ui/breadcrumb` | `WantBreadcrumb`, `WantBreadcrumbItem` | navigation |
| `ui/button` | `WantButton` | buttons |
| `ui/card` | `WantCard` | cards |
| `ui/dialog` | `WantDialog` | overlays |
| `ui/field` | `WantField`, `WantFieldGroup` | fields |
| `ui/input` | `WantInput` | fields |
| `ui/label` | `WantLabel` | fields |
| `ui/navigation-menu` | `WantNavigationMenu`, `WantNavigationItem` | navigation |
| `ui/radio-group` | `WantRadioGroup` | selection |
| `ui/select` | `WantSelect`, `WantOption` | selection |
| `ui/separator` | `WantSeparator` | feedback |
| `ui/sheet` | `WantSheet` | overlays |
| `ui/skeleton` | `WantSkeleton` | feedback |
| `ui/switch` | `WantSwitch` | selection |
| `ui/tabs` | `WantTabs`, `WantTab` | disclosure |
| `ui/textarea` | `WantTextarea` | fields |
| `brand` | `WantBrandLogo`, `WantBrandLockup` | palette |
| `media-card` | `WantMediaCard` | cards |
| `contact-card` | `WantContactCard`, `WantContactAction` | contact |
| `theme-toggle` | `WantThemeToggle` | palette |
| `comment-feed` | `WantCommentFeed`, `WantComment`, `WantCommentAction` | comments |
| `direction-provider` | `WantDirectionProvider` | navigation |
| `date-field` | `WantDateField` | date-url-window |
| `url-field` | `WantUrlField`, `WantOpenUrl` | date-url-window |
| `window` | `WantWindow` | date-url-window |
| `ui/checkbox` | `WantCheckbox` | selection |
| `ui/dropdown-menu` | `WantDropdownMenu`, `WantMenuItem` | overlays |
| `ui/tooltip` | `WantTooltip` | overlays |
| `ui/popover` | `WantPopover` | overlays |
| `ui/toast` | `WantToast`, `WantToaster` | notifications |
| `ui/progress` | `WantProgress` | feedback |
| `ui/table` | `WantTable`, `WantTableColumn` | table |
| `combobox` | `WantCombobox` | search |
| `pagination` | `WantPagination` | table |
| `file-upload` | `WantFileUpload` | files |
| `typography` | `WantTypography`, `WantProse` | typography |
| `loader` | `WantLoader` | loaders |
| `shimmer` | `WantShimmer` | shimmer |
| `animated-text` | `WantAnimatedText` | animated-text |
| `glow` | `WantGlow` | glow |
| `snackbar` | `WantSnackbar` | notifications |

The parity check compares this inventory with public React modules. The example exercises each family. Widget tests verify control behavior and edge cases; visual reference boards cover both themes. A module count alone does not prove device behavior.

Date values are calendar wall times, with years 0001–9999. Applications own time-zone conversion, formatted business dates, persistence and routes. URL opening invokes a consumer callback only for HTTP(S).

File selection uses the platform dialog. Native and web drop data passes through the same batch validation. Dropped streams respect the configured byte limit while reading. Cancelled selection keeps existing files; no upload request is sent. Previews above 10 MiB use a file icon.

`WantToaster` owns the overlay. Toast and snackbar functions return a dismissible handle. Status colors stay on the icon plate; the surface follows the theme. Errors stay until dismissed unless a duration is supplied. A null duration is persistent. Focus, hover, accessible navigation and inactive views pause timed dismissal.

Optional effects never own product actions. The background controller has pause/resume/toggle and triggerWave. The widget owns and cancels animation resources and timers; consumers dispose controllers they create. Waves default to 8–18 second delays, preserving the separate background phase when restarted.

The 1.1.0 release adds a presentation barrel tree, Phosphor icons, toastification delivery, smooth_sheets bottom sheets, web selection/find and bundled fragment shaders. Top/left/right sheets preserve their ForUI behavior. New APIs are additive; existing Want constructors, callback contracts and notification handles remain available.
