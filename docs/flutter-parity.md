# Flutter component parity

The Flutter adapter in this checkout covers every family exported by the React adapter. Flutter uses native widget composition and callbacks. React-only trigger, portal and content parts map to builders, slots and the framework overlay system.

| React API | Flutter API | Example section | When to use it |
| --- | --- | --- | --- |
| [`Accordion`](../packages/react/src/ui/accordion.tsx) | `WantAccordion`, `WantAccordionItem` | disclosure | Group related answers. Keep a short question in each trigger and place links inside the expanded answer. |
| [`Alert`](../packages/react/src/ui/alert.tsx) | `WantAlert` | feedback | Keep status text visible alongside its icon. Use an inline alert for feedback that should remain with a form. |
| [`Badge`](../packages/react/src/ui/badge.tsx) | `WantBadge` | feedback | Pair the status color with a noun or state such as “Draft”. Keep the badge short enough to scan in a row. |
| [`Breadcrumb`](../packages/react/src/ui/breadcrumb.tsx) | `WantBreadcrumb`, `WantBreadcrumbItem` | navigation | Link ancestors in order and mark the current page. Keep separators out of accessible names. |
| [`Button`](../packages/react/src/ui/button.tsx) | `WantButton` | buttons | Name the outcome of the action. Keep the label stable while a pending submission blocks a second press. |
| [`Card`](../packages/react/src/ui/card.tsx) | `WantCard` | cards | Group one subject with its actions. Use the footer to align secondary actions without turning the entire surface into a nested button. |
| [`Dialog`](../packages/react/src/ui/dialog.tsx) | `WantDialog` | overlays | Provide a title, describe destructive consequences and return focus to the trigger when dismissed. |
| [`Field`](../packages/react/src/ui/field.tsx) | `WantField`, `WantFieldGroup` | fields | Keep the label, description and validation error with their control. Supply explicit IDs when integrating an existing form. |
| [`Input`](../packages/react/src/ui/input.tsx) | `WantInput`, `WantPasswordInput` | fields | Supply an autocomplete purpose for ordinary fields. Use the password component for secrets and localized reveal controls. |
| [`Label`](../packages/react/src/ui/label.tsx) | `WantLabel` | fields | Associate the visible label with its actual input. Clicking the label should focus or toggle that control. |
| [`NavigationMenu`](../packages/react/src/ui/navigation-menu.tsx) | `WantNavigationMenu`, `WantNavigationItem` | navigation | Use real destinations for navigation. Mark the active destination and allow long labels to wrap. |
| [`RadioGroup`](../packages/react/src/ui/radio-group.tsx) | `WantRadioGroup` | selection | Use one stable value per option within a named group. Keep arrow-key navigation in logical reading order. |
| [`Select`](../packages/react/src/ui/select.tsx) | `WantSelect`, `WantOption` | selection | Use a select for a short closed set. Give the trigger a field label and a localized placeholder. |
| [`Separator`](../packages/react/src/ui/separator.tsx) | `WantSeparator` | feedback | Use decorative separation only where it clarifies grouping. Give a semantic separator its intended orientation. |
| [`Sheet`](../packages/react/src/ui/sheet.tsx) | `WantSheet` | overlays | Use an overlay for short secondary tasks. Provide a title and close control and preserve the opening context. |
| [`Skeleton`](../packages/react/src/ui/skeleton.tsx) | `WantSkeleton` | feedback | Match the final content dimensions to prevent layout shifts. Announce loading once for a group of placeholders. |
| [`Switch`](../packages/react/src/ui/switch.tsx) | `WantSwitch` | selection | Label the persistent setting. Apply the change when toggled and expose the current checked value. |
| [`Tabs`](../packages/react/src/ui/tabs.tsx) | `WantTabs`, `WantTab` | disclosure | Group peer views with short labels. Keep the selected tab reachable on narrow screens and preserve keyboard navigation. |
| [`Textarea`](../packages/react/src/ui/textarea.tsx) | `WantTextarea` | fields | Supply a visible label for longer input. Preserve newlines and keep errors beside the field. |
| [`BrandLogo`](../packages/react/src/brand.tsx) | `WantBrandLogo`, `WantBrandLockup` | palette | Resolve artwork against the local brand resources and current surface. Supply meaningful alt text for a standalone mark. |
| [`MediaCard`](../packages/react/src/media-card.tsx) | `WantMediaCard` | cards | Supply intrinsic dimensions and a descriptive title. Offer a fallback when an image cannot load. |
| [`ContactCard`](../packages/react/src/contact-card.tsx) | `WantContactCard`, `WantContactAction` | contact | Keep names and actions readable in RTL. Use the contact initials when a portrait is unavailable. |
| [`ThemeToggle`](../packages/react/src/theme-toggle.tsx) | `WantThemeToggle` | palette | Use a binary toggle for light and dark. Offer the theme picker when the system preference is also available. |
| [`CommentFeed`](../packages/react/src/comment-feed.tsx) | `WantCommentFeed`, `WantComment`, `WantCommentAction` | comments | Supply the author, date, localized labels and callbacks per comment. Keep moderation and network requests in the host. |
| [`DirectionProvider`](../packages/react/src/direction-provider.ts) | `WantDirectionProvider` | navigation | Set the writing direction around the relevant subtree, including overlays. Use logical start and end alignment. |
| [`DateField`](../packages/react/src/date-field.tsx) | `WantDateField` | date-url-window | Pass wall dates and the locale. Set calendar bounds and the first weekday where the product follows a regional calendar. |
| [`UrlField`](../packages/react/src/url-field.tsx) | `WantUrlField`, `WantOpenUrl` | date-url-window | Supply the opening action and a localized accessible label. Validate protocols before sending a URL to the host. |
| [`Window`](../packages/react/src/window.tsx) | `WantWindow` | date-url-window | Give a grouped workspace a short title and its own secondary actions. Let the content wrap at narrow widths. |
| [`Checkbox`](../packages/react/src/ui/checkbox.tsx) | `WantCheckbox` | selection | Use the mixed state for partial group selection. Associate the checkbox with a visible label. |
| [`DropdownMenu`](../packages/react/src/ui/dropdown-menu.tsx) | `WantDropdownMenu`, `WantMenuItem` | overlays | Put actions in a menu with a named trigger. Preserve keyboard navigation and restore focus when it closes. |
| [`Tooltip`](../packages/react/src/ui/tooltip.tsx) | `WantTooltip` | overlays | Use a tooltip for supplementary context. Keep essential instructions visible and give icon-only controls accessible names. |
| [`Popover`](../packages/react/src/ui/popover.tsx) | `WantPopover` | overlays | Use a named trigger and dismissible content for compact choices. Keep the overlay inside the active brand scope. |
| [`Toast`](../packages/react/src/ui/toast.tsx) | `WantToast`, `WantToaster` | notifications | Mount one viewport for related notifications. Use localized dismiss labels and preserve the underlying hit area after closing. |
| [`Progress`](../packages/react/src/ui/progress.tsx) | `WantProgress` | feedback | Give the operation a label. Use an indeterminate bar while the total amount of work is unknown. |
| [`Table`](../packages/react/src/ui/table.tsx) | `WantTable`, `WantTableColumn` | table | Align headers and values on the same edge. Sort using a stable key and name the active sort direction. |
| [`Combobox`](../packages/react/src/combobox.tsx) | `WantCombobox` | search | Keep the input responsive during remote queries. Preserve the selected label when the result list changes. |
| [`Pagination`](../packages/react/src/pagination.tsx) | `WantPagination` | table | Keep page and page size controlled. Handle a shrinking result count and leave enough room for translated labels. |
| [`FileUpload`](../packages/react/src/file-upload.tsx) | `WantFileUpload` | files | Provide allowed file types and size limits. Show file-level problems beside the affected item and own network uploads in the host. |
| [`Typography`](../packages/react/src/typography.tsx) | `WantTypography`, `WantProse` | typography | Choose the heading level for document structure and the visual variant for hierarchy. Set a readable measure for prose. |
| [`Loader`](../packages/react/src/loader.tsx) | `WantLoader` | loaders | Name the pending operation once. Pause continuous animation when the surrounding content is inactive. |
| [`Shimmer`](../packages/react/src/shimmer.tsx) | `WantShimmer` | shimmer | Reserve the final content footprint. Choose a block, text, avatar or card placeholder and retain a static reduced-motion state. |
| [`AnimatedText`](../packages/react/src/animated-text.tsx) | `WantAnimatedText` | animated-text | Use a short transition for changing values. Avoid announcing every decorative frame. |
| [`Glow`](../packages/react/src/glow.tsx) | `WantGlow` | glow | Attach the effect to a bounded surface. Keep keyboard focus visible independently of the decorative glow. |
| [`Snackbar`](../packages/react/src/snackbar.tsx) | `WantSnackbar` | notifications | Use one operation key across pending, success and error. Update its message when the operation completes. |
| [`LightningBackground`](../packages/react/src/lightning-background.tsx) | `WantLightningBackground` | lightning | Keep decoration behind controls. Make motion optional and use semantic colors from the nearest theme. |
| [`Slider`](../packages/react/src/ui/slider.tsx) | `WantSlider`, `WantRangeSlider` | sliders | Name the controlled quantity and format its units. For a range, distinguish the two endpoints. |
| [`ThemePicker`](../packages/react/src/appearance-picker.tsx) | `WantThemePicker`, `WantLanguagePicker` | palette | Keep the saved preference separate from resolved light or dark mode. Localize theme labels and use native language names. |
| [`ThemeIcon`](../packages/react/src/theme-icon.tsx) | `WantIcon` | palette | Choose a semantic icon role when the brand supplies its own glyph. Hide decorative duplicates from assistive technology. |
| [`Sidebar`](../packages/react/src/workspace.tsx) | `WantSidebar`, `WantListRow`, `WantSplitPane`, `WantSearchToolbar` | pass-workspace | Collapse navigation at narrow widths. Use stable pane identifiers, named separators and a compact alternative to multiple columns. |
| [`CopyAction`](../packages/react/src/field-actions.tsx) | `WantPasswordInput`, `WantIconButton`, `WantCopyAction` | pass-field | Confirm copying only after the clipboard write succeeds. Keep the action size stable during confirmation and show errors in place. |
| [`StepIndicator`](../packages/react/src/setup.tsx) | `WantIconColorPicker`, `WantStepIndicator`, `WantScreenTransition`, `WantStateGlow` | pass-setup | Show the current step and total with a short title. Let the application own forward and back transitions. |
| [`Svg3DIcon`](../packages/react/src/scene.tsx) | `WantSvg3D`, `WantThreadsBackground`, `WantLogoWave`, `WantBackgroundMotion` | pass-motion | Provide a static drawing and an accessible name. Keep model rotation separate from activation. |

The parity check compares this inventory with public React modules. The example exercises each family. Widget tests verify control behavior and edge cases; visual reference boards cover both themes. A module count alone does not prove device behavior.

Date values are calendar wall times, with years 0001–9999. Applications own time-zone conversion, formatted business dates, persistence and routes. URL opening invokes a consumer callback only for HTTP(S).

File selection uses the platform dialog. Native and web drop data passes through the same batch validation. Dropped streams respect the configured byte limit while reading. Cancelled selection keeps existing files; no upload request is sent. Previews above 10 MiB use a file icon.

`WantToaster` owns the overlay. Toast and snackbar functions return a dismissible handle. Status colors stay on the icon plate; the surface follows the theme. Errors stay until dismissed unless a duration is supplied. A null duration is persistent. Focus, hover, accessible navigation and inactive views pause timed dismissal.

Optional effects never own product actions. The background controller has pause/resume/toggle and triggerWave. The widget owns and cancels animation resources and timers; consumers dispose controllers they create. Waves default to 8–18 second delays, preserving the separate background phase when restarted.

The 1.1.0 release adds a presentation barrel tree, Phosphor icons, toastification delivery, smooth_sheets bottom sheets, web selection/find and bundled fragment shaders. Top/left/right sheets preserve their ForUI behavior. New APIs are additive; existing Want constructors, callback contracts and notification handles remain available.

The 1.2.0 example adds English/Russian catalogues and Allure branding. Its web build participates in the unified Astro application; translations and host-page settings remain example-owned.

Both catalogues organize their shared component families into the same seven categories. Slider adapters accept controlled numeric values and callbacks; Flutter maps those values to ForUI internally. The Flutter range uses a `(start: double, end: double)` record. Lightning is a decorative background surface in both adapters; Flutter renders it through `lightning.frag`.

`WantSvg3D` and `Svg3DIcon` accept product artwork. See the Flutter README for supported SVG features and builders.
