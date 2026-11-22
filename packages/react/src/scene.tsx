import { useEffect, useRef, useState, type ReactNode } from 'react';
import type { ExtrudeGeometry } from 'three';
import { useAllureBrand } from './brand-profile.js';
import { IconButton } from './field-actions.js';
import { LightningBackground } from './lightning-background.js';

export function svgShapes<Shape>(source: string, loader: { parse(svg: string): { paths: { toShapes(): Shape[] }[] } }): Shape[] {
  return loader.parse(source).paths.flatMap(path => path.toShapes());
}

export function Svg3DIcon({ source, fallback, label, onActivate, movingPart, active = false }: {
  source: string | ((signal: AbortSignal) => Promise<string>); fallback: ReactNode; label: string; onActivate: () => void;
  movingPart?: string; active?: boolean;
}) {
  const brand = useAllureBrand();
  const { host, active: visible } = useVisible<HTMLSpanElement>(true);
  const [ready, setReady] = useState(false);
  const render = useRef<(angle: number, part: number) => void>(() => {});
  const angle = useRef(-.25), part = useRef(active ? 1 : 0), activeValue = useRef(active);
  const drag = useRef<{ id: number; start: number; angle: number; moved: boolean } | null>(null);
  const skipClick = useRef(false);
  useEffect(() => {
    const element = host.current!, abort = new AbortController();
    let dispose = () => {};
    setReady(false);
    if (!visible) return;
    async function load() {
      try {
        const [three, { SVGLoader }, svg] = await Promise.all([
          import('three'), import('three/addons/loaders/SVGLoader.js'),
          typeof source === 'string' ? source : source(abort.signal),
        ]);
        if (abort.signal.aborted) return;
        const loader = new SVGLoader(), main = svgShapes(svg, loader), moving = movingPart ? svgShapes(movingPart, loader) : [];
        if (!main.length) return;
        const renderer = new three.WebGLRenderer({ alpha: true, antialias: true, powerPreference: 'low-power' });
        renderer.setSize(40, 40); renderer.setPixelRatio(Math.min(2, devicePixelRatio));
        const scene = new three.Scene(), camera = new three.PerspectiveCamera(34, 1, .1, 50);
        camera.position.z = 4.7;
        scene.add(new three.HemisphereLight(0xffffff, 0x29292c, 2.4));
        const light = new three.DirectionalLight(0xffffff, 2);
        light.position.set(-3, 3, 5); scene.add(light);
        const material = new three.MeshStandardMaterial({ roughness: .38 });
        const pivot = new three.Group(), body = new three.Group(), shackle = new three.Group();
        const bounds = new three.Box3();
        for (const shape of [...main, ...moving]) {
          const outline = new three.Box2().setFromPoints(shape.getPoints());
          bounds.expandByPoint(new three.Vector3(outline.min.x, outline.min.y, 0));
          bounds.expandByPoint(new three.Vector3(outline.max.x, outline.max.y, 0));
        }
        const center = bounds.getCenter(new three.Vector3()), size = bounds.getSize(new three.Vector3());
        const span = Math.max(size.x, size.y);
        const geometries: ExtrudeGeometry[] = [];
        for (const [group, shapes] of [[body, main], [shackle, moving]] as const) for (const shape of shapes) {
          const geometry = new three.ExtrudeGeometry(shape, { depth: span * .08, bevelEnabled: false, curveSegments: 8 });
          geometry.translate(-center.x,-center.y,0);
          geometries.push(geometry);
          group.add(new three.Mesh(geometry, material));
        }
        pivot.add(body, shackle); pivot.scale.set(2.4/span,-2.4/span,2.4/span);
        scene.add(pivot); element.append(renderer.domElement);
        const updateMaterial = () => material.color.set(getComputedStyle(element).getPropertyValue('--primary').trim() || '#5962F0');
        updateMaterial();
        const draw = (yaw: number, open: number) => {
          if (document.hidden || !element.getClientRects().length || renderer.getContext().isContextLost()) return;
          pivot.rotation.y = yaw;
          shackle.position.y = -open * span * .15;
          shackle.rotation.z = -open * .15;
          renderer.render(scene,camera);
        };
        render.current = draw;
        const redraw = () => { updateMaterial(); draw(angle.current,part.current); };
        const lost = (event: Event) => { event.preventDefault(); setReady(false); };
        renderer.domElement.addEventListener('webglcontextlost', lost);
        const observer = new IntersectionObserver(entries => { if (entries[0]?.isIntersecting) redraw(); });
        observer.observe(element);
        document.addEventListener('visibilitychange', redraw);
        const scope = element.closest('[data-allure-scope]') ?? document.documentElement;
        const appearanceObserver = new MutationObserver(redraw);
        appearanceObserver.observe(scope, { attributes: true, attributeFilter: ['style', 'data-theme', 'class'] });
        scope.addEventListener('want:appearance',redraw); scope.addEventListener('want:theme',redraw);
        dispose = () => {
          observer.disconnect(); document.removeEventListener('visibilitychange', redraw);
          appearanceObserver.disconnect();
          scope.removeEventListener('want:appearance',redraw); scope.removeEventListener('want:theme',redraw);
          renderer.domElement.removeEventListener('webglcontextlost', lost);
          for (const geometry of geometries) geometry.dispose();
          material.dispose(); renderer.dispose(); renderer.domElement.remove();
        };
        redraw(); setReady(true);
      } catch {
        if (!abort.signal.aborted) setReady(false);
      }
    }
    void load();
    return () => { abort.abort(); dispose(); render.current = () => {}; };
  }, [source,movingPart,visible]);
  useEffect(() => {
    activeValue.current = active;
    let id = 0;
    const start = part.current, target = activeValue.current ? 1 : 0, began = performance.now();
    const tick = (now: number) => {
      const t = (brand?.profile.motion === 'off' || brand?.profile.motion === 'quiet') || matchMedia('(prefers-reduced-motion: reduce)').matches || document.hidden || !host.current?.getClientRects().length
        ? 1 : Math.min(1,(now-began)/180);
      part.current = start + (target-start)*t;
      render.current(angle.current, part.current);
      if (t < 1) id = requestAnimationFrame(tick);
    };
    if (movingPart) id = requestAnimationFrame(tick);
    return () => cancelAnimationFrame(id);
  }, [active,movingPart,brand?.profile.motion]);
  return <IconButton className="ui-3d-icon" label={label}
    onClick={event => { if (event.detail === 0 || !skipClick.current) onActivate(); skipClick.current = false; }}
    onKeyDown={event => {
      if (!ready || (event.key !== 'ArrowLeft' && event.key !== 'ArrowRight')) return;
      event.preventDefault(); angle.current += event.key === 'ArrowLeft' ? -.25 : .25;
      render.current(angle.current,part.current);
    }}
    onPointerDown={event => {
      if (event.button !== 0 || !ready) return;
      skipClick.current = false;
      drag.current = { id:event.pointerId, start:event.clientX, angle:angle.current, moved:false };
      event.currentTarget.setPointerCapture(event.pointerId);
    }}
    onPointerMove={event => {
      const gesture = drag.current;
      if (!gesture || gesture.id !== event.pointerId) return;
      const delta = event.clientX - gesture.start;
      if (Math.abs(delta) < 4 && !gesture.moved) return;
      gesture.moved = true; skipClick.current = true;
      angle.current = gesture.angle + delta*.028; render.current(angle.current,part.current);
    }}
    onLostPointerCapture={() => { drag.current = null; }}>
    <span className="ui-3d-static" hidden={ready} aria-hidden="true">{fallback}</span>
    <span ref={host} className="ui-3d-canvas" aria-hidden="true" />
  </IconButton>;
}

function useVisible<T extends HTMLElement = HTMLDivElement>(enabled: boolean) {
  const motion = useAllureBrand()?.profile.motion;
  const running = enabled && motion !== 'off' && motion !== 'quiet';
  const host = useRef<T>(null);
  const [active, setActive] = useState(false);
  useEffect(() => {
    let visible = false;
    const media = matchMedia('(prefers-reduced-motion: reduce), (forced-colors: active)');
    const sync = () => setActive(running && visible && !document.hidden && !media.matches);
    const observer = new IntersectionObserver(entries => { visible = !!entries[0]?.isIntersecting; sync(); });
    observer.observe(host.current!);
    document.addEventListener('visibilitychange',sync); media.addEventListener('change',sync);
    return () => { observer.disconnect(); media.removeEventListener('change',sync); document.removeEventListener('visibilitychange',sync); };
  }, [running]);
  return { host, active };
}

export function SceneBackground({ paused = false, children }: { paused?: boolean; children: ReactNode }) {
  const { host, active } = useVisible(!paused);
  const [lightning, setLightning] = useState(false);
  useEffect(() => {
    if (!active) return;
    const timer = setInterval(() => setLightning(value => !value),30000);
    return () => clearInterval(timer);
  }, [active]);
  return <div className="ui-motion-scene" ref={host} data-lightning={active && lightning}>
    <div className="ui-scene-sphere" aria-hidden="true" />
    <LightningBackground paused={!active || !lightning} />
    <div className="ui-scene-content">{children}</div>
  </div>;
}

export function ThreadsBackground({ paused = false, children }: { paused?: boolean; children: ReactNode }) {
  const { host, active } = useVisible(!paused);
  return <div className="ui-motion-scene" ref={host} data-running={active}
    onPointerMove={event => {
      if (!active || event.pointerType === 'touch') return;
      const rect = event.currentTarget.getBoundingClientRect();
      event.currentTarget.style.setProperty('--thread-x', (event.clientX-rect.left-rect.width/2)*.09+'px');
      event.currentTarget.style.setProperty('--thread-y', (event.clientY-rect.top-rect.height/2)*.09+'px');
    }}
    onPointerLeave={event => { event.currentTarget.style.removeProperty('--thread-x'); event.currentTarget.style.removeProperty('--thread-y'); }}>
    <div className="ui-thread-lines" aria-hidden="true" /><div className="ui-scene-content">{children}</div>
  </div>;
}

export function LogoWave({ logo, pulse, paused }: { logo: string; pulse: number; paused?: boolean }) {
  const { host, active } = useVisible(!paused);
  return <div className="ui-logo-wave" ref={host} data-running={active} aria-hidden="true">
    <img src={logo} alt="" />
    <span key={pulse} style={{ maskImage: 'url(' + JSON.stringify(logo) + ')' }} />
  </div>;
}
