import { useEffect, useId, useRef, useState, type ReactNode } from 'react';
import { Check, Heart, Star } from 'lucide-react';
import { AllureProvider, Badge, BrandLogo, Button, Dialog, DialogContent, DialogDescription, DialogTitle,
  DialogTrigger, Input, Label, Table, TableBody, TableCell, TableHead, TableHeader, TableRow,
  Textarea, ThemeIcon, type AllureResources } from '@want-foundation/allure-react';
import { colorContrast, parseBrandProfile, resolveBrandProfile, tokens, type AllureBrandProfileV1, type BrandColorRole } from '@want-foundation/allure';
import { documentProfile, paletteStyles, typographyPresets } from '../appearance';
import { route, siteText, type Locale } from '../site';
import { studioText, themeName } from '../i18n/studio';

type Mode = 'light'|'dark';
type Profile = AllureBrandProfileV1;
const modes: Mode[] = ['light','dark'];
const radii = ['field','panel','media','action'] as const;
const fonts = ['display','body','mono','ja','zh','ar','hi','he'] as const;
const logos = ['light','dark','mark'] as const;
const defaultFonts = ['Days One','Manrope','Literata','Unbounded','IBM Plex Mono','IBM Plex Sans','Atkinson Hyperlegible Next','Pixelify Sans','Noto Sans JP','Noto Sans SC','Noto Sans Arabic','Noto Sans Devanagari','Noto Sans Hebrew','Noto Kufi Arabic','DotGothic16','ZCOOL XiaoWei'];
export const previewResources: AllureResources = {
  fonts: Object.fromEntries(defaultFonts.map(name=>[name,'"'+name+(['Days One','IBM Plex Mono','DotGothic16','ZCOOL XiaoWei'].includes(name)?'':' Variable')+'"'])),
  icons: { check: Check, star: Star, heart: Heart },
  logos: { 'allure-light':'/brand/logos/light/transparent.svg','allure-dark':'/brand/logos/dark/transparent.svg','allure-mark':'/brand/logos/dark/transparent.svg' }
};
const roles = Object.keys(tokens.themes.wallpapers.light) as BrandColorRole[];
const defaultProfile: Profile = {schemaVersion:1};
const pretty = (value:unknown) => JSON.stringify(value,null,2);
const formatError = (cause:unknown) => cause instanceof Error ? cause.message : String(cause);

function Field({label, children}:{label:string;children:ReactNode}) {
  return <label className="studio-field"><span>{label}</span>{children}</label>;
}
function Options({label, value, options, onChange}:{label:string; value:string; options:readonly string[];onChange:(next:string)=>void}) {
  return <Field label={label}><select value={value} onChange={event=>onChange(event.currentTarget.value)}>
    {options.map(item=><option key={item} value={item}>{item}</option>)}</select></Field>;
}
function Sample({profile,mode,assets,locale,dir}:{profile:Profile;mode:Mode;assets:AllureResources;locale:Locale;dir:'rtl'|'ltr'}) {
  const id=useId(), t=(key:string)=>siteText(locale,key);
  const [email,setEmail]=useState('');
  const themeLabel=themeName(locale,mode);
  const resolved=resolveBrandProfile(profile,mode);
  const ratio=new Intl.NumberFormat(locale,{maximumFractionDigits:2}).format(colorContrast(resolved['--primary'],resolved['--primary-foreground']));
  const logoId=profile.logos?.[mode] ?? profile.logos?.mark;
  return <AllureProvider profile={profile} resources={assets} mode={mode} locale={locale} dir={dir} className="studio-sample">
    <div className="studio-sample-head"><BrandLogo src={logoId && assets.logos?.[logoId]?undefined:'/brand/logos/'+mode+'/transparent.svg'}
      variant={profile.logos?.[mode] ? mode : 'mark'} alt=""/><h4>{themeLabel}</h4></div>
    <div className="studio-colors"><code dir="ltr"><i style={{background:resolved['--brand-color']}}/>brand {resolved['--brand-color']}</code>
      <code dir="ltr"><i style={{background:resolved['--primary']}}/>primary {resolved['--primary']}</code>
      <code dir="ltr">primary / primary-foreground · {ratio}:1</code></div>
    <Label htmlFor={id}>{t('Email')}</Label>
    <Input id={id} type="email" dir="ltr" placeholder="hello@example.com" value={email} onChange={event=>{
      setEmail(event.currentTarget.value);
    }}/>
    <Table aria-label={t('Feedback')}><TableHeader><TableRow><TableHead>{t('Foundation')}</TableHead><TableHead>{t('Feedback')}</TableHead></TableRow></TableHeader>
      <TableBody><TableRow><TableCell>React</TableCell><TableCell><Badge variant="success">{t('Success')}</Badge></TableCell></TableRow></TableBody></Table>
    <Dialog><DialogTrigger asChild><Button><ThemeIcon icon={Check} iconRole="confirm"/>{t('Component preview')}</Button></DialogTrigger>
      <DialogContent closeLabel={t('Close')}><DialogTitle>{themeLabel}</DialogTitle><DialogDescription>{email || t('Component preview')}</DialogDescription></DialogContent>
    </Dialog>
  </AllureProvider>;
}

export default function BrandStudio({locale,framework='react'}:{locale:Locale;framework?:'react'|'flutter'}) {
  const [profile,setProfile]=useState<Profile>(defaultProfile);
  const [raw,setRaw]=useState(pretty(defaultProfile)),[error,setError]=useState('');
  const [mode,setMode]=useState<Mode>('light'),[role,setRole]=useState<BrandColorRole>('primary');
  const [fontRole,setFontRole]=useState<typeof fonts[number]>('display'),[logoRole,setLogoRole]=useState<typeof logos[number]>('light');
  const [iconRole,setIconRole]=useState('confirm'),[dir,setDir]=useState<'ltr'|'rtl'>('ltr');
  const [assets,setAssets]=useState<AllureResources>(previewResources);
  const [epoch,refresh]=useState(0);
  const urls=useRef(new Set<string>()),faces=useRef(new Set<FontFace>()),nextAsset=useRef(0);
  const mounted=useRef(false),request=useRef(0),errorId=useId();
  const resourceRequests=useRef(new Map<string,number>());
  const t=(key:string)=>siteText(locale,key), s=(key:Parameters<typeof studioText>[1])=>studioText(locale,key);
  useEffect(()=>{
    mounted.current=true;
    const update=()=>{const next=documentProfile();setProfile(next);setRaw(pretty(next));refresh(v=>v+1);setError('');};
    const direction=()=>setDir(document.documentElement.dir==='rtl'?'rtl':'ltr');
    update();direction();
    addEventListener('want:appearance',update);addEventListener('want:direction',direction);
    return ()=>{mounted.current=false;request.current++;removeEventListener('want:appearance',update);removeEventListener('want:direction',direction);
      for(const url of urls.current) URL.revokeObjectURL(url);for(const face of faces.current) document.fonts.delete(face);};
  },[]);
  function apply(input:unknown) {
    try {
      const next=parseBrandProfile(input);
      dispatchEvent(new CustomEvent('want:choose-profile',{detail:next}));
      return true;
    } catch (cause) {setError(formatError(cause));return false;}
  }
  function set<K extends keyof Profile>(key:K,value:Profile[K]) {apply({...profile,[key]:value});}
  function assign(group:'fonts'|'logos'|'icons', key:string, id:string) {
    const values:Record<string,string>={...profile[group]};
    if(id) values[key]=id; else delete values[key];
    set(group,values);
  }
  function importText(value:string) {
    setRaw(value);
    try {apply(JSON.parse(value));} catch(cause) {setError('JSON · '+formatError(cause));}
  }
  async function importFile(file?:File) {
    if(!file)return;
    const current=++request.current;
    if(file.size>1_000_000){setError('JSON · 1 MB');return;}
    try {const value=await file.text();if(current===request.current)importText(value);}
    catch(cause) {if(current===request.current)setError(formatError(cause));}
  }
  function download() {
    const url=URL.createObjectURL(new Blob([pretty(profile)+'\n'],{type:'application/json'}));
    const link=document.createElement('a');link.href=url;link.download='allure-brand.json';link.click();setTimeout(()=>URL.revokeObjectURL(url),1000);
  }
  async function useFile(group:'fonts'|'logos',key:string,file?:File) {
    if(!file)return;
    if(!file.size||file.size>10_000_000){setError(s('fileLimit'));return;}
    const slot=group+'.'+key;
    const revision=(resourceRequests.current.get(slot)??0)+1;
    resourceRequests.current.set(slot,revision);
    const current=()=>mounted.current && resourceRequests.current.get(slot)===revision;
    const id='local-'+file.name.replace(/[^\p{L}\p{N}._-]/gu,'-').slice(0,100);
    const url=URL.createObjectURL(file);urls.current.add(url);
    let value=url;
    try {
      if(group==='fonts'){
        value='AllurePreview'+(++nextAsset.current);
        const face=await new FontFace(value,'url("'+url+'")').load();
        if(!current()){URL.revokeObjectURL(url);urls.current.delete(url);return;}
        document.fonts.add(face);faces.current.add(face);
      } else {
        const image=new Image();image.src=url;await image.decode();
        if(!current()){URL.revokeObjectURL(url);urls.current.delete(url);return;}
      }
      setAssets(prev=>({...prev,[group]:{...prev[group],[id]:value}}));
      const activeProfile=documentProfile();
      apply({...activeProfile,[group]:{...activeProfile[group],[key]:id}});
    } catch(cause) {URL.revokeObjectURL(url);urls.current.delete(url);if(current())setError(formatError(cause));}
  }
  const resolved=resolveBrandProfile(profile,mode);
  const registry=Object.fromEntries((['fonts','logos','icons'] as const).map(group=>[group,Array.from(new Set(Object.values(profile[group]??{}))).sort()]));
  const clauses=(['react','flutter'] as const).map(target=><a key={target} href={target===framework?'#studio-preview':route(locale,target)+'?studio=1&section=inputs'} aria-current={target===framework?'page':undefined}>{target==='react'?'React':'Flutter'}</a>);
  return <div className="brand-studio" data-brand-studio>
    <details className="studio-group" open={framework==='flutter'||undefined}><summary>{s('profile')}</summary>
      <div className="studio-grid">
        <Field label={s('brand')}><Input key={epoch} dir="ltr" defaultValue={profile.brandColor??'#5962F0'} onBlur={event=>{
          const value=event.currentTarget.value.trim().toUpperCase();
          if(value!==(profile.brandColor??'#5962F0').toUpperCase())set('brandColor',value);
        }}/></Field>
        <Field label={t('Pick a color')}><input type="color" value={profile.brandColor??'#5962F0'} onChange={event=>set('brandColor',event.currentTarget.value)}/></Field>
        <Options label={t('Palette style')} value={profile.paletteStyle??'contrast'} options={paletteStyles} onChange={v=>set('paletteStyle',v as Profile['paletteStyle'])}/>
        <Options label={t('Typography preset')} value={profile.typographyPreset??'brand'} options={typographyPresets} onChange={v=>set('typographyPreset',v as Profile['typographyPreset'])}/>
        <Options label={s('modes')} value={profile.motion??'standard'} options={['standard','quiet','off']} onChange={v=>set('motion',v as Profile['motion'])}/>
      </div>
      <details><summary>{s('roles')}</summary><div className="studio-grid">
        <Field label={t('Theme')}><select value={mode} onChange={e=>setMode(e.currentTarget.value as Mode)}>{modes.map(m=><option key={m} value={m}>{themeName(locale,m)}</option>)}</select></Field>
        <Options label={t('Design tokens')} value={role} options={roles} onChange={v=>setRole(v as BrandColorRole)}/>
        <Field label={role}><Input dir="ltr" key={mode+role+epoch} defaultValue={resolved['--'+role]} onBlur={e=>{
          const value=e.currentTarget.value.trim().toUpperCase();if(value!==resolved['--'+role].toUpperCase())set('colors',{...profile.colors,[mode]:{...profile.colors?.[mode],[role]:value}});
        }}/></Field>
        <Button type="button" variant="secondary" disabled={!profile.colors?.[mode]?.[role]} onClick={()=>{
          const overrides={...profile.colors?.[mode]};delete overrides[role];set('colors',{...profile.colors,[mode]:overrides});
        }}>{s('clear')}</Button>
      </div></details>
      <details><summary>{s('geometry')}</summary><div className="studio-grid">
        {radii.map((r,i)=><Field key={r} label={r+' · px'}><Input type="number" min={0} max={999} value={profile.radii?.[r]??[12,24,24,999][i]} onChange={e=>{
          if(e.currentTarget.value!=='')set('radii',{...profile.radii,[r]:e.currentTarget.valueAsNumber});
        }}/></Field>)}
        <Options label="density" options={['comfortable','compact']} value={profile.density??'comfortable'} onChange={v=>set('density',v as Profile['density'])}/>
        <Options label="surface" options={['flat','soft','glass']} value={profile.surface??'soft'} onChange={v=>set('surface',v as Profile['surface'])}/>
      </div></details>
      <details><summary>{s('resources')}</summary><p>{s('resourceTip')}</p>
        {(['fonts','logos','icons'] as const).map(group=>{
          const key=group==='fonts'?fontRole:group==='logos'?logoRole:iconRole;
          const choices=Object.keys(assets[group]??{});
          return <div className="studio-grid studio-resources" key={group}>
            {group==='icons'?<Field label={group}><Input value={iconRole} onChange={e=>setIconRole(e.currentTarget.value)}/></Field>:
              <Options label={group} value={key} options={group==='fonts'?fonts:logos} onChange={v=>group==='fonts'?setFontRole(v as typeof fontRole):setLogoRole(v as typeof logoRole)}/>}
            <Field label="ID"><Input dir="ltr" list={errorId+group} key={key+epoch} defaultValue={(profile[group] as Record<string,string>|undefined)?.[key]??''}
              onBlur={e=>{if(key && e.currentTarget.value!==((profile[group] as Record<string,string>|undefined)?.[key]??''))assign(group,key,e.currentTarget.value);}}/>
              <datalist id={errorId+group}>{choices.map(item=><option value={item} key={item}/>)}</datalist></Field>
            {group!=='icons'&&<Field label={s('upload')}><input type="file" accept={group==='fonts'?'.woff,.woff2,.ttf,.otf':'image/png,image/jpeg,image/svg+xml,image/webp'}
              onChange={e=>void useFile(group,key,e.currentTarget.files?.[0])}/></Field>}
          </div>;
        })}
      </details>
      <details><summary>JSON · v1</summary>
        <Field label={s('load')}><input type="file" accept=".json,application/json" onChange={e=>void importFile(e.currentTarget.files?.[0])}/></Field>
        <Field label="JSON"><Textarea rows={8} value={raw} spellCheck={false} dir="ltr" aria-invalid={!!error} aria-describedby={error?errorId:undefined} onChange={e=>setRaw(e.currentTarget.value)}/></Field>
        <div className="demo-actions"><Button onClick={()=>importText(raw)}>{s('apply')}</Button><Button variant="secondary" onClick={download}>{s('download')}</Button>
          <Button variant="ghost" onClick={()=>apply(defaultProfile)}>{t('Reset appearance')}</Button></div>
        <details><summary>{s('registry')}</summary><pre dir="ltr">{pretty(registry)}</pre></details>
        <details><summary>{s('code')}</summary><pre dir="ltr">{`import { AllureProvider } from '@want-foundation/allure-react';\nimport profile from './allure-brand.json';\nimport { parseBrandProfile } from '@want-foundation/allure';\n\n<AllureProvider profile={parseBrandProfile(profile)}\n  mode="dark" resources={resources}>{children}</AllureProvider>`}</pre>
          <pre dir="ltr">{`import 'dart:convert';\nimport 'package:want_allure/want_allure.dart';\n\nfinal profile = WantBrandProfileV1.fromJson(jsonDecode(profileJson));`}</pre></details>
      </details>
    </details>
    {error&&<p id={errorId} role="alert" className="studio-error">{error}</p>}
    <div id="studio-preview" className="studio-preview-heading"><h3>{s('compare')}</h3><nav aria-label={t('Component preview')}>{clauses}</nav></div>
    {framework==='react'&&<div className="studio-previews">{modes.map(m=><Sample key={m} mode={m} profile={profile} assets={assets} locale={locale} dir={dir}/>)}</div>}
  </div>;
}

export function CatalogueStudio({locale,framework}:{locale:Locale;framework:'react'|'flutter'}) {
  const [open,setOpen]=useState(false);
  useEffect(()=>{setOpen(new URLSearchParams(location.search).get('studio')==='1');},[]);
  return <details className="catalogue-studio" open={open} onToggle={e=>setOpen(e.currentTarget.open)}>
    <summary>{studioText(locale,'profile')}</summary>{open&&<BrandStudio locale={locale} framework={framework}/>}
  </details>;
}
