import React, { useEffect, useRef, useState } from 'react';
import { siteText, type Locale } from '../site';
import { FrameworkLogo } from './FrameworkLogo';

export default function LogoStage({locale,framework,paused=false}:{locale:Locale;framework?:'react'|'flutter';paused?:boolean}): React.JSX.Element {
  const host=useRef<HTMLDivElement>(null),canvas=useRef<HTMLDivElement>(null);
  const rotate=useRef<(x:number,y:number)=>void>(()=>{}),drag=useRef<{x:number;y:number}|null>(null);
  const [ready,setReady]=useState(false);
  const pausedState=useRef(paused),manual=useRef(false),refresh=useRef<()=>void>(()=>{});
  useEffect(()=>{pausedState.current=paused;refresh.current();},[paused]);
  useEffect(()=>{
    let disposed=false,visible=false,frame=0,last=0,painted=false,autoplayElapsed=0;
    const abort=new AbortController(),motion=matchMedia('(prefers-reduced-motion: reduce)');
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
        const side=new THREE.MeshStandardMaterial({color:0x5962f0,roughness:.24,metalness:.72});
        const model=new THREE.Group(),pivot=new THREE.Group(),geometries:InstanceType<typeof THREE.ExtrudeGeometry>[]=[],materials:InstanceType<typeof THREE.MeshStandardMaterial>[]=[side];
        for(const path of new SVGLoader().parse(source).paths)for(const shape of path.toShapes()){
          const geometry=new THREE.ExtrudeGeometry(shape,{depth,bevelEnabled:false,steps:1,curveSegments:framework?32:1});
          const face=new THREE.MeshStandardMaterial({color:path.color,roughness:.27,metalness:.48,emissive:path.color,emissiveIntensity:.06});
          materials.push(face);geometries.push(geometry);model.add(new THREE.Mesh(geometry,[face,side]));
        }
        model.scale.y=-1;
        const bounds=new THREE.Box3().setFromObject(model),center=bounds.getCenter(new THREE.Vector3()),size=bounds.getSize(new THREE.Vector3());
        model.position.copy(center.negate());pivot.add(model);pivot.scale.setScalar(3.1/Math.max(size.x,size.y));scene.add(pivot);pivot.rotation.set(.08,-.25,0);
        const render=(now:number)=>{
          frame=0;if(disposed||!visible||document.hidden||renderer.getContext().isContextLost())return;
          const elapsed=last?(now-last)/1000:0;last=now;
          const autoplay=!motion.matches&&!pausedState.current&&!framework&&autoplayElapsed<4.4&&!manual.current&&!drag.current&&!host.current?.matches(':focus-within');
          if(autoplay){autoplayElapsed=Math.min(4.4,autoplayElapsed+elapsed);const progress=autoplayElapsed/4.4;pivot.rotation.y=-.25+Math.PI*2*(progress*progress*(3-2*progress));}
          renderer.render(scene,camera);if(!painted){painted=true;setReady(true);}
          if(autoplay)frame=requestAnimationFrame(render);
        };
        const schedule=()=>{if(!frame&&visible&&!document.hidden){last=0;frame=requestAnimationFrame(render);}};
        refresh.current=schedule;
        const resize=new ResizeObserver(()=>{if(!host.current)return;const {width,height}=host.current.getBoundingClientRect();if(width&&height){renderer.setSize(width,height);camera.aspect=width/height;camera.updateProjectionMatrix();schedule();}});
        const intersection=new IntersectionObserver(entries=>{visible=entries[0].isIntersecting;if(visible)schedule();else{cancelAnimationFrame(frame);frame=0;last=0;}});
        const visibility=()=>{if(document.hidden){cancelAnimationFrame(frame);frame=0;}else schedule();};
        const preference=()=>{cancelAnimationFrame(frame);frame=0;schedule();};
        const lost=(event:Event)=>{event.preventDefault();setReady(false);cancelAnimationFrame(frame);frame=0;};
        renderer.domElement.addEventListener('webglcontextlost',lost);
        canvas.current!.append(renderer.domElement);resize.observe(host.current!);intersection.observe(host.current!);document.addEventListener('visibilitychange',visibility);motion.addEventListener('change',preference);
        rotate.current=(x,y)=>{pivot.rotation.y+=x;pivot.rotation.x=Math.max(-.65,Math.min(.65,pivot.rotation.x+y));schedule();};
        cleanup=()=>{resize.disconnect();intersection.disconnect();document.removeEventListener('visibilitychange',visibility);motion.removeEventListener('change',preference);renderer.domElement.removeEventListener('webglcontextlost',lost);renderer.domElement.remove();for(const geometry of geometries)geometry.dispose();for(const material of materials)material.dispose();renderer.dispose();};
        schedule();
      }catch{if(!disposed)setReady(false);}
    }
    load();return()=>{disposed=true;abort.abort();cancelAnimationFrame(frame);rotate.current=()=>{};refresh.current=()=>{};cleanup();};
  },[framework]);
  return <div className={`logo-stage-wrap ${framework?'framework-model':''}`}><div className="logo-stage" ref={host} tabIndex={ready&&!framework?0:undefined} role={framework?'img':'group'} aria-label={framework??siteText(locale,'3D logo. Drag or use arrow keys to rotate.')} data-ready={ready}
    onPointerDown={event=>{if(!ready||framework)return;manual.current=true;drag.current={x:event.clientX,y:event.clientY};event.currentTarget.setPointerCapture(event.pointerId);}}
    onPointerMove={event=>{if(!drag.current)return;rotate.current((event.clientX-drag.current.x)*.009,(event.clientY-drag.current.y)*.006);drag.current={x:event.clientX,y:event.clientY};}}
    onPointerUp={()=>{drag.current=null;}} onPointerCancel={()=>{drag.current=null;}}
    onKeyDown={event=>{const delta:Record<string,[number,number]>={ArrowLeft:[-.15,0],ArrowRight:[.15,0],ArrowUp:[0,-.12],ArrowDown:[0,.12]};if(delta[event.key]){event.preventDefault();manual.current=true;rotate.current(...delta[event.key]);}}}>
    <div className="logo-stage-fallback">{framework?<FrameworkLogo framework={framework} size={180}/>:<img src="/brand/logos/dark/transparent.svg" width="480" height="480" alt="" fetchPriority="high"/>}</div><div className="logo-stage-canvas" ref={canvas}/>
  </div></div>;
}
