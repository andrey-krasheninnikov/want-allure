import { useT, useCatalogueLocale } from '../i18n/catalogue';
import { useState } from 'react';
import { Mail, CodeXml, Flag } from 'lucide-react';
import { Button, ContactCard, CommentFeed, DateField, UrlField, Window, type CommentItem, type DateFieldLabels } from '@want-foundation/allure-react';

export function DemoBriefElements() {
  const t = useT();
  const locale = useCatalogueLocale();
  const dateLabels: DateFieldLabels = {
  date: t("Choose date"), datetime: t("Choose date and time"), calendar: t("Calendar"), year: t("Year"),
  previousYear: t("Previous year"), previousMonth: t("Previous month"),
  nextMonth: t("Next month"), nextYear: t("Next year"),
  hours: t("Hours"), minutes: t("Minutes"), today: t("Today"), clear: t("Clear"), apply: t("Apply")
};
  const [day, setDay] = useState('2026-10-28');
  const [meeting, setMeeting] = useState('2026-10-28T10:30');
  const [url, setUrl] = useState('https://example.com');
  const [saved, setSaved] = useState('');
  return <Window title={t("Project planning")} kicker={t("Shared controls")}
    actions={<Button variant="secondary" onClick={() => setSaved(t("Example saved locally."))}>{t("Save example")}</Button>}>
    <div className="demo-fields">
      <div className="demo-field-label"><span>{t("Due date")}</span>
        <DateField mode="date" value={day} onChange={setDay} labels={dateLabels} locale={locale === 'en' ? 'en-GB' : locale} ariaLabel={t("Due date")} />
      </div>
      <div className="demo-field-label"><span>{t("Meeting")}</span>
        <DateField mode="datetime" value={meeting} onChange={setMeeting} labels={dateLabels} locale={locale === 'en' ? 'en-GB' : locale} ariaLabel={t("Meeting")} />
      </div>
      <UrlField label={t("Reference URL")} value={url} onChange={setUrl} openLabel={t("Open reference URL")} />
      <p role="status" className="demo-status">{saved}</p>
    </div>
  </Window>;
}

export function DemoContact() {
  const t = useT();
  return <ContactCard name={t("Example Owner")} subtitle={t("Demo product")} actions={[
    { title: t("Email"), detail: 'hello@example.com', href: 'mailto:hello@example.com', icon: Mail },
    { title: t("Source"), detail: 'Want Allure', href: 'https://github.com/andrey-krasheninnikov/want-allure', icon: CodeXml }
  ]} />;
}
export function DemoComments() {
  const t = useT();
  const [reported, setReported] = useState<string[]>([]);
  const [result, setResult] = useState('');
  const comments: CommentItem[] = Array.from({ length: 10 }, (_, index) => ({
    id: String(index), author: index === 0 ? t("You") : t("Guest ") + (index + 1), own: index === 0,
    createdAt: { dateTime: new Date(Date.UTC(2026, 9, 13 + index)).toISOString(), label: (13 + index) + t(" October 2026") },
    text: index === 2 ? t("A longer demonstration comment. ").repeat(18) : t("A demonstration comment for the component showcase."),
    actions: [{ id: 'report', label: reported.includes(String(index)) ? t("Saved") : t("Report"), disabled: reported.includes(String(index)), icon: Flag }]
  }));
  return <><CommentFeed comments={comments} labels={{ title: t("Demo comments"), empty: t("No comments yet."), previous: t("Previous comments"), next: t("Next comments"), readMore: t("Read comment"), collapse: t("Collapse comment") }}
    onAction={(id, action) => { setReported(current => [...current, id]); setResult(t("Comment ") + id + ': ' + t(action === 'report' ? 'Report' : action)); }} />
    <p role="status" className="demo-status">{result}</p></>;
}
