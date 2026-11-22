import type { ComponentProps } from 'react';
import { cn } from '../utils.js';

export function Table({ className, ...props }: ComponentProps<'table'>) {
  return <div className="ui-table-scroll" tabIndex={0}><table data-slot="table" className={cn('ui-table', className)} {...props} /></div>;
}
export function TableCaption({ className, ...props }: ComponentProps<'caption'>) {
  return <caption data-slot="table-caption" className={cn('ui-table-caption', className)} {...props} />;
}
export function TableHeader(props: ComponentProps<'thead'>) { return <thead data-slot="table-header" {...props} />; }
export function TableBody(props: ComponentProps<'tbody'>) { return <tbody data-slot="table-body" {...props} />; }
export function TableFooter(props: ComponentProps<'tfoot'>) { return <tfoot data-slot="table-footer" {...props} />; }
export function TableRow({ className, ...props }: ComponentProps<'tr'>) {
  return <tr data-slot="table-row" className={cn('ui-table-row', className)} {...props} />;
}
export function TableHead({ className, scope = 'col', numeric, ...props }: ComponentProps<'th'> & { numeric?: boolean }) {
  return <th data-slot="table-head" scope={scope} data-numeric={numeric || undefined} className={cn('ui-table-cell ui-table-head', className)} {...props} />;
}
export type TableSortDirection = 'none' | 'ascending' | 'descending';
export function TableSortHead({ sort, onSortChange, children, ...props }: Omit<ComponentProps<typeof TableHead>, 'aria-sort'> & {
  sort: TableSortDirection; onSortChange: (sort: TableSortDirection) => void;
}) {
  const next = sort === 'none' ? 'ascending' : sort === 'ascending' ? 'descending' : 'none';
  return <TableHead {...props} aria-sort={sort}>
    <button type="button" className="ui-table-sort" onClick={() => onSortChange(next)}>
      {children}<span aria-hidden="true">{sort === 'ascending' ? '↑' : sort === 'descending' ? '↓' : '↕'}</span>
    </button>
  </TableHead>;
}
export function TableCell({ className, numeric, ...props }: ComponentProps<'td'> & { numeric?: boolean }) {
  return <td data-slot="table-cell" data-numeric={numeric || undefined} className={cn('ui-table-cell', className)} {...props} />;
}
