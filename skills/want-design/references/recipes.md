# Product compositions

## Edit a record

Group a visible label, control, hint and field error. Keep the input mounted when validation fails. Give the action a clear label such as “Save address”. While saving, prevent a second submission. Announce success only after the write succeeds. For a secret, keep visibility independent from validity and clear the validation error on the next edit.

React primitives: `Field`, `FieldLabel`, `Input`, `FieldError`, `PasswordInput`, `Button`. Flutter equivalents: `WantField`, `WantInput`, `WantPasswordInput`, `WantButton`.

## Browse a searchable table

Start with a named search field, optional filters and a count. Use local filtering for in-memory rows or a controlled external query for a remote list. Keep the last selection while loading. Put one sort action in the column header. Align numerical cells and their headers on the logical end edge. Reset or clamp the current page when filtering changes the row count. Show an empty state with a way to clear filters.

React primitives: `SearchToolbar`, `Combobox`, `TableSortHead`, `TableCell`, `Pagination`, `StateView`. Flutter equivalents include `WantSearchToolbar`, `WantCombobox`, `WantTable`, `WantPagination`.

## Work through a master–detail screen

Use the sidebar for destinations and the list for records. On a wide screen, persist pane sizes by stable identifiers. Provide a narrow layout that opens one pane at a time. Keep the selected record visible when focus moves to its detail. Localize separator labels and verify arrow-key resizing in both directions.

React primitives: `Sidebar`, `ListRow`, `SplitPane`. Flutter equivalents: `WantSidebar`, `WantListRow`, `WantSplitPane`.

## Export a file

Give each concurrent export its own operation key. Show “Saving file…” while the write runs, then update that notification to “File saved” or show the failure and a retry. Keep names and icons readable on both themes. Once dismissed, the viewport should release the space for pointer input.

React primitives: `SnackbarProvider`, `SnackbarViewport`, `useOperationNotifications`, `Snackbar`. Flutter equivalents: `WantToaster` and `showWantSnackbar`. The app owns the underlying operation and error recovery.
