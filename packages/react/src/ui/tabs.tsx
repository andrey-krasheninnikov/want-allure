import * as React from "react"
import { cva, type VariantProps } from "class-variance-authority"
import { cn } from "../utils.js"
import { Tabs as TabsPrimitive } from "radix-ui"

function Tabs({
  className,
  orientation = "horizontal",
  ...props
}: React.ComponentProps<typeof TabsPrimitive.Root>) {
  return (
    <TabsPrimitive.Root
      data-slot="tabs"
      data-orientation={orientation}
      orientation={orientation}
      className={cn(
        "group/tabs ui-tabs-base",
        className
      )}
      {...props}
    />
  )
}

const tabsListVariants = cva(
  "group/tabs-list ui-tabs-list",
  {
    variants: {
      variant: {
        default: "bg-muted",
        line: "gap-1 bg-transparent",
      },
    },
    defaultVariants: {
      variant: "default",
    },
  }
)

function revealTab(tab: HTMLElement) {
  const list = tab.closest<HTMLElement>('[role="tablist"]')
  if (!list || list.scrollWidth <= list.clientWidth) return
  const item = tab.getBoundingClientRect(), bounds = list.getBoundingClientRect()
  const delta = item.left < bounds.left ? item.left - bounds.left : item.right > bounds.right ? item.right - bounds.right : 0
  if (delta) list.scrollBy({ left: delta, behavior: "instant" })
}

function TabsList({
  className,
  ref,
  variant = "default",
  ...props
}: React.ComponentProps<typeof TabsPrimitive.List> &
  VariantProps<typeof tabsListVariants>) {
  const list = React.useRef<HTMLDivElement>(null)
  React.useImperativeHandle(ref, () => list.current!, [])
  React.useEffect(() => {
    const element = list.current
    if (!element) return
    const revealActive = () => {
      const active = element.querySelector<HTMLElement>('[role="tab"][aria-selected="true"]')
      if (active) revealTab(active)
    }
    revealActive()
    const changes = new MutationObserver(revealActive)
    changes.observe(element, { subtree:true, childList:true, attributes:true, attributeFilter:["aria-selected"] })
    const size = new ResizeObserver(revealActive)
    size.observe(element)
    return () => { changes.disconnect(); size.disconnect() }
  }, [])
  return (
    <TabsPrimitive.List
      ref={list}
      data-slot="tabs-list"
      data-variant={variant}
      className={cn(tabsListVariants({ variant }), className)}
      {...props}
    />
  )
}

function TabsTrigger({
  className,
  onFocus,
  ...props
}: React.ComponentProps<typeof TabsPrimitive.Trigger>) {
  return (
    <TabsPrimitive.Trigger
      data-slot="tabs-trigger"
      onFocus={event => {
        onFocus?.(event)
        if (!event.defaultPrevented) revealTab(event.currentTarget)
      }}
      className={cn(
        "ui-tabs-trigger",
        className
      )}
      {...props}
    />
  )
}

function TabsContent({
  className,
  ...props
}: React.ComponentProps<typeof TabsPrimitive.Content>) {
  return (
    <TabsPrimitive.Content
      data-slot="tabs-content"
      className={cn("flex-1 outline-none", className)}
      {...props}
    />
  )
}

export { Tabs, TabsList, TabsTrigger, TabsContent, tabsListVariants }
