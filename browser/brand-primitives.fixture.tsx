import { createRoot } from 'react-dom/client';
import { useRef, useState } from 'react';
import {
  AllureProvider, Button, Card, Combobox, DateField, Field, FieldDescription, FieldError, FieldLabel, FileUpload, MediaCard,
  PasswordInput, Popover, PopoverContent, PopoverTrigger, Snackbar, SnackbarProvider, SnackbarViewport,
  Tabs, TabsList, TabsTrigger, Table, TableHeader, TableRow, TableSortHead, useOperationNotifications, type TableSortDirection,
} from '../packages/react/src/index';

const calendarLabels = {
  date: 'Date', datetime: 'Date and time', calendar: 'Calendar', year: 'Year', previousYear: 'Previous year',
  previousMonth: 'Previous month', nextMonth: 'Next month', nextYear: 'Next year', hours: 'Hours',
  minutes: 'Minutes', today: 'Today', clear: 'Clear', apply: 'Apply',
};
const filesLabels = { choose: 'Choose', drop: 'Drop files', remove: (name: string) => 'Remove '+name,
  invalidType: (name: string) => name, tooLarge: (name: string) => name, tooMany: String };
function Fixture() {
  const [query, setQuery] = useState(''), [retry, setRetry] = useState(false), [date, setDate] = useState('2026-11-18');
  const [sort, setSort] = useState<TableSortDirection>('none'), [files, setFiles] = useState<File[]>([]);
  const [tab, setTab] = useState('first');
  const password = useRef<HTMLInputElement>(null);
  const { notifications, update, dismiss } = useOperationNotifications();
  function notify(pending: boolean) {
    update({ operationKey: 'save', variant: pending ? 'info' : 'success', pending, variantLabel: pending ? 'Information' : 'Success',
      closeLabel: 'Dismiss', title: pending ? 'Saving' : 'Saved' });
  }
  return <AllureProvider data-testid="outer" profile={{schemaVersion:1, brandColor:'#cc2244', radii:{action:9}, density:'compact', fonts:{body:'outer'}}} mode="light" resources={{fonts:{outer:'Outside Sans'}}}>
    <Button>Outer action</Button>
    <AllureProvider data-testid="inner" profile={{schemaVersion:1, brandColor:'#3377aa', radii:{action:17}, motion:'off', surface:'flat'}} mode="dark" dir="rtl">
      <Button>Inner action</Button><Button busy>Busy</Button><Card data-testid="flat-card">Flat</Card>
      <div style={{width:190}}><Tabs value={tab} onValueChange={setTab} dir="rtl">
        <TabsList aria-label="Examples">{['first','second','third','fourth','last'].map(item =>
          <TabsTrigger key={item} value={item}>Section {item}</TabsTrigger>)}</TabsList>
      </Tabs></div><Button onClick={() => setTab('last')}>Last section</Button>
      <Popover><PopoverTrigger asChild><Button>Open popover</Button></PopoverTrigger><PopoverContent>Scoped overlay</PopoverContent></Popover>
    </AllureProvider>
    <Field><FieldLabel>Password</FieldLabel><PasswordInput ref={password} showLabel="Show" hideLabel="Hide" defaultValue="example" />
      <FieldDescription>Password hint</FieldDescription><FieldError>Required</FieldError></Field>
    <Button onClick={() => password.current?.focus()}>Focus password</Button>
    <Combobox label="Find" value="" onValueChange={() => {}} options={[{value:'sample',label:'Result'}]}
      filterMode="external" query={query} onQueryChange={setQuery} errorLabel={query && !retry ? 'Offline' : undefined}
      onRetry={() => setRetry(true)} retryLabel="Retry" emptyLabel="No matches" />
    <DateField mode="date" value={date} onChange={setDate} locale="en" today="2026-11-25" labels={calendarLabels}
      min="2026-11-17" max="2026-11-21" firstDayOfWeek={0} />
    <Table><TableHeader><TableRow><TableSortHead sort={sort} onSortChange={setSort} numeric>Amount</TableSortHead></TableRow></TableHeader></Table>
    <SnackbarProvider><Button onClick={() => notify(true)}>Start</Button><Button onClick={() => notify(false)}>Finish</Button>
      {notifications.map(item => <Snackbar key={item.operationKey} {...item} onOpenChange={open => { if (!open) dismiss(item.operationKey); }} />)}
      <SnackbarViewport /></SnackbarProvider>
    <FileUpload label="Attachment" files={files} onFilesChange={setFiles} labels={filesLabels} previewMaxSize={8} />
    <MediaCard title="Cover" image={{src:'/missing-cover',width:300,height:200,alt:'Cover image'}} fallback="Unavailable" />
  </AllureProvider>;
}
createRoot(document.getElementById('fixture')!).render(<Fixture />);
