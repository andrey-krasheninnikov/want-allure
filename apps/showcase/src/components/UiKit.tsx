import { useT } from '../i18n/catalogue';
import { useState } from 'react';
import { Download, Info } from 'lucide-react';
import { Accordion, AccordionContent, AccordionItem, AccordionTrigger } from '@want-foundation/allure-react';
import { Alert, AlertDescription, AlertTitle } from '@want-foundation/allure-react';
import { Badge } from '@want-foundation/allure-react';
import { Breadcrumb, BreadcrumbItem, BreadcrumbLink, BreadcrumbList, BreadcrumbPage, BreadcrumbSeparator } from '@want-foundation/allure-react';
import { Button } from '@want-foundation/allure-react';
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from '@want-foundation/allure-react';
import { Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle, DialogTrigger } from '@want-foundation/allure-react';
import { Field, FieldDescription, FieldError, FieldGroup, FieldLabel } from '@want-foundation/allure-react';
import { Input } from '@want-foundation/allure-react';
import { Label } from '@want-foundation/allure-react';
import { NavigationMenu, NavigationMenuItem, NavigationMenuLink, NavigationMenuList } from '@want-foundation/allure-react';
import { RadioGroup, RadioGroupItem } from '@want-foundation/allure-react';
import { Select, SelectContent, SelectGroup, SelectItem, SelectTrigger, SelectValue } from '@want-foundation/allure-react';
import { Sheet, SheetContent, SheetDescription, SheetHeader, SheetTitle, SheetTrigger } from '@want-foundation/allure-react';
import { Skeleton } from '@want-foundation/allure-react';
import { Switch } from '@want-foundation/allure-react';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@want-foundation/allure-react';
import { Textarea } from '@want-foundation/allure-react';
import { MediaCard as WallpaperCard, type MediaCardProps as WallpaperCardData } from '@want-foundation/allure-react';
import { DemoBriefElements, DemoContact, DemoComments } from './demos';

import { Section } from './Section';
import { AdditionalDemos } from './AdditionalDemos';
import { DemoTypography, VisualDemos } from './VisualDemos';

const palette = [
  ['Background', '--background'], ['Card', '--card'], ['Secondary', '--secondary'],
  ['Foreground', '--foreground'], ['Muted text', '--muted-foreground'],
  ['Accent', '--accent'], ['Input', '--input'], ['Destructive', '--destructive'],
  ['Primary hover', '--primary-hover'], ['Primary active', '--primary-active'], ['Primary', '--primary'], ['Text link', '--link'], ['Field focus', '--ring'], ['Error', '--error'], ['Warning', '--warning'], ['Info', '--info'], ['Success', '--success'],
] as const;

export default function UiKit({ item }: { item: WallpaperCardData }) {
  const t = useT();
  const [saved, setSaved] = useState(false);
  return <div className="kit-grid">
    <Section title={t("Palette")}><div className="grid grid-cols-2 gap-4">{palette.map(([label, token]) => <div key={label}><div className="kit-swatch" style={{ backgroundColor: `var(${token})` }} /><p className="mt-2 text-sm">{t(label)}<span className="block text-muted-foreground">{token}</span></p></div>)}</div></Section>
    <Section title={t("Typography")}><DemoTypography /></Section>
    <Section title={t("Liquid glass")}><Card className="glass-surface"><CardHeader><CardTitle>{t("Compact action surface")}</CardTitle><CardDescription>{t("Neutral glass keeps the logo accent for the primary action.")}</CardDescription></CardHeader><CardContent><p>{t("Reading surfaces stay opaque. Reduced transparency uses an opaque fill.")}</p></CardContent><CardFooter><Button asChild><a href={item.href}>{t("View wallpaper")}</a></Button></CardFooter></Card></Section>
    <Section title={t("Buttons")}><div className="flex flex-wrap gap-3">{(['default', 'secondary', 'outline', 'ghost', 'link', 'destructive'] as const).map((variant) => <Button key={variant} variant={variant}>{variant}</Button>)}<Button disabled>{t("Disabled")}</Button><Button disabled aria-busy="true">{t("Saving…")}</Button><Button><Download data-icon="inline-start" />{t("Download PNG")}</Button><Button size="icon" aria-label={t("Download example")}><Download /></Button></div><p className="mt-4 text-sm text-muted-foreground">{t("Tab through controls to inspect focus. Press to inspect tactile feedback.")}</p></Section>
    <Section title={t("Fields, input and textarea")}><form onSubmit={(event) => { event.preventDefault(); setSaved(true); }}><FieldGroup>
      <Field><FieldLabel htmlFor="kit-title">{t("Wallpaper title")}</FieldLabel><Input id="kit-title" name="title" defaultValue={t("Violet Horizon")} required autoComplete="off" /><FieldDescription>{t("A complete, editable field.")}</FieldDescription></Field>
      <Field data-invalid><FieldLabel htmlFor="kit-invalid">{t("Invalid example")}</FieldLabel><Input id="kit-invalid" name="invalid-example" aria-invalid="true" aria-describedby="kit-error" defaultValue="" /><FieldError id="kit-error">{t("Enter a title before publishing.")}</FieldError></Field>
      <Field data-disabled><FieldLabel htmlFor="kit-disabled">{t("Disabled example")}</FieldLabel><Input id="kit-disabled" disabled defaultValue={t("Contours of Silence")} /></Field>
      <Field><FieldLabel htmlFor="kit-note">{t("Description")}</FieldLabel><Textarea id="kit-note" name="description" autoComplete="off" placeholder={t("Describe the wallpaper")} /></Field>
      <Button type="submit">{t("Save example")}</Button><p role="status" className="min-h-6 text-sm text-link">{saved ? t("Example saved locally.") : ''}</p>
    </FieldGroup></form></Section>
    <Section title={t("Select, radio group, label and switch")}><FieldGroup>
      <Field><FieldLabel htmlFor="kit-select">{t("Collection")}</FieldLabel><Select defaultValue="contours"><SelectTrigger id="kit-select" className="min-h-12 w-full"><SelectValue /></SelectTrigger><SelectContent><SelectGroup><SelectItem value="contours">{t("Contours of Silence")}</SelectItem><SelectItem value="woven">{t("Woven Spectrum")}</SelectItem></SelectGroup></SelectContent></Select></Field>
      <Field><FieldLabel id="kit-format-label">{t("Wallpaper format")}</FieldLabel><RadioGroup defaultValue="desktop" aria-labelledby="kit-format-label" className="flex flex-wrap gap-4"><Label htmlFor="kit-desktop"><RadioGroupItem id="kit-desktop" value="desktop" />{t("Desktop")}</Label><Label htmlFor="kit-mobile"><RadioGroupItem id="kit-mobile" value="mobile" />{t("Mobile")}</Label></RadioGroup></Field>
      <Field orientation="horizontal"><Label htmlFor="kit-switch">{t("Enable example setting")}</Label><Switch id="kit-switch" /></Field>
      <Field orientation="horizontal"><Label htmlFor="kit-switch-disabled">{t("Disabled setting")}</Label><Switch id="kit-switch-disabled" disabled /></Field>
    </FieldGroup></Section>
    <Section title={t("Tabs and accordion")}><Tabs defaultValue="desktop"><TabsList className="grid h-auto w-full grid-cols-2"><TabsTrigger value="desktop" className="min-h-11">{t("Desktop")}</TabsTrigger><TabsTrigger value="mobile" className="min-h-11">{t("Mobile")}</TabsTrigger></TabsList><TabsContent value="desktop" className="py-4 text-muted-foreground">{t("Landscape wallpaper preview.")}</TabsContent><TabsContent value="mobile" className="py-4 text-muted-foreground">{t("Portrait wallpaper preview.")}</TabsContent></Tabs><Accordion type="single" collapsible><AccordionItem value="download"><AccordionTrigger>{t("How do downloads work?")}</AccordionTrigger><AccordionContent>{t("Original PNG downloads use a native download link. They remain available without JavaScript.")}</AccordionContent></AccordionItem></Accordion></Section>
    <Section title={t("Dialog and sheet")}><div className="flex flex-wrap gap-3">
      <Dialog><DialogTrigger asChild><Button variant="outline">{t("Open dialog")}</Button></DialogTrigger><DialogContent className="glass-surface"><DialogHeader><DialogTitle>{t("Wallpaper details")}</DialogTitle><DialogDescription>{t("Contours of Silence. Original PNG for personal use.")}</DialogDescription></DialogHeader></DialogContent></Dialog>
      <Sheet><SheetTrigger asChild><Button variant="outline">{t("Open sheet")}</Button></SheetTrigger><SheetContent><SheetHeader><SheetTitle>{t("Collection navigation")}</SheetTitle><SheetDescription>{t("Choose a collection.")}</SheetDescription></SheetHeader><a href="#components" className="m-4 min-h-11 rounded-md px-4 py-3 text-link">{t("Contours of Silence")}</a></SheetContent></Sheet>
    </div></Section>
    <Section title={t("Navigation menu and breadcrumbs")}><NavigationMenu aria-label={t("Example navigation")}><NavigationMenuList><NavigationMenuItem><NavigationMenuLink asChild className="min-h-11"><a href="#components">{t("Collections")}</a></NavigationMenuLink></NavigationMenuItem><NavigationMenuItem><NavigationMenuLink asChild className="min-h-11"><a href="#components">{t("Search")}</a></NavigationMenuLink></NavigationMenuItem></NavigationMenuList></NavigationMenu><div className="h-6" aria-hidden="true" /><Breadcrumb aria-label={t("Example breadcrumbs")}><BreadcrumbList><BreadcrumbItem><BreadcrumbLink href="/">{t("Home")}</BreadcrumbLink></BreadcrumbItem><BreadcrumbSeparator /><BreadcrumbItem><BreadcrumbPage>{t("UI kit")}</BreadcrumbPage></BreadcrumbItem></BreadcrumbList></Breadcrumb></Section>
    <Section title={t("Badges and alerts")}><div className="mb-6 flex flex-wrap gap-2"><Badge>{t("Primary")}</Badge><Badge variant="secondary">{t("Desktop")}</Badge><Badge variant="outline">{t("Personal use")}</Badge><Badge variant="destructive">{t("Unavailable")}</Badge></div><Alert><Info aria-hidden="true" /><AlertTitle>{t("Preview available")}</AlertTitle><AlertDescription>{t("Download the original PNG from the wallpaper page.")}</AlertDescription></Alert><Alert variant="destructive" className="mt-4"><AlertTitle>{t("Example error")}</AlertTitle><AlertDescription>{t("Could not load the preview. Try again.")}</AlertDescription></Alert></Section>
    <Section title={t("Cards and gallery")}><WallpaperCard {...item} /><Card className="mt-6 bg-secondary"><CardHeader><CardTitle>{t("Download panel")}</CardTitle><CardDescription>{t("Original PNG for personal use.")}</CardDescription></CardHeader><CardContent><p className="text-sm text-muted-foreground">{t("Controls share the same button and field variants as the rest of the site.")}</p></CardContent><CardFooter><Button asChild><a href={item.href}>{t("Open wallpaper")}</a></Button></CardFooter></Card></Section>
    <Section title={t("Loading and empty states")}><div role="status" aria-label={t("Loading preview")} className="space-y-3"><Skeleton className="aspect-video w-full rounded-xl" /><Skeleton className="h-6 w-2/3" /><Skeleton className="h-4 w-1/2" /></div><div className="h-6" aria-hidden="true" /><p className="text-muted-foreground">{t("No matches yet. Try another word or filter.")}</p><Button variant="outline" className="mt-4">{t("Reset filters")}</Button></Section>
    <Section title={t("Contact card")}><DemoContact /></Section>
    <Section title={t("Date, URL and page layout")}><DemoBriefElements /></Section>
    <Section title={t("Comment carousel")}><DemoComments /></Section>
    <Section title={t("Liquid glass tokens")}><div className="glass-surface rounded-panel p-6"><p className="text-base">{t("Neutral glass for navigation, panels and dialogs.")}</p><p className="mt-3 text-sm text-muted-foreground">{t("68% surface tint · 20 px blur · 120% saturation. Reading surfaces stay opaque.")}</p></div></Section>
    <AdditionalDemos />
    <VisualDemos />
    <Section title={t("Usage")}><pre className="whitespace-pre-wrap break-words rounded-md bg-secondary p-4 text-sm leading-relaxed">{`import { Button } from '@want-foundation/allure-react';
import { Field, FieldLabel } from '@want-foundation/allure-react';
import { Input } from '@want-foundation/allure-react';

<Button variant="secondary">View wallpaper</Button>
<Field>
  <FieldLabel htmlFor="title">Title</FieldLabel>
  <Input id="title" />
</Field>`}</pre><p className="mt-4 text-sm text-muted-foreground">{t("Use existing primitives and semantic tokens. See DESIGN.md for composition and responsive rules.")}</p></Section>
  </div>;
}
