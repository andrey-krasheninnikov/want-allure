import { useT, useCatalogueLocale } from '../i18n/catalogue';
import { useState } from 'react';
import { Info, X } from 'lucide-react';
import { Button, Checkbox, Combobox, DropdownMenu, DropdownMenuTrigger, DropdownMenuContent, DropdownMenuItem,
  FileUpload, Pagination, Popover, PopoverTrigger, PopoverContent, PopoverClose, Progress,
  Table, TableCaption, TableHeader, TableBody, TableRow, TableHead, TableCell, Skeleton,
  ToastProvider, Toast, ToastTitle, ToastDescription, ToastAction, ToastClose, ToastViewport,
  TooltipProvider, Tooltip, TooltipTrigger, TooltipContent, Input } from '@want-foundation/allure-react';
import { Section } from './Section';

function DemoCheckbox() {
  const t = useT();
  const [checked, setChecked] = useState([false, true]);
  const all = checked.every(Boolean);
  return <div className="demo-stack">
    <label className="demo-check"><Checkbox checked={all ? true : checked.some(Boolean) ? 'indeterminate' : false} onCheckedChange={value => setChecked([Boolean(value), Boolean(value)])} />{t("Select all examples")}</label>
    {checked.map((value, index) => <label key={index} className="demo-check"><Checkbox checked={value} onCheckedChange={next => setChecked(current => current.map((item, at) => at === index ? Boolean(next) : item))} />{t("Example ")}{index + 1}</label>)}
    <label className="demo-check"><Checkbox disabled />{t("Disabled checkbox")}</label>
  </div>;
}

function DemoOverlays() {
  const t = useT();
  const [result, setResult] = useState('');
  return <><div className="demo-actions">
    <DropdownMenu><DropdownMenuTrigger asChild><Button variant="secondary">{t("Example actions")}</Button></DropdownMenuTrigger>
      <DropdownMenuContent><DropdownMenuItem onSelect={() => setResult(t("Edit selected."))}>{t("Edit example")}</DropdownMenuItem><DropdownMenuItem onSelect={() => setResult(t("Copy selected."))}>{t("Copy example")}</DropdownMenuItem><DropdownMenuItem disabled>{t("Archive unavailable")}</DropdownMenuItem></DropdownMenuContent>
    </DropdownMenu>
    <TooltipProvider delayDuration={200}><Tooltip><TooltipTrigger asChild><Button variant="outline" size="icon" aria-label={t("About these examples")}><Info aria-hidden="true" /></Button></TooltipTrigger><TooltipContent>{t("These examples use local state.")}</TooltipContent></Tooltip></TooltipProvider>
    <Popover><PopoverTrigger asChild><Button variant="outline">{t("Example settings")}</Button></PopoverTrigger>
      <PopoverContent aria-label={t("Example settings")}><div className="demo-stack"><h3>{t("Example settings")}</h3><label htmlFor="example-note">{t("Note")}</label><Input id="example-note" defaultValue={t("Local preview")} /><PopoverClose asChild><Button variant="secondary">{t("Close settings")}</Button></PopoverClose></div></PopoverContent>
    </Popover>
  </div><p className="demo-status" role="status">{result}</p></>;
}

function DemoFeedback() {
  const t = useT();
  const [open, setOpen] = useState(false);
  const [progress, setProgress] = useState(65);
  const [result, setResult] = useState('');
  return <ToastProvider label={t("Notification")} duration={5000}><div className="demo-stack">
    <div className="demo-actions"><Button type="button" onClick={() => setOpen(true)}>{t("Show notification")}</Button><Button type="button" variant="secondary" onClick={() => setProgress(value => value >= 100 ? 0 : Math.min(100, value + 10))}>{t("Advance progress")}</Button></div>
    <Progress label={t("Example progress")} value={progress} /><p>{progress}%</p>
    <Progress label={t("Indeterminate example")} value={null} />
    <p className="demo-status" role="status">{result}</p>
    <Toast open={open} onOpenChange={setOpen}><div><ToastTitle>{t("Example saved")}</ToastTitle><ToastDescription>{t("This change is local to the showcase.")}</ToastDescription></div>
      <ToastAction asChild altText={t("Undo the local example change")}><Button type="button" variant="secondary" onClick={() => setResult(t("Example change undone."))}>{t("Undo example")}</Button></ToastAction>
      <ToastClose aria-label={t("Dismiss notification")}><X aria-hidden="true" /></ToastClose>
    </Toast><ToastViewport label={t("Notifications ({hotkey})")} />
  </div></ToastProvider>;
}

function DemoCombobox() {
  const t = useT();
  const [value, setValue] = useState('design');
  return <Combobox label={t("Project")} name="project" value={value} onValueChange={setValue} emptyLabel={t("No projects found.")} placeholder={t("Search projects")}
    options={[{ value: 'design', label: t("Design system") }, { value: 'website', label: t("Website") }, { value: 'mobile', label: t("Mobile app") }, { value: 'archive', label: t("Archived project"), disabled: true }]} />;
}

function DemoTable() {
  const t = useT();
  const locale = useCatalogueLocale();
  const [page, setPage] = useState(1);
  const [pageSize, setPageSize] = useState(5);
  const [loading, setLoading] = useState(false);
  const [selected, setSelected] = useState<number[]>([]);
  const rows = Array.from({ length: 23 }, (_, index) => ({ id: index + 1, name: t("Example ") + (index + 1), status: index % 2 ? t("Draft") : t("Ready") }));
  return <div className="demo-stack"><Button type="button" variant="secondary" onClick={() => setLoading(value => !value)}>{t("Toggle table loading")}</Button>
    <Table aria-busy={loading}><TableCaption>{t("Local project examples")}</TableCaption><TableHeader><TableRow><TableHead>{t("Select")}</TableHead><TableHead>{t("Project")}</TableHead><TableHead>{t("Status")}</TableHead></TableRow></TableHeader>
      <TableBody>{loading ? <TableRow><TableCell colSpan={3}><Skeleton className="h-11 w-full" /><span role="status" className="sr-only">{t("Loading table preview")}</span></TableCell></TableRow> : rows.slice((page - 1) * pageSize, page * pageSize).map(row => <TableRow key={row.id} data-state={selected.includes(row.id) ? 'selected' : undefined}><TableCell><Checkbox aria-label={t("Select example ") + row.id} checked={selected.includes(row.id)} onCheckedChange={value => setSelected(current => value ? [...current, row.id] : current.filter(id => id !== row.id))} /></TableCell><TableHead scope="row">{row.name}</TableHead><TableCell>{t(row.status)}</TableCell></TableRow>)}</TableBody>
    </Table>
    <Pagination page={page} pageSize={pageSize} totalItems={rows.length} pageSizeOptions={[5, 10, 20]} onChange={(nextPage, nextSize) => { setPage(nextPage); setPageSize(nextSize); }}
      labels={{ navigation: t("Project pages"), previous: t("Previous page"), next: t("Next page"), pageSize: t("Rows per page"), page: value => t("Page ") + value, results: (from, to, total) => locale === 'ru' ? `${from}–${to} из ${total}` : `${from} to ${to} of ${total} examples` }} />
  </div>;
}

function DemoFiles() {
  const t = useT();
  const [files, setFiles] = useState<File[]>([]);
  return <FileUpload label={t("Attachments")} files={files} onFilesChange={setFiles} accept="image/*,.txt" maxSize={1024 * 1024} maxFiles={3}
    labels={{ choose: t("Choose attachments"), drop: t("Drop images or text files here. Up to 3 files, 1 MB each. Files stay in this page."), remove: name => t("Remove ") + name, invalidType: name => name + t(": choose an image or text file."), tooLarge: name => name + t(": maximum size is 1 MB."), tooMany: max => t("Choose at most ") + max + t(" files.") }} />;
}

export function AdditionalDemos() {
  const t = useT();
  return <>
    <Section title={t("Checkboxes")}><DemoCheckbox /></Section>
    <Section title={t("Menus, tooltips and popovers")}><DemoOverlays /></Section>
    <Section title={t("Notifications and progress")}><DemoFeedback /></Section>
    <Section title={t("Searchable combobox")}><DemoCombobox /></Section>
    <Section title={t("Table and pagination")}><DemoTable /></Section>
    <Section title={t("File selection")}><DemoFiles /></Section>
  </>;
}
