import React, { useEffect, useRef, useState } from 'react';
import { RotateCcw } from 'lucide-react';
import { Button } from '@want-foundation/allure-react';
import type { Locale } from '../site';

export default function LogoStage({locale}:{locale:Locale}): React.JSX.Element {
  const host=useRef<HTMLDivElement>(null),canvas=useRef<HTMLDivElement>(null);
  const rotate=useRef<(x:number,y:number,reset?:boolean)=>void>(()=>{});
  const drag=useRef<{x:number;y:number}|null>(null);
  const [ready,setReady]=useState(false);
  useEffect(()=>{
    let disposed=false,visible=false,frame=0;
    const abort=new AbortController();
    let cleanup=()=>{};
    async function load(){
      try {
        const [THREE,{SVGLoader},response]=await Promise.all([import('./logo-three'),import('three/addons/loaders/SVGLoader.js'),fetch('/brand/logos/dark/transparent.svg',{signal:abort.signal})]);
        if(!response.ok)throw new Error('Logo asset unavailable');
        const source=await response.text();if(disposed)return;
        const renderer=new THREE.WebGLRenderer({alpha:true,antialias:true,powerPreference:'low-power'});
        renderer.setPixelRatio(Math.min(devicePixelRatio,2));
        renderer.setClearColor(0x000000,0);
        renderer.domElement.setAttribute('aria-hidden','true');
        const scene=new THREE.Scene(),camera=new THREE.PerspectiveCamera(34,1,.1,100);
        camera.position.z=5.8;
        scene.add(new THREE.HemisphereLight(0xffffff,0x5962f0,2));
        const light=new THREE.DirectionalLight(0xffffff,2.5);light.position.set(-3,4,5);scene.add(light);
        const face=new THREE.MeshStandardMaterial({color:0xb8bfff,roughness:.38,metalness:.25});
        const side=new THREE.MeshStandardMaterial({color:0x5962f0,roughness:.3,metalness:.4});
        const model=new THREE.Group(),pivot=new THREE.Group();
        const geometries:InstanceType<typeof THREE.ExtrudeGeometry>[]=[];
        for(const path of new SVGLoader().parse(source).paths)for(const shape of path.toShapes()){
          const geometry=new THREE.ExtrudeGeometry(shape,{depth:110,bevelEnabled:false,steps:1,curveSegments:1});
          geometries.push(geometry);model.add(new THREE.Mesh(geometry,[face,side]));
        }
        model.scale.y=-1;
        const bounds=new THREE.Box3().setFromObject(model),center=bounds.getCenter(new THREE.Vector3()),size=bounds.getSize(new THREE.Vector3());
        model.position.copy(center.negate());pivot.add(model);pivot.scale.setScalar(3.1/Math.max(size.x,size.y));scene.add(pivot);
        pivot.rotation.set(.08,-.25,0);
        const render=()=>{frame=0;if(!disposed&&visible&&!document.hidden)renderer.render(scene,camera);};
        const schedule=()=>{if(!frame)frame=requestAnimationFrame(render);};
        const resize=new ResizeObserver(()=>{if(!host.current)return;const {width,height}=host.current.getBoundingClientRect();renderer.setSize(width,height);camera.aspect=width/height;camera.updateProjectionMatrix();schedule();});
        const intersection=new IntersectionObserver(entries=>{visible=entries[0].isIntersecting;if(visible)schedule();});
        const visibility=()=>{if(!document.hidden)schedule();};
        const lost=(event:Event)=>{event.preventDefault();setReady(false);};
        renderer.domElement.addEventListener('webglcontextlost',lost);
        canvas.current!.append(renderer.domElement);resize.observe(host.current!);intersection.observe(host.current!);document.addEventListener('visibilitychange',visibility);
        rotate.current=(x,y,reset=false)=>{if(reset)pivot.rotation.set(.08,-.25,0);else{pivot.rotation.y+=x;pivot.rotation.x=Math.max(-.65,Math.min(.65,pivot.rotation.x+y));}schedule();};
        cleanup=()=>{resize.disconnect();intersection.disconnect();document.removeEventListener('visibilitychange',visibility);renderer.domElement.removeEventListener('webglcontextlost',lost);renderer.domElement.remove();for(const geometry of geometries)geometry.dispose();face.dispose();side.dispose();renderer.dispose();};
        setReady(true);schedule();
      } catch {if(!disposed)setReady(false);}
    }
    load();
    return()=>{disposed=true;abort.abort();cancelAnimationFrame(frame);rotate.current=()=>{};cleanup();};
  },[]);
  const label=locale==='ru'?'Объёмный логотип. Стрелки поворачивают, Home сбрасывает положение.':'3D logo. Arrow keys rotate; Home resets the view.';
  return <div className="logo-stage-wrap"><div className="logo-stage" ref={host} tabIndex={ready?0:undefined} role="group" aria-label={label} data-ready={ready}
    onPointerDown={event=>{if(!ready)return;drag.current={x:event.clientX,y:event.clientY};event.currentTarget.setPointerCapture(event.pointerId);}}
    onPointerMove={event=>{if(!drag.current)return;rotate.current((event.clientX-drag.current.x)*.009,(event.clientY-drag.current.y)*.006);drag.current={x:event.clientX,y:event.clientY};}}
    onPointerUp={()=>{drag.current=null;}} onPointerCancel={()=>{drag.current=null;}}
    onKeyDown={event=>{const delta:{[key:string]:[number,number]}={ArrowLeft:[-.15,0],ArrowRight:[.15,0],ArrowUp:[0,-.12],ArrowDown:[0,.12],Home:[0,0]};if(delta[event.key]){event.preventDefault();rotate.current(...delta[event.key],event.key==='Home');}}}>
    <img className="logo-stage-fallback" src="/brand/logos/dark/transparent.svg" width="480" height="480" alt="" fetchPriority="high"/>
    <div className="logo-stage-canvas" ref={canvas}/>
  </div><div className="logo-stage-caption"><span>{locale==='ru'?'Пиксель за пикселем. В новом измерении.':'Pixel by pixel. A new dimension.'}</span>{ready&&<Button variant="ghost" size="icon" aria-label={locale==='ru'?'Сбросить поворот':'Reset rotation'} onClick={()=>rotate.current(0,0,true)}><RotateCcw size={18}/></Button>}</div></div>;
}
