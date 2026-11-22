import { Children, cloneElement, isValidElement, useId, useMemo, type ReactElement, type ReactNode } from "react"
import { Input } from "./input.js"
import { Textarea } from "./textarea.js"
import { SelectTrigger } from "./select.js"
import { Checkbox } from "./checkbox.js"
import { Switch } from "./switch.js"
import { PasswordInput } from "../field-actions.js"
import { cva, type VariantProps } from "class-variance-authority"
import { cn } from "../utils.js"

import { Label } from "./label.js"
import { Separator } from "./separator.js"

function FieldSet({ className, ...props }: React.ComponentProps<"fieldset">) {
  return (
    <fieldset
      data-slot="field-set"
      className={cn(
        "flex flex-col gap-6",
        "has-[>[data-slot=checkbox-group]]:gap-3 has-[>[data-slot=radio-group]]:gap-3",
        className
      )}
      {...props}
    />
  )
}

function FieldLegend({
  className,
  variant = "legend",
  ...props
}: React.ComponentProps<"legend"> & { variant?: "legend" | "label" }) {
  return (
    <legend
      data-slot="field-legend"
      data-variant={variant}
      className={cn(
        "mb-3 font-medium",
        "data-[variant=legend]:text-base",
        "data-[variant=label]:text-sm",
        className
      )}
      {...props}
    />
  )
}

function FieldGroup({ className, ...props }: React.ComponentProps<"div">) {
  return (
    <div
      data-slot="field-group"
      className={cn(
        "group/field-group ui-field-group",
        className
      )}
      {...props}
    />
  )
}

const fieldVariants = cva(
  "group/field flex w-full gap-3 data-[invalid=true]:text-destructive-text",
  {
    variants: {
      orientation: {
        vertical: ["flex-col [&>*]:w-full [&>.sr-only]:w-auto"],
        horizontal: [
          "flex-row items-center",
          "[&>[data-slot=field-label]]:flex-auto",
          "has-[>[data-slot=field-content]]:items-start has-[>[data-slot=field-content]]:[&>[role=checkbox],[role=radio]]:mt-px",
        ],
        responsive: [
          "flex-col @md/field-group:flex-row @md/field-group:items-center [&>*]:w-full @md/field-group:[&>*]:w-auto [&>.sr-only]:w-auto",
          "@md/field-group:[&>[data-slot=field-label]]:flex-auto",
          "@md/field-group:has-[>[data-slot=field-content]]:items-start @md/field-group:has-[>[data-slot=field-content]]:[&>[role=checkbox],[role=radio]]:mt-px",
        ],
      },
    },
    defaultVariants: {
      orientation: "vertical",
    },
  }
)

type FieldPart = ReactElement<{
  children?: ReactNode; id?: string; htmlFor?: string; errors?: Array<{ message?: string } | undefined>;
  invalid?: boolean; "aria-describedby"?: string; "aria-invalid"?: React.AriaAttributes["aria-invalid"];
}>
const controls = new Set<unknown>([Input, Textarea, PasswordInput, SelectTrigger, Switch, Checkbox, "input", "textarea", "select"])

// Preserve consumer IDs and ARIA overrides when binding the first control in a composed field.
function bindField(children: ReactNode, base: string) {
  let control: FieldPart | undefined, label: FieldPart | undefined
  const hints: FieldPart[] = [], errors: FieldPart[] = []
  function inspect(nodes: ReactNode) {
    Children.forEach(nodes, child => {
      if (!isValidElement<FieldPart["props"]>(child) || child.type === Field) return
      if (controls.has(child.type)) { control ??= child; return }
      if (child.type === FieldLabel) label ??= child
      if (child.type === FieldDescription) hints.push(child)
      if (child.type === FieldError && (child.props.children || child.props.errors?.some(error => error?.message))) errors.push(child)
      inspect(child.props.children)
    })
  }
  inspect(children)
  if (!control) return children
  const id = control.props.id ?? label?.props.htmlFor ?? base
  const bound = new Map<FieldPart, Partial<FieldPart["props"]>>()
  if (label) bound.set(label, { htmlFor: label.props.htmlFor ?? id })
  const descriptions = [...hints, ...errors].map((part, index) => {
    const partId = part.props.id ?? base + "-message-" + index
    bound.set(part, { id: partId })
    return partId
  })
  bound.set(control, {
    id, "aria-describedby": control.props["aria-describedby"] ?? (descriptions.join(" ") || undefined),
    "aria-invalid": control.props["aria-invalid"] ?? (errors.length > 0 || undefined),
  })
  function bind(nodes: ReactNode): ReactNode {
    if (nodes == null || typeof nodes !== "object") return nodes
    if (!isValidElement<FieldPart["props"]>(nodes)) return Symbol.iterator in nodes ? Children.map(nodes, bind) : nodes
    if (nodes.type === Field) return nodes
    const attrs = bound.get(nodes)
    const nested = bind(nodes.props.children)
    if (nested !== nodes.props.children) return cloneElement(nodes, attrs, nested)
    return attrs ? cloneElement(nodes, attrs) : nodes
  }
  return bind(children)
}

function Field({
  className,
  orientation = "vertical",
  children,
  ...props
}: React.ComponentProps<"div"> & VariantProps<typeof fieldVariants>) {
  const base = useId()
  return (
    <div
      role="group"
      data-slot="field"
      data-orientation={orientation}
      className={cn(fieldVariants({ orientation }), className)}
      {...props}
    >{bindField(children, base)}</div>
  )
}

function FieldContent({ className, ...props }: React.ComponentProps<"div">) {
  return (
    <div
      data-slot="field-content"
      className={cn(
        "group/field-content flex flex-1 flex-col gap-1.5 leading-snug",
        className
      )}
      {...props}
    />
  )
}

function FieldLabel({
  className,
  ...props
}: React.ComponentProps<typeof Label>) {
  return (
    <Label
      data-slot="field-label"
      className={cn(
        "group/field-label peer/field-label ui-field-label",
        className
      )}
      {...props}
    />
  )
}

function FieldTitle({ className, ...props }: React.ComponentProps<"div">) {
  return (
    <div
      data-slot="field-label"
      className={cn(
        "flex w-fit items-center gap-2 text-sm leading-snug font-medium group-data-[disabled=true]/field:opacity-50",
        className
      )}
      {...props}
    />
  )
}

function FieldDescription({ className, ...props }: React.ComponentProps<"p">) {
  return (
    <p
      data-slot="field-description"
      className={cn(
        "text-sm leading-normal font-normal text-muted-foreground group-has-[[data-orientation=horizontal]]/field:text-balance",
        "last:mt-0 nth-last-2:-mt-1 [[data-variant=legend]+&]:-mt-1.5",
        "[&>a]:underline [&>a]:underline-offset-4 [&>a:hover]:text-link",
        className
      )}
      {...props}
    />
  )
}

function FieldSeparator({
  children,
  className,
  ...props
}: React.ComponentProps<"div"> & {
  children?: React.ReactNode
}) {
  return (
    <div
      data-slot="field-separator"
      data-content={!!children}
      className={cn(
        "relative -my-2 h-5 text-sm group-data-[variant=outline]/field-group:-mb-2",
        className
      )}
      {...props}
    >
      <Separator className="absolute inset-0 top-1/2" />
      {children && (
        <span
          className="relative mx-auto block w-fit bg-background px-2 text-muted-foreground"
          data-slot="field-separator-content"
        >
          {children}
        </span>
      )}
    </div>
  )
}

function FieldError({
  className,
  children,
  errors,
  ...props
}: React.ComponentProps<"div"> & {
  errors?: Array<{ message?: string } | undefined>
}) {
  const content = useMemo(() => {
    if (children) {
      return children
    }

    if (!errors?.length) {
      return null
    }

    const uniqueErrors = [
      ...new Map(errors.map((error) => [error?.message, error])).values(),
    ]

    if (uniqueErrors?.length == 1) {
      return uniqueErrors[0]?.message
    }

    return (
      <ul className="ml-4 flex list-disc flex-col gap-1">
        {uniqueErrors.map(
          (error, index) =>
            error?.message && <li key={index}>{error.message}</li>
        )}
      </ul>
    )
  }, [children, errors])

  if (!content) {
    return null
  }

  return (
    <div
      role="alert"
      data-slot="field-error"
      className={cn("text-sm font-normal text-destructive-text", className)}
      {...props}
    >
      {content}
    </div>
  )
}

export {
  Field,
  FieldLabel,
  FieldDescription,
  FieldError,
  FieldGroup,
  FieldLegend,
  FieldSeparator,
  FieldSet,
  FieldContent,
  FieldTitle,
}
