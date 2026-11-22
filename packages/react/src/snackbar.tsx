import { useCallback, useState, type ComponentProps, type ReactNode } from 'react';
import { CircleCheck, CircleX, Info, SquareCheck, SquareX, SquareAsterisk, OctagonAlert, TriangleAlert, X } from 'lucide-react';
import { Toast, ToastAction, ToastClose, ToastDescription, ToastProvider, ToastTitle, ToastViewport } from './ui/toast.js';
import { Button } from './ui/button.js';
import { cn } from './utils.js';

import { ThemeIcon } from './theme-icon.js';

const alternateIcons = { error: SquareX, warning: OctagonAlert, info: SquareAsterisk, success: SquareCheck };

export type SnackbarVariant = 'error' | 'warning' | 'info' | 'success';
export type SnackbarProps = Omit<ComponentProps<typeof Toast>, 'children' | 'title'> & {
  variant: SnackbarVariant;
  variantLabel: string;
  title: ReactNode;
  description?: ReactNode;
  closeLabel: string;
  operationKey?: string;
  pending?: boolean;
  action?: { label: string; altText: string; onClick: () => void };
};
const icons = { error: CircleX, warning: TriangleAlert, info: Info, success: CircleCheck };
export function SnackbarProvider(props: ComponentProps<typeof ToastProvider>) {
  return <ToastProvider {...props} />;
}
export function SnackbarViewport({ className, ...props }: ComponentProps<typeof ToastViewport>) {
  return <ToastViewport className={cn('ui-snackbar-viewport', className)} {...props} />;
}
export type OperationNotification = Omit<SnackbarProps, 'open' | 'defaultOpen' | 'onOpenChange'> & { operationKey: string };
export function useOperationNotifications() {
  const [notifications, setNotifications] = useState<OperationNotification[]>([]);
  const update = useCallback((notification: OperationNotification) => {
    setNotifications(current => current.some(item => item.operationKey === notification.operationKey)
      ? current.map(item => item.operationKey === notification.operationKey ? notification : item)
      : [...current, notification]);
  }, []);
  const dismiss = useCallback((operationKey: string) => {
    setNotifications(current => current.filter(item => item.operationKey !== operationKey));
  }, []);
  return { notifications, update, dismiss };
}
export function Snackbar({ operationKey, pending, variant, variantLabel, title, description, closeLabel, action, className, duration = variant === 'error' ? Infinity : 5000, ...props }: SnackbarProps) {
  const Icon = icons[variant];
  return <Toast key={operationKey} data-operation-key={operationKey} data-pending={pending || undefined} type={variant === 'error' ? 'foreground' : 'background'} duration={pending ? Infinity : duration} {...props} data-slot="snackbar" data-variant={variant} className={cn('ui-snackbar', className)}>
    <span aria-hidden="true" className="ui-snackbar-icon"><ThemeIcon iconRole={variant} icon={Icon} alternate={alternateIcons[variant]} /></span>
    <div className="ui-snackbar-body" aria-live={operationKey ? 'polite' : undefined} aria-atomic={operationKey ? true : undefined}><ToastTitle className="ui-snackbar-title"><span className="sr-only">{variantLabel}: </span>{title}</ToastTitle>{description != null && <ToastDescription className="ui-snackbar-description">{description}</ToastDescription>}</div>
    <ToastClose aria-label={closeLabel} className="ui-snackbar-close"><ThemeIcon iconRole="close" icon={X} /></ToastClose>
    {action && <ToastAction asChild altText={action.altText}><Button type="button" variant="ghost" className="ui-snackbar-action" onClick={action.onClick}>{action.label}</Button></ToastAction>}
  </Toast>;
}
