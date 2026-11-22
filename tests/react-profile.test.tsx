import { expect, test } from 'bun:test';
import { renderToStaticMarkup } from 'react-dom/server';
import { AllureProvider, BrandLogo, Button, Field, FieldContent, FieldDescription, FieldError, FieldLabel, Input,
  StateView, ContactCard, Table, TableHeader, TableRow, TableSortHead } from '../packages/react/src/index';

test('the provider resolves registered brand resources and preserves explicit image and control overrides', () => {
  const html = renderToStaticMarkup(<AllureProvider mode="dark" dir="rtl" locale="he" profile={{
    schemaVersion:1, logos:{dark:'night'}, fonts:{body:'body'}, density:'compact',radii:{panel:17},
  }} resources={{logos:{night:'/night.svg'},fonts:{body:'Example Sans'}}}>
    <BrandLogo alt="Mark"/><BrandLogo alt="Alternate" src="/explicit.svg" /><Button busy>Save</Button>
  </AllureProvider>);
  for (const value of ['data-allure-scope=', 'data-density="compact"', 'lang="he"', 'dir="rtl"',
    '--panel-radius:17px','--font-sans:Example Sans','src="/night.svg"', 'src="/explicit.svg"','aria-busy="true"','disabled=""'])
    expect(html).toContain(value);
});

test('field binds visible descriptions and errors, respects explicit IDs and isolates nested fields', () => {
  const html = renderToStaticMarkup(<Field><FieldLabel>Outer</FieldLabel>
    <FieldContent><Input id="outer" /><FieldDescription id="hint">Hint</FieldDescription><FieldError errors={[]} /></FieldContent>
    <Field><FieldLabel htmlFor="inner">Inner</FieldLabel><Input aria-describedby="consumer" />
      <FieldDescription id="extra">Extra</FieldDescription><FieldError id="err">Invalid</FieldError></Field>
  </Field>);
  expect(html).toContain('for="outer"');
  expect(html).toContain('aria-describedby="hint"');
  expect(html).toContain('id="inner"');
  expect(html).toContain('aria-describedby="consumer"');
  expect(html.match(/aria-invalid="true"/g)?.length).toBe(1);
});

test('state actions, sorted numeric columns and multilingual initials are visible to the consumer', () => {
  const html = renderToStaticMarkup(<><StateView state="error" title="Unavailable" action={{label:'Retry',onClick() {}}}/>
    <Table><TableHeader><TableRow><TableSortHead numeric sort="descending" onSortChange={() => {}}>Amount</TableSortHead></TableRow></TableHeader></Table>
    <ContactCard name="👩🏽‍🔬 山田" actions={[{title:'Contact',href:'mailto:a@example.org',detail:'דוא״ל'}]} /></>);
  for (const value of ['role="alert"', 'Retry', 'aria-sort="descending"', 'data-numeric="true"', '👩🏽‍🔬山', 'dir="auto"']) expect(html).toContain(value);
});
