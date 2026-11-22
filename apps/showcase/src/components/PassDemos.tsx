import { useEffect, useRef, useState } from 'react';
import { Archive, Bookmark, Check, CircleHelp, Folder, Grid2X2, Heart, LockKeyhole, Star } from 'lucide-react';
import { Button, CopyAction, Dialog, DialogContent, DialogDescription, DialogTitle, IconButton, IconColorPicker, Input, ListRow, LogoWave, PasswordInput, Popover, PopoverContent, PopoverTrigger, RadioGroup, RadioGroupItem, SceneBackground, ScreenTransition, SearchToolbar, Sidebar, Snackbar, SnackbarProvider, SnackbarViewport, SplitPane, StateGlow, StepIndicator, Svg3DIcon, Textarea, ThreadsBackground } from '@want-foundation/allure-react';
import { useT } from '../i18n/catalogue';
import { Section } from './Section';

const sample='{"sample":true}', qr=["1111111011100001101111111","1000001000000110101000001","1011101010100011101011101","1011101001100010001011101","1011101000101111001011101","1000001010000001001000001","1111111010101010101111111","0000000001001011100000000","1010001100111110100100101","0101100110101110011000011","1010101011111001010100001","0100010000101100101001001","1111101111011100001101011","0111100110101001111000001","1110001010101111001010111","0010010111111010100101011","1110111101000111111111010","0000000011100110100011111","1111111010010000101010101","1000001000000101100011011","1011101001111101111110000","1011101000001001010010000","1011101010001110100011111","1000001001111011100001000","1111111011100110110001001"];
const logo='/brand/logos/dark/transparent.svg';
const feather=(signal:AbortSignal)=>fetch(logo,{signal}).then(response=>{
  if(!response.ok) throw new Error('Logo unavailable');
  return response.text();
});
const lock='<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M4 11H20V22H4Z M11 15V19H13V15Z"/></svg>';
const shackle='<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M7 12V7C7 0 17 0 17 7V12H14V7C14 4 10 4 10 7V12Z"/></svg>';

export function WorkspaceDemo() {
  const t=useT();
  const [expanded,expand]=useState(false), [group,setGroup]=useState('all'), [query,search]=useState('');
  const [pinned,filter]=useState(false), [detail,show]=useState(false), [current,select]=useState(0);
  const [fractions,resize]=useState([.24,.33,.43]);
  useEffect(()=>{
    try {
      const saved=JSON.parse(localStorage.getItem('want-workspace-preview')??'null') as unknown;
      if(Array.isArray(saved)&&saved.length===3&&saved.every(value=>typeof value==='number'&&Number.isFinite(value)&&value>0)) resize(saved);
    } catch {}
  },[]);
  const choose=(id:string)=>{setGroup(id);show(false);};
  const groups=[{id:'all',label:t('All items'),icon:<Grid2X2/>,count:3},
    {id:'work',label:t('Work'),icon:<Folder/>,count:2},
    {id:'pinned',label:t('Pinned'),icon:<Star/>,count:1}];
  const entries=[t('Design notes'),t('Reading list'),t('Release checklist')];
  const groupsPane=<div className="pass-pane"><h3>{t('Groups')}</h3>{groups.map(item=>
    <ListRow key={item.id} leading={item.icon} trailing={item.count} selected={group===item.id} onSelect={()=>choose(item.id)}>{item.label}</ListRow>)}</div>;
  const entriesPane=<div className="pass-pane"><h3>{t('Items')}</h3>{entries.map((label,i)=>
    (group==='all'||(group==='work'&&i!==1)||(group==='pinned'&&i===0))&&(!pinned||i===0)&&label.toLocaleLowerCase().includes(query.toLocaleLowerCase())&&
    <ListRow key={label} leading={<Bookmark/>} trailing={i===0?<Star/>:null} selected={current===i} onSelect={()=>{select(i);show(true);}}>{label}</ListRow>)}</div>;
  const detailsPane=<div className="pass-pane"><h3>{t('Preview')}</h3><CopyAction label={t('Copy item name')}
    copiedLabel={t('Copied')} errorLabel={t('Copy failed')} onCopy={()=>navigator.clipboard.writeText(entries[current]!)}>
    {entries[current]}</CopyAction></div>;
  return <Section category="compositions" guide="Sidebar" title={t('Workspace')}>
    <Sidebar label={t('Groups')} toggleLabel={t('Toggle menu')} closeLabel={t('Close menu')}
      items={groups} selected={group} onSelect={choose} expanded={expanded} onExpandedChange={expand}>
      <div className="pass-stack"><SearchToolbar label={t('Search items')} value={query} onChange={value=>{search(value);show(false);}}
        filters={pinned?[{id:'pinned',label:t('Pinned'),removeLabel:t('Remove pinned filter'),onRemove:()=>filter(false)}]:[]}
        actions={<><Button variant="secondary" onClick={()=>filter(!pinned)}>{t('Filter')}</Button><Button onClick={()=>show(true)}>{t('Preview')}</Button></>}/>
      <SplitPane fractions={fractions} onChange={next=>{resize(next);try{localStorage.setItem('want-workspace-preview',JSON.stringify(next));}catch{}}}
        panes={[{id:'pass-groups',min:176,content:groupsPane,resizeLabel:t('Resize groups')},
          {id:'pass-items',min:240,content:entriesPane,resizeLabel:t('Resize items')},
          {id:'pass-preview',min:320,content:detailsPane,resizeLabel:t('Resize preview')}]}
        compact={detail?<><Button variant="ghost" onClick={()=>show(false)}>{t('Back')}</Button>{detailsPane}</>:entriesPane}/>
      </div>
    </Sidebar>
  </Section>;
}

export function SensitiveFieldDemo() {
  const t=useT();
  const [value,set]=useState(''), [invalid,fail]=useState(false), [valid,accept]=useState(false);
  return <Section category="inputs" guide="PasswordInput" title={t('Sensitive field')}>
    <form className="pass-stack" onSubmit={event=>{event.preventDefault();fail(value!=='sample-123');accept(value==='sample-123');}}>
      <PasswordInput aria-label={t('Example password')} value={value} invalid={invalid}
        onChange={event=>{set(event.currentTarget.value);fail(false);accept(false);}}
        showLabel={t('Show password')} hideLabel={t('Hide password')}
        actions={<Popover><PopoverTrigger asChild><IconButton label={t('Show hint')}><CircleHelp/></IconButton></PopoverTrigger>
          <PopoverContent><CopyAction label={t('Copy hint')} copiedLabel={t('Copied')}
            errorLabel={t('Copy failed')} onCopy={()=>navigator.clipboard.writeText('sample-123')}>sample-123</CopyAction></PopoverContent></Popover>}/>
      <div><StateGlow active={value.length>=8}><Button type="submit">{t('Verify')}</Button></StateGlow></div>
      {valid&&<span role="status">{t('Example accepted')}</span>}
    </form>
  </Section>;
}

async function saveFile() {
  const blob=new Blob([sample],{type:'application/json'});
  const picker=(window as Window & {showSaveFilePicker?: (opts:{suggestedName:string})=>Promise<{
    createWritable(): Promise<{write(blob:Blob):Promise<void>;close():Promise<void>}>;
  }>}).showSaveFilePicker;
  if(picker && window.top===window) {
    const handle=await picker.call(window,{suggestedName:'allure-example.json'});
    const stream=await handle.createWritable();
    await stream.write(blob); await stream.close();
    return true;
  }
  const url=URL.createObjectURL(blob);
  const link=document.createElement('a');
  link.href=url;link.download='allure-example.json';link.click();
  setTimeout(()=>URL.revokeObjectURL(url),1000);
  return false;
}

export function SetupDemo() {
  const t=useT();
  const [step,go]=useState(1),[secret,password]=useState(''),[repeat,retype]=useState(''),[hidden,obscure]=useState(true);
  const [answers,answer]=useState(['','','']),[modal,open]=useState<'qr'|'reset'|null>(null),[confirm,setConfirm]=useState('');
  const [pending,setPending]=useState(false),[error,setError]=useState(false);
  const [notice,notify]=useState<'saving'|'saved'|'download'|'error'|null>(null);
  const [picked,pick]=useState({icon:'0',color:'0'}),[image,setImage]=useState<string>(),[name,setName]=useState('');
  const opener=useRef<HTMLButtonElement>(null);
  const busy=useRef(false),operation=useRef(0),timer=useRef<ReturnType<typeof setTimeout>|undefined>(undefined);
  useEffect(()=>()=>{operation.current++;clearTimeout(timer.current);},[]);
  useEffect(()=>()=>{if(image) URL.revokeObjectURL(image);},[image]);
  const titles=[t('Name and icon'),t('Requirements'),t('Choose and export')];
  const rules=[{label:t('At least eight characters'),ok:secret.length>=8},
    {label:t('Includes a number'),ok:/\d/.test(secret)},{label:t('Values match'),ok:secret.length>0&&secret===repeat}];
  const icons=[Folder,Bookmark,Archive,Heart,Star,Grid2X2].map((Icon,i)=>({id:String(i),
    label:[t('Folder'),t('Bookmark'),t('Archive'),t('Heart'),t('Star'),t('Grid')][i]!,glyph:<Icon/>}));
  if(image) icons.unshift({id:'upload',label:t('Uploaded image'),glyph:<img className="pass-upload" src={image} alt=""/>});
  const colors=['primary','success','info','warning','error','foreground','muted-foreground'].map((role,i)=>({
    id:String(i),color:'var(--'+role+')',label:[t('Primary'),t('Green'),t('Blue'),t('Amber'),t('Rose'),t('Ink'),t('Muted')][i]!,
  }));
  async function save() {
    if(busy.current)return;
    busy.current=true;const run=++operation.current;notify('saving');
    try {
      const saved=await saveFile();
      if(operation.current===run)notify(saved?'saved':'download');
    } catch(cause) {
      if(operation.current===run)notify(cause instanceof DOMException&&cause.name==='AbortError'?null:'error');
    } finally {busy.current=false;}
  }
  const dismiss=()=>{if(!pending){open(null);setConfirm('');setError(false);}};
  return <Section category="compositions" guide="IconColorPicker" title={t('Guided setup')}>
    <div className="pass-stack"><StepIndicator current={step} total={3} title={titles[step-1]} countLabel={step+' / 3'}/>
      <ScreenTransition step={step}>
        {step===1&&<div className="pass-name">
          <IconColorPicker label={t('Choose icon and color')} iconLabel={t('Icons')} colorLabel={t('Colors')}
            value={picked} icons={icons} colors={colors} onChange={pick}
            upload={<label>{t('Upload image')}<Input type="file" accept="image/png,image/jpeg,image/webp"
              onChange={event=>{const blob=event.currentTarget.files?.[0];if(blob&&blob.size<=5e6&&/^image\/(png|jpeg|webp)$/.test(blob.type)){setImage(URL.createObjectURL(blob));pick(old=>({...old,icon:'upload'}));}}}/></label>}/>
          <Input aria-label={t('Name')} placeholder={t('Name')} value={name} onChange={event=>setName(event.currentTarget.value)}/></div>}
        {step===2&&<div className="pass-stack">
          <PasswordInput aria-label={t('Password')} value={secret} onChange={event=>password(event.currentTarget.value)} obscured={hidden}
            onObscuredChange={obscure} showLabel={t('Show both passwords')} hideLabel={t('Hide both passwords')}/>
          <PasswordInput aria-label={t('Repeat password')} value={repeat} onChange={event=>retype(event.currentTarget.value)} obscured={hidden}
            showVisibilityToggle={false} showLabel={t('Show password')} hideLabel={t('Hide password')}/>
          <ul className="pass-checklist">{rules.map(rule=><li key={rule.label} data-met={rule.ok}>{rule.ok&&<Check size={16} aria-hidden="true"/>}{rule.label}</li>)}</ul>
        </div>}
        {step===3&&<div className="pass-stack">
          {answers.map((value,i)=><RadioGroup key={i} aria-label={t('Choice')+' '+(i+1)} value={value} className="pass-choices"
            onValueChange={next=>answer(values=>values.map((item,j)=>i===j?next:item))}>
            {['A','B','C'].map(option=><label key={option}><RadioGroupItem value={option} aria-label={option}/>{option}</label>)}</RadioGroup>)}
          <div className="pass-export">
            <CopyAction label={t('Copy JSON')} copiedLabel={t('Copied')} errorLabel={t('Copy failed')}
              onCopy={()=>navigator.clipboard.writeText(sample)}>{t('Copy JSON')}</CopyAction>
            <Button variant="secondary" onClick={save}>{t('Download JSON')}</Button>
            <Button variant="secondary" onClick={event=>{opener.current=event.currentTarget;open('qr');}}>{t('Show QR')}</Button>
          </div></div>}
      </ScreenTransition>
      <div className="pass-actions"><Button disabled={step===1} variant="secondary" onClick={()=>go(step-1)}>{t('Back')}</Button>
        {step<3&&<Button disabled={step===2&&!rules.every(rule=>rule.ok)} onClick={()=>go(step+1)}>{t('Next')}</Button>}
        <Button variant="ghost" onClick={event=>{opener.current=event.currentTarget;open('reset');}}>{t('Reset example')}</Button></div>
    </div>
    <Dialog open={modal!==null} onOpenChange={visible=>{if(!visible)dismiss();}}>
      <DialogContent className={modal==='qr'?'pass-qr-dialog':undefined} onCloseAutoFocus={event=>{event.preventDefault();opener.current?.focus();}} closeLabel={t('Close')}>
        {modal==='qr'?<><DialogTitle>{t('Sample QR')}</DialogTitle>
          <DialogDescription>{t('Scan the sample JSON.')}</DialogDescription>
          <svg className="pass-qr" viewBox="0 0 33 33" role="img" aria-label="QR" shapeRendering="crispEdges">
            <rect width="33" height="33" fill="#fff"/>
            {qr.flatMap((row,y)=>Array.from(row,(cell,x)=>cell==='1'?<rect key={y*25+x} x={x+4} y={y+4} width="1" height="1"
              fill={(x<7&&y<7)||(x>17&&y<7)||(x<7&&y>17)?'#5962F0':'#15161a'}/>:null))}
          </svg><Button onClick={dismiss}>{t('I saved it')}</Button></>:<>
          <DialogTitle>{t('Delete local sample data')}</DialogTitle>
          <DialogDescription>{t('This clears the name and choices entered in this example.')}</DialogDescription>
          <Textarea aria-label={t('Enter DELETE to confirm')} placeholder="DELETE" value={confirm} disabled={pending}
            onChange={event=>{setConfirm(event.currentTarget.value);setError(false);}}/>
          {error&&<span className="ui-copy-error" role="alert">{t('Enter DELETE exactly.')}</span>}
          <div className="pass-actions"><Button variant="secondary" onClick={dismiss} disabled={pending}>{t('Cancel')}</Button>
            <Button variant="destructive" disabled={!confirm.trim()||pending} onClick={()=>{
              if(confirm.trim()!=='DELETE'){setError(true);return;}
              setPending(true);timer.current=setTimeout(()=>{go(1);setName('');password('');retype('');obscure(true);answer(['','','']);
                pick({icon:'0',color:'0'});setImage(undefined);setConfirm('');setPending(false);open(null);},180);
            }}>{t('Delete local data')}</Button></div>
        </>}
      </DialogContent>
    </Dialog>
    <SnackbarProvider><SnackbarViewport/>
      {notice&&<Snackbar key={notice} variant={notice==='error'?'error':notice==='saved'?'success':'info'}
        title={notice==='saving'?t('Saving file…'):notice==='saved'?t('File saved'):notice==='download'?t('Download started'):t('Save failed')}
        variantLabel={t('Export')} closeLabel={t('Close')}
        duration={notice==='saving'?Infinity:undefined} onOpenChange={isOpen=>{if(!isOpen)notify(null);}}/>}
    </SnackbarProvider>
  </Section>;
}

export function PassMotionDemo() {
  const t=useT();
  const [open,setOpen]=useState(false),[paused,pause]=useState(false),[wave,pulse]=useState(0);
  const animate=()=>pulse(value=>value+1);
  return <Section category="effects" guide="Svg3DIcon" title={t('Interactive scenes')}>
    <div className="pass-stack">
      <div className="pass-actions">
        <Svg3DIcon source={feather} fallback={<img src={logo} alt=""/>} label={t('Activate feather')} onActivate={animate}/>
        <Svg3DIcon source={lock} movingPart={shackle} active={open} fallback={<LockKeyhole/>} label={t('Toggle lock')} onActivate={()=>setOpen(!open)}/>
        <Button variant="secondary" onClick={()=>pause(!paused)}>{paused?t('Resume'):t('Pause')}</Button>
      </div>
      <SceneBackground paused={paused}>{t('Sphere and lightning')}</SceneBackground>
      <ThreadsBackground paused={paused}>{t('Light threads')}</ThreadsBackground>
      <div className="pass-actions"><LogoWave logo={logo} pulse={wave} paused={paused}/>
        <Button onClick={animate}>{t('Preview the intro')}</Button>
        {wave>0&&<ScreenTransition step={wave}><span role="status" className="pass-success"><Check size={18}/>{t('Ready')}</span></ScreenTransition>}
      </div>
    </div>
  </Section>;
}
