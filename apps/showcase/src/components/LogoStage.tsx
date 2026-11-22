import { svgShapes } from '@want-foundation/allure-react';
import React, { useEffect, useRef, useState } from 'react';
import { siteText, type Locale } from '../site';
import { FrameworkLogo } from './FrameworkLogo';

const featherIntroSeconds = 3.2;
const frameworkTurnSeconds = 6;
const fullTurn = Math.PI * 2;
const restAngle = -.25;

export default function LogoStage({locale,framework,paused=false}:{locale:Locale;framework?:'react'|'flutter';paused?:boolean}): React.JSX.Element {
  const host=useRef<HTMLDivElement>(null),canvas=useRef<HTMLDivElement>(null);
  const rotate=useRef<(x:number,y:number)=>void>(()=>{}),drag=useRef<{x:number;y:number}|null>(null);
  const [ready,setReady]=useState(false);
  const hovered = useRef(false);
  const requestModel = useRef<() => void>(() => {});
  const pendingRotation = useRef<[number, number]>([0, 0]);
  const pausedState=useRef(paused),manual=useRef(false),refresh=useRef<()=>void>(()=>{});
  useEffect(()=>{pausedState.current=paused;refresh.current();},[paused]);
  useEffect(()=>{
    let disposed=false,visible=false,frame=0,last=0,painted=false,autoplayElapsed=0;
    const abort=new AbortController(),motion=matchMedia('(prefers-reduced-motion: reduce), (forced-colors: active)');
    let cleanup=()=>{};
    async function load(){
      try {
        const [THREE,{SVGLoader},response]=await Promise.all([import('./logo-three'),import('three/addons/loaders/SVGLoader.js'),fetch(framework?`/brand/frameworks/${framework}.svg`:'/brand/logos/dark/transparent.svg',{signal:abort.signal})]);
        if(!response.ok)throw new Error('Logo asset unavailable');
        const source=await response.text();if(disposed)return;
        const svg=new DOMParser().parseFromString(source,'image/svg+xml').documentElement;
        const viewBox=(svg.getAttribute('viewBox')??'0 0 100 100').trim().split(/[\s,]+/).map(Number);
        const depth=framework?2:Math.max(viewBox[2],viewBox[3])*.054;
        const renderer=new THREE.WebGLRenderer({alpha:true,antialias:true,powerPreference:'low-power'});
        renderer.setPixelRatio(Math.min(devicePixelRatio,1.5));renderer.setClearColor(0x000000,0);renderer.domElement.setAttribute('aria-hidden','true');
        const scene=new THREE.Scene(),camera=new THREE.PerspectiveCamera(34,1,.1,100);camera.position.z=5.8;
        scene.add(new THREE.HemisphereLight(0xffffff,0x5962f0,2));
        const light=new THREE.DirectionalLight(0xffffff,2.5);light.position.set(-3,4,5);scene.add(light);
        const side=new THREE.MeshStandardMaterial({color:0x5962f0,roughness:.24,metalness:.72,emissiveIntensity:.06});
        const model=new THREE.Group(),pivot=new THREE.Group(),geometries:InstanceType<typeof THREE.ExtrudeGeometry>[]=[],materials:InstanceType<typeof THREE.MeshStandardMaterial>[]=[side];
        for(const shape of svgShapes(source,new SVGLoader())){
          const geometry=new THREE.ExtrudeGeometry(shape,{depth,bevelEnabled:false,steps:1,curveSegments:framework?32:1});
          const face=new THREE.MeshStandardMaterial({color:0x5962f0,roughness:.27,metalness:.48,emissive:0x5962f0,emissiveIntensity:.06});
          materials.push(face);geometries.push(geometry);model.add(new THREE.Mesh(geometry,[face,side]));
        }
        model.scale.y=-1;
        const bounds=new THREE.Box3().setFromObject(model),center=bounds.getCenter(new THREE.Vector3()),size=bounds.getSize(new THREE.Vector3());
        model.position.copy(center.negate());pivot.add(model);pivot.scale.setScalar(3.1/Math.max(size.x,size.y));scene.add(pivot);pivot.rotation.set(.08,restAngle,0);
        let turn = 0, finishTime = 0;
        const primary = () => {
          const color = document.documentElement.dataset.appliedPrimary ?? '#5962f0';
          for (const material of materials) {
            material.color.set(color);
            material.emissive.set(color);
          }
        };
        const render=(now:number)=>{
          frame=0;if(disposed||!visible||document.hidden||renderer.getContext().isContextLost())return;
          const elapsed=last?(now-last)/1000:0;last=now;
          const moving = !motion.matches && !pausedState.current;
          const spin = moving && framework && hovered.current;
          const autoplay = moving && !framework && autoplayElapsed < featherIntroSeconds &&
            !manual.current && !drag.current && !host.current?.matches(':focus-within');
          if (autoplay) {
            autoplayElapsed = Math.min(featherIntroSeconds, autoplayElapsed + elapsed);
            const progress = autoplayElapsed / featherIntroSeconds;
            pivot.rotation.y = -.25 + Math.PI * 2 * (progress * progress * (3 - 2 * progress));
          }
          if (framework) {
            if (!moving) { turn = 0; finishTime = 0; }
            else if (spin) {
              finishTime = 0;
              turn = (turn + fullTurn * elapsed / frameworkTurnSeconds) % fullTurn;
            } else if (turn > 0) {
              finishTime += elapsed;
              turn += elapsed * fullTurn * (1 / frameworkTurnSeconds + finishTime * 5);
              if (turn >= fullTurn) { turn = 0; finishTime = 0; }
            }
            pivot.rotation.y = restAngle + turn;
          }
          renderer.render(scene,camera);if(!painted){painted=true;setReady(true);}
          if (spin || autoplay || (framework && turn > 0)) frame = requestAnimationFrame(render);
        };
        const schedule=()=>{if(!frame&&visible&&!document.hidden){last=0;frame=requestAnimationFrame(render);}};
        refresh.current=schedule;
        const recolor = () => { primary(); schedule(); };
        primary();
        addEventListener('want:appearance', recolor);
        addEventListener('want:theme', recolor);
        const resize=new ResizeObserver(()=>{if(!host.current)return;const {width,height}=host.current.getBoundingClientRect();if(width&&height){renderer.setSize(width,height);camera.aspect=width/height;camera.updateProjectionMatrix();schedule();}});
        const intersection=new IntersectionObserver(entries=>{visible=entries[0].isIntersecting;if(visible)schedule();else{cancelAnimationFrame(frame);frame=0;last=0;}});
        const visibility=()=>{if(document.hidden){cancelAnimationFrame(frame);frame=0;}else schedule();};
        const preference=()=>{cancelAnimationFrame(frame);frame=0;schedule();};
        const lost=(event:Event)=>{event.preventDefault();setReady(false);cancelAnimationFrame(frame);frame=0;};
        renderer.domElement.addEventListener('webglcontextlost',lost);
        canvas.current!.append(renderer.domElement);resize.observe(host.current!);intersection.observe(host.current!);document.addEventListener('visibilitychange',visibility);motion.addEventListener('change',preference);
        rotate.current=(x,y)=>{pivot.rotation.y+=x;pivot.rotation.x=Math.max(-.65,Math.min(.65,pivot.rotation.x+y));schedule();};
        if (!framework) rotate.current(...pendingRotation.current);
        pendingRotation.current = [0, 0];
        cleanup=()=>{removeEventListener('want:appearance', recolor);removeEventListener('want:theme', recolor);resize.disconnect();intersection.disconnect();document.removeEventListener('visibilitychange',visibility);motion.removeEventListener('change',preference);renderer.domElement.removeEventListener('webglcontextlost',lost);renderer.domElement.remove();for(const geometry of geometries)geometry.dispose();for(const material of materials)material.dispose();renderer.dispose();};
        schedule();
      }catch{if(!disposed)setReady(false);}
    }
    let requested = false;
    const start = () => {
      if (requested || disposed || document.hidden) return;
      requested = true;
      void load();
    };
    const eligible = () => {
      if (visible && !motion.matches && !['quiet','off'].includes(document.documentElement.dataset.motion??'')) start();
    };
    const observer = new IntersectionObserver(([entry]) => {
      visible = entry.isIntersecting;
      eligible();
    });
    observer.observe(host.current!);
    requestModel.current = start;
    addEventListener('want:appearance',eligible);
    document.addEventListener('visibilitychange', eligible);
    motion.addEventListener('change', eligible);
    return()=>{observer.disconnect();removeEventListener('want:appearance',eligible);document.removeEventListener('visibilitychange', eligible);
      motion.removeEventListener('change', eligible);requestModel.current=()=>{};disposed=true;abort.abort();cancelAnimationFrame(frame);rotate.current=()=>{};refresh.current=()=>{};cleanup();};
  },[framework]);
  return <div className={`logo-stage-wrap ${framework?'framework-model':''}`}><div className="logo-stage" ref={host} tabIndex={!framework?0:undefined} role={framework?'img':'group'} aria-label={framework??siteText(locale,'3D logo. Drag or use arrow keys to rotate.')} data-ready={ready}
    onPointerEnter={event => {
      if (framework && event.pointerType === 'mouse') {
        hovered.current = true;
        refresh.current();
      }
    }}
    onPointerLeave={() => {
      if (framework) { hovered.current = false; refresh.current(); }
    }}
    onPointerDown={event=>{if(framework)return;requestModel.current();manual.current=true;drag.current={x:event.clientX,y:event.clientY};event.currentTarget.setPointerCapture(event.pointerId);}}
    onPointerMove={event=>{if(!drag.current)return;rotate.current((event.clientX-drag.current.x)*.009,(event.clientY-drag.current.y)*.006);drag.current={x:event.clientX,y:event.clientY};}}
    onPointerUp={()=>{drag.current=null;}} onPointerCancel={()=>{drag.current=null;}}
    onKeyDown={event=>{const delta:Record<string,[number,number]>={ArrowLeft:[-.15,0],ArrowRight:[.15,0],ArrowUp:[0,-.12],ArrowDown:[0,.12]};if(delta[event.key]){event.preventDefault();manual.current=true;requestModel.current();if(ready) rotate.current(...delta[event.key]);else { pendingRotation.current[0]+=delta[event.key][0];pendingRotation.current[1]+=delta[event.key][1]; }}}}>
    <div className="logo-stage-fallback">{framework?<FrameworkLogo framework={framework} size={180}/>:<img src="/brand/logos/dark/transparent.svg" width="480" height="480" alt="" fetchPriority="high"/>}</div><div className="logo-stage-canvas" ref={canvas}/>
  </div></div>;
}
