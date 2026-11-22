import * as React from "react"
import { cva, type VariantProps } from "class-variance-authority"
import { Button } from "./button.js"
import { Loader } from "../loader.js"
import { cn } from "../utils.js"

const alertVariants = cva(
  "relative grid w-full grid-cols-[0_1fr] items-start gap-y-0.5 rounded-lg  px-4 py-3 text-sm has-[>svg]:grid-cols-[calc(var(--spacing)*4)_1fr] has-[>svg]:gap-x-3 [&>svg]:size-4 [&>svg]:translate-y-0.5 [&>svg]:text-current",
  {
    variants: {
      variant: {
        success: "ui-status-success",
        warning: "ui-status-warning",
        info: "ui-status-info",
        error: "ui-status-error",
        default: "bg-card text-card-foreground",
        destructive:
          "bg-card text-destructive-text *:data-[slot=alert-description]:text-destructive-text [&>svg]:text-current",
      },
    },
    defaultVariants: {
      variant: "default",
    },
  }
)

function Alert({
  className,
  variant = "default",
  ...props
}: React.ComponentProps<"div"> & VariantProps<typeof alertVariants>) {
  return (
    <div
      data-slot="alert"
      data-variant={variant}
      role={variant === "info" || variant === "success" ? "status" : "alert"}
      className={cn(alertVariants({ variant }), className)}
      {...props}
    />
  )
}

function AlertTitle({ className, ...props }: React.ComponentProps<"div">) {
  return (
    <div
      data-slot="alert-title"
      className={cn(
        "col-start-2 min-w-0 break-words min-h-4 font-medium tracking-tight",
        className
      )}
      {...props}
    />
  )
}

function AlertDescription({
  className,
  ...props
}: React.ComponentProps<"div">) {
  return (
    <div
      data-slot="alert-description"
      className={cn(
        "col-start-2 grid justify-items-start gap-1 text-sm text-muted-foreground [&_p]:leading-relaxed",
        className
      )}
      {...props}
    />
  )
}

export type StateViewProps = {
  state: "empty" | "loading" | "error"
  title: React.ReactNode
  description?: React.ReactNode
  action?: { label: string; onClick: () => void }
  className?: string
}
export function StateView({ state, title, description, action, className }: StateViewProps) {
  return <div data-slot="state-view" data-state={state} className={cn("ui-state-view", className)}>
    <div role={state === "error" ? "alert" : "status"} aria-atomic="true">
      {state === "loading" && <Loader label="" aria-hidden="true" size="sm" />}
      <strong>{title}</strong>{description != null && <p>{description}</p>}
    </div>
    {action && <Button type="button" variant="secondary" onClick={action.onClick}>{action.label}</Button>}
  </div>
}

export { Alert, AlertTitle, AlertDescription }
