import * as THREE from "./vendor/three.module.js";
import { SpaceAudio } from "./audio.js";
const $ = (id) => document.getElementById(id);
const audio = new SpaceAudio();
const destinations = [
  {
    id: "earth",
    name: "Terra",
    module: "Mapa de Pistas",
    short: "Terra",
    symbol: "◎",
    sector: "SOL · 03",
    subtitle: "Um planeta vivo. Infinitas conexões.",
    position: [3, 0, -14],
    radius: 5,
    color: 0x8ff5dd,
    message:
      "A Terra guarda as pistas dos nossos territórios. Vamos nos aproximar e explorar essas conexões?",
    arrival:
      "Chegamos à Terra. O observatório territorial está pronto. Abra o Mapa de Pistas para explorar em tela cheia.",
  },
  {
    id: "research",
    name: "Estação de Pesquisa",
    module: "Pistas",
    short: "Pesquisa",
    symbol: "◇",
    sector: "SETOR · 07",
    subtitle: "Cada pista abre uma nova possibilidade.",
    position: [-24, 5, -24],
    radius: 2.7,
    color: 0x85f5d3,
    message:
      "Rota para a Estação de Pesquisa. Aqui reunimos pistas, vivências e descobertas dos territórios.",
    arrival:
      "Acoplamento concluído. A Estação de Pesquisa está pronta para receber suas descobertas.",
  },
  {
    id: "observatory",
    name: "Observatório",
    module: "Problemáticas",
    short: "Observatório",
    symbol: "◈",
    sector: "SETOR · 12",
    subtitle: "Novos olhares sobre questões que nos conectam.",
    position: [-40, -2, 14],
    radius: 2.7,
    color: 0xb5a0ff,
    message:
      "O Observatório revela relações entre problemáticas. Vamos buscar uma nova perspectiva?",
    arrival:
      "Chegamos ao Observatório. As problemáticas e suas relações estão à sua espera.",
  },
  {
    id: "connections",
    name: "Estação de Conexões",
    module: "Conexões",
    short: "Conexões",
    symbol: "⌘",
    sector: "SETOR · 18",
    subtitle: "Nada existe sozinho. Tudo pode se conectar.",
    position: [22, 8, 30],
    radius: 2.7,
    color: 0xffc485,
    message:
      "Traçando uma rota para a Estação de Conexões. É aqui que as pistas encontram novos sentidos.",
    arrival:
      "Conexão orbital estabelecida. Podemos explorar os vínculos entre as pistas.",
  },
  {
    id: "agents",
    name: "Central de Inteligências",
    module: "Agentes",
    short: "Inteligências",
    symbol: "✧",
    sector: "SETOR · 24",
    subtitle: "Múltiplas inteligências. Outros horizontes.",
    position: [36, 3, -28],
    radius: 2.7,
    color: 0x82d8ff,
    message:
      "A Central de Inteligências reúne agentes para acompanhar suas explorações. Vamos conhecê-los?",
    arrival:
      "Bem-vindo à Central de Inteligências. Seus agentes estão disponíveis para conversar.",
  },
];
let allowed = destinations.map((d) => d.id),
  selected = destinations[0],
  current = "earth";
let started = false,
  paused = false,
  hostPaused = false,
  travelling = false,
  arrived = false,
  reduced = matchMedia("(prefers-reduced-motion: reduce)").matches;
let typeTimer,
  typedText = "",
  travelTime = 0,
  frame,
  last = 0,
  elapsed = 0,
  rendered = true;
let renderer,
  scene,
  camera,
  earth,
  atmosphere,
  stars,
  stations = [],
  flightFrom,
  flightTo,
  lookFrom,
  lookTo;
const look = new THREE.Vector3(0, 0, -14),
  pointer = { x: 0, y: 0 };
function emit(type, extra = {}) {
  const data = JSON.stringify({ channel: "econectiva-space", type, ...extra });
  if (window.SpaceBridge) window.SpaceBridge.postMessage(data);
  else if (parent !== window) parent.postMessage(data, location.origin);
  else if (type === "open" || type === "assistant") {
    say(
      type === "assistant"
        ? "Na plataforma, este console abre nossa conversa. Estou aqui para acompanhar sua exploração."
        : "Destino pronto. Dentro da plataforma, este acesso abre o módulo real em tela cheia.",
    );
    record(
      "Prévia · acesso a " +
        (type === "assistant" ? "Iareté" : selected.module),
    );
  }
}
function record(text) {
  const time = new Date().toLocaleTimeString("pt-BR", {
    hour: "2-digit",
    minute: "2-digit",
  });
  $("log").textContent = text;
  const li = document.createElement("li"),
    stamp = document.createElement("time");
  stamp.textContent = time;
  li.append(stamp, document.createTextNode(text));
  $("events").prepend(li);
  if ($("events").children.length > 30) $("events").lastChild.remove();
}
function say(text) {
  clearTimeout(typeTimer);
  typedText = text;
  $("message-accessible").textContent = text;
  $("message").textContent = "";
  document.body.classList.add("speaking");
  let index = 0;
  const step = () => {
    if (paused) return;
    index = reduced ? text.length : Math.min(text.length, index + 1);
    $("message").textContent = text.slice(0, index);
    if (!reduced && index % 3 === 0 && /\S/.test(text[index - 1])) audio.type();
    if (index < text.length)
      typeTimer = setTimeout(step, /[.,?!]/.test(text[index - 1]) ? 140 : 23);
    else document.body.classList.remove("speaking");
  };
  step();
}
function updateSound() {
  $("sound").textContent = audio.enabled ? "Som ligado" : "Som desligado";
  $("sound").setAttribute("aria-pressed", String(audio.enabled));
}
function setMotion() {
  document.body.classList.toggle("reduced", reduced);
  $("motion").textContent = reduced ? "Movimento reduzido" : "Movimento suave";
  $("motion").setAttribute("aria-pressed", String(reduced));
}
function renderDestinations() {
  $("destinations").replaceChildren();
  destinations
    .filter((d) => allowed.includes(d.id))
    .forEach((d, i) => {
      const button = document.createElement("button");
      button.className = "destination";
      button.setAttribute("aria-pressed", String(d === selected));
      button.setAttribute("aria-label", `${d.name}: ${d.module}`);
      const symbol = document.createElement("span");
      symbol.className = "symbol";
      symbol.textContent = d.symbol;
      const label = document.createElement("span"),
        title = document.createElement("strong"),
        sub = document.createElement("small");
      title.textContent = d.short;
      sub.textContent = `0${i + 1} / ${d.module.toUpperCase()}`;
      label.append(title, sub);
      button.append(symbol, label);
      button.onclick = () => select(d);
      button.disabled = travelling;
      $("destinations").append(button);
    });
}
function select(d) {
  if (travelling || !allowed.includes(d.id)) return;
  selected = d;
  arrived = false;
  audio.select();
  $("navigate").hidden = false;
  $("direct").hidden = false;
  $("skip").hidden = true;
  $("destination-title").textContent = d.name;
  $("destination-subtitle").textContent = d.subtitle;
  $("module-title").textContent = d.module;
  $("coordinates").textContent = d.sector;
  $("distance").textContent = `0${destinations.indexOf(d) + 1} / 05`;
  $("navigate").textContent =
    d.id === "earth" ? "Navegar até a Terra →" : "Navegar até a estação →";
  $("reticle-label").textContent =
    current === d.id
      ? `${d.short.toUpperCase()} / SINAL ESTÁVEL`
      : "ROTA DISPONÍVEL";
  $("flight-status").textContent = "Rota disponível";
  $("progress").style.width = "0%";
  renderDestinations();
  say(d.message);
  emit("select", { name: d.name });
}
function navigate() {
  if (!started || paused || travelling || !allowed.includes(selected.id))
    return;
  if (arrived) {
    openModule();
    return;
  }
  travelling = true;
  travelTime = 0;
  audio.depart();
  document.body.classList.add("travelling");
  $("navigate").hidden = true;
  $("direct").hidden = true;
  $("skip").hidden = false;
  $("flight-status").textContent = "Navegação assistida";
  $("speed").textContent = "EM TRÂNSITO";
  say(
    `Rota confirmada. Seguimos para ${selected.id === "earth" ? "a Terra" : selected.name}. Preparando aproximação.`,
  );
  record("Partida autorizada · " + selected.name);
  renderDestinations();
  if (camera) {
    flightFrom = camera.position.clone();
    lookFrom = look.clone();
    const target = new THREE.Vector3(...selected.position);
    flightTo = target
      .clone()
      .add(
        new THREE.Vector3(
          -selected.radius * 0.85,
          selected.radius * 0.4,
          selected.radius * 3.2,
        ),
      );
    lookTo = target
      .clone()
      .add(new THREE.Vector3(-selected.radius * 0.65, 0, 0));
  }
  if (reduced) finishTravel();
}
function finishTravel() {
  if (!travelling) return;
  travelling = false;
  arrived = true;
  current = selected.id;
  audio.throttle(0);
  audio.arrival();
  if (camera && flightTo) {
    camera.position.copy(flightTo);
    look.copy(lookTo);
    camera.lookAt(look);
  }
  document.body.classList.remove("travelling");
  $("navigate").hidden = false;
  $("direct").hidden = true;
  $("skip").hidden = true;
  $("navigate").textContent = `Abrir ${selected.module} ↗`;
  $("flight-status").textContent =
    selected.id === "earth"
      ? "Órbita terrestre estabelecida"
      : "Acoplamento concluído";
  $("speed").textContent = "ÓRBITA";
  $("progress").style.width = "100%";
  $("reticle-label").textContent =
    `${selected.short.toUpperCase()} / CONEXÃO ESTABELECIDA`;
  record("Chegada · " + selected.name);
  say(selected.arrival);
  renderDestinations();
  $("navigate").focus({ preventScroll: true });
}
function openModule() {
  if (!allowed.includes(selected.id)) return;
  audio.select();
  record("Acesso · " + selected.module);
  emit("open", { destination: selected.id });
}
function setPaused(value) {
  paused = value;
  audio.pause(value);
  cancelAnimationFrame(frame);
  clearTimeout(typeTimer);
  document.body.classList.remove("speaking");
  if (value) {
    $("message").textContent = typedText;
  } else {
    last = performance.now();
    frame = requestAnimationFrame(tick);
  }
}
window.receiveSpaceCommand = (data) => {
  if (data?.channel !== "econectiva-space") return;
  if (data.type === "configure" && Array.isArray(data.destinations)) {
    allowed = data.destinations.filter((id) =>
      destinations.some((d) => d.id === id),
    );
    if (!allowed.includes(selected.id) && allowed.length)
      select(destinations.find((d) => d.id === allowed[0]));
    $("navigate").disabled = !allowed.length;
    $("direct").disabled = !allowed.length;
    renderDestinations();
  }
  if (data.type === "pause") {
    hostPaused = true;
    setPaused(true);
  }
  if (data.type === "resume") {
    hostPaused = false;
    setPaused(document.hidden);
    if (data.returned) {
      record("Retorno ao cockpit · posição preservada");
      say(
        "Bem-vindo de volta. Mantive nossa posição. Podemos continuar a exploração quando você quiser.",
      );
    }
  }
};
window.addEventListener("message", (event) => {
  if (event.source !== parent || event.origin !== location.origin) return;
  try {
    window.receiveSpaceCommand(JSON.parse(event.data));
  } catch (_) {}
});
function station(d, index) {
  const group = new THREE.Group();
  group.position.set(...d.position);
  const metal = new THREE.MeshStandardMaterial({
    color: 0x304352,
    roughness: 0.38,
    metalness: 0.8,
  });
  const light = new THREE.MeshBasicMaterial({ color: d.color });
  const ring = new THREE.Mesh(new THREE.TorusGeometry(2, 0.18, 12, 80), metal);
  ring.rotation.x = 0.7;
  group.add(ring);
  const rim = new THREE.Mesh(
    new THREE.TorusGeometry(2.03, 0.035, 8, 80),
    light,
  );
  rim.rotation.copy(ring.rotation);
  group.add(rim);
  const core = new THREE.Mesh(
    new THREE.CylinderGeometry(0.55, 0.8, 2.4, 12),
    metal,
  );
  group.add(core);
  const beacon = new THREE.Mesh(new THREE.OctahedronGeometry(0.45), light);
  beacon.position.y = 1.6;
  group.add(beacon);
  for (let i = 0; i < 4; i++) {
    const arm = new THREE.Mesh(new THREE.BoxGeometry(3.8, 0.08, 0.14), metal);
    arm.rotation.y = (i * Math.PI) / 2;
    group.add(arm);
    const panels = new THREE.Mesh(
      new THREE.BoxGeometry(1.1, 0.06, 2.1),
      new THREE.MeshStandardMaterial({
        color: 0x16394c,
        metalness: 0.55,
        roughness: 0.35,
      }),
    );
    panels.position.set(
      Math.cos((i * Math.PI) / 2) * 3,
      0,
      Math.sin((i * Math.PI) / 2) * 3,
    );
    panels.rotation.y = (i * Math.PI) / 2;
    group.add(panels);
    for (let j = 0; j < 4; j++) {
      const line = new THREE.Mesh(
        new THREE.BoxGeometry(0.025, 0.075, 2),
        light,
      );
      line.position.set(-0.4 + j * 0.26, 0, 0);
      panels.add(line);
    }
  }
  if (index === 2) {
    const second = ring.clone();
    second.rotation.y = 1.3;
    group.add(second);
  }
  scene.add(group);
  stations.push(group);
}
function initScene() {
  try {
    scene = new THREE.Scene();
    camera = new THREE.PerspectiveCamera(
      48,
      innerWidth / innerHeight,
      0.1,
      1200,
    );
    camera.position.set(-2, 2, 6);
    camera.lookAt(look);
    renderer = new THREE.WebGLRenderer({
      antialias: devicePixelRatio < 2,
      alpha: true,
      powerPreference: "high-performance",
    });
    renderer.setPixelRatio(
      Math.min(devicePixelRatio, innerWidth < 760 ? 1.25 : 1.7),
    );
    renderer.setSize(innerWidth, innerHeight);
    renderer.outputColorSpace = THREE.SRGBColorSpace;
    renderer.toneMapping = THREE.ACESFilmicToneMapping;
    renderer.toneMappingExposure = 1.2;
    $("universe").append(renderer.domElement);
    scene.add(new THREE.AmbientLight(0x779bbf, 1.15));
    const sun = new THREE.DirectionalLight(0xe4f9ff, 3.2);
    sun.position.set(-20, 15, 20);
    scene.add(sun);
    const geometry = new THREE.BufferGeometry(),
      positions = [],
      colors = [];
    let seed = 95;
    const random = () => {
      seed = (seed * 1664525 + 1013904223) >>> 0;
      return seed / 4294967296;
    };
    for (let i = 0; i < 2200; i++) {
      const theta = random() * Math.PI * 2,
        z = random() * 2 - 1,
        r = 180 + random() * 200,
        s = Math.sqrt(1 - z * z);
      positions.push(r * s * Math.cos(theta), r * z, r * s * Math.sin(theta));
      const tint = new THREE.Color().setHSL(
        0.53 + random() * 0.13,
        0.15 + random() * 0.3,
        0.45 + random() * 0.5,
      );
      colors.push(tint.r, tint.g, tint.b);
    }
    geometry.setAttribute(
      "position",
      new THREE.Float32BufferAttribute(positions, 3),
    );
    geometry.setAttribute("color", new THREE.Float32BufferAttribute(colors, 3));
    stars = new THREE.Points(
      geometry,
      new THREE.PointsMaterial({
        size: 0.48,
        vertexColors: true,
        transparent: true,
        opacity: 0.85,
      }),
    );
    scene.add(stars);
    const texture = new THREE.TextureLoader().load(
      "earth.png",
      undefined,
      undefined,
      () =>
        record("Textura da Terra indisponível · representação simplificada"),
    );
    texture.colorSpace = THREE.SRGBColorSpace;
    texture.anisotropy = Math.min(8, renderer.capabilities.getMaxAnisotropy());
    earth = new THREE.Mesh(
      new THREE.SphereGeometry(5, 72, 48),
      new THREE.MeshStandardMaterial({
        map: texture,
        roughness: 0.85,
        metalness: 0.05,
      }),
    );
    earth.position.set(...destinations[0].position);
    earth.rotation.y = 2.5;
    earth.rotation.z = 0.12;
    scene.add(earth);
    atmosphere = new THREE.Mesh(
      new THREE.SphereGeometry(5.12, 64, 40),
      new THREE.ShaderMaterial({
        uniforms: { glow: { value: new THREE.Color(0x65bfff) } },
        vertexShader:
          "varying vec3 n; varying vec3 v; void main(){vec4 p=modelViewMatrix*vec4(position,1.);n=normalize(normalMatrix*normal);v=normalize(-p.xyz);gl_Position=projectionMatrix*p;}",
        fragmentShader:
          "varying vec3 n;varying vec3 v;uniform vec3 glow;void main(){float f=pow(1.-max(dot(n,v),0.),3.);gl_FragColor=vec4(glow,f*.65);}",
        transparent: true,
        depthWrite: false,
        blending: THREE.AdditiveBlending,
      }),
    );
    atmosphere.position.copy(earth.position);
    scene.add(atmosphere);
    // Delicate orbital guide around Earth, a visual navigation instrument.
    const orbit = new THREE.Mesh(
      new THREE.TorusGeometry(6.15, 0.009, 5, 160),
      new THREE.MeshBasicMaterial({
        color: 0x6bdecd,
        transparent: true,
        opacity: 0.3,
      }),
    );
    orbit.position.copy(earth.position);
    orbit.rotation.x = 1.15;
    orbit.rotation.y = 0.22;
    scene.add(orbit);
    destinations.slice(1).forEach(station);
    renderer.domElement.addEventListener("webglcontextlost", (event) => {
      event.preventDefault();
      rendered = false;
      $("fallback").hidden = false;
      record("Modo leve · contexto gráfico interrompido");
    });
    renderer.domElement.addEventListener("webglcontextrestored", () => {
      rendered = true;
      $("fallback").hidden = true;
    });
  } catch (error) {
    rendered = false;
    $("fallback").hidden = false;
    record("Modo leve · renderização 3D indisponível");
  }
}
let slowFrames = 0,
  qualityReduced = false;
function tick(now) {
  if (paused) return;
  const raw = (now - last) / 1000,
    dt = Math.min(raw || 0.016, 0.05);
  last = now;
  elapsed += dt;
  if (!qualityReduced && renderer && raw > 0.035) {
    if (++slowFrames > 150) {
      renderer.setPixelRatio(1);
      qualityReduced = true;
    }
  }
  if (travelling) {
    travelTime += dt;
    const t = Math.min(travelTime / 4.5, 1),
      ease = t * t * (3 - 2 * t);
    $("progress").style.width = `${t * 100}%`;
    audio.throttle(Math.sin(t * Math.PI));
    if (camera) {
      camera.position.lerpVectors(flightFrom, flightTo, ease);
      camera.position.y += Math.sin(t * Math.PI) * 5;
      look.lerpVectors(lookFrom, lookTo, ease);
    }
    if (t >= 1) finishTravel();
  }
  if (camera && rendered) {
    if (!reduced) {
      earth.rotation.y += dt * 0.012;
      stations.forEach((s, i) => {
        s.rotation.y += dt * (0.025 + i * 0.005);
      });
    }
    const offset =
      reduced || travelling
        ? new THREE.Vector3()
        : new THREE.Vector3(
            pointer.x * 0.45,
            Math.sin(elapsed * 0.24) * 0.045 + pointer.y * 0.22,
            0,
          );
    camera.lookAt(look.clone().add(offset));
    renderer.render(scene, camera);
  }
  frame = requestAnimationFrame(tick);
}
$("start").onclick = async () => {
  started = true;
  $("welcome").hidden = true;
  $("flight-ui").hidden = false;
  await audio.enable($("start-sound").checked);
  updateSound();
  audio.arrival();
  record("Expedição iniciada · Iareté online");
  say(
    "Olá, sou a Iareté, sua inteligência de bordo. A Terra é nosso ponto de partida. Escolha um destino e vamos explorar juntos.",
  );
  $("navigate").focus({ preventScroll: true });
};
$("sound").onclick = async () => {
  await audio.enable(!audio.enabled);
  $("start-sound").checked = audio.enabled;
  updateSound();
  audio.select();
};
$("motion").onclick = () => {
  reduced = !reduced;
  setMotion();
  if (reduced && travelling) finishTravel();
};
$("navigate").onclick = navigate;
$("skip").onclick = finishTravel;
$("direct").onclick = openModule;
$("exit").onclick = () => emit("exit");
$("ask").onclick = $("assistant-orb").onclick = () => {
  audio.select();
  emit("assistant");
};
$("journal-toggle").onclick = () => {
  audio.select();
  $("journal").showModal();
  $("journal-toggle").setAttribute("aria-expanded", "true");
};
$("journal-close").onclick = () => $("journal").close();
$("journal").addEventListener("close", () => {
  $("journal-toggle").setAttribute("aria-expanded", "false");
  $("journal-toggle").focus();
});
window.addEventListener("pointermove", (event) => {
  pointer.x = (event.clientX / innerWidth - 0.5) * 2;
  pointer.y = -(event.clientY / innerHeight - 0.5) * 2;
});
window.addEventListener("keydown", (event) => {
  if (
    !started ||
    paused ||
    $("journal").open ||
    event.altKey ||
    event.ctrlKey ||
    event.metaKey
  )
    return;
  if (event.key >= "1" && event.key <= "5") {
    const d = destinations[Number(event.key) - 1];
    if (allowed.includes(d.id)) {
      event.preventDefault();
      select(d);
    }
  }
  if (event.key === "Enter" && event.target === document.body) {
    event.preventDefault();
    navigate();
  }
});
window.addEventListener("resize", () => {
  if (!renderer) return;
  camera.aspect = innerWidth / innerHeight;
  camera.updateProjectionMatrix();
  renderer.setSize(innerWidth, innerHeight);
});
document.addEventListener("visibilitychange", () =>
  setPaused(document.hidden || hostPaused),
);
window.addEventListener("pagehide", () => {
  setPaused(true);
  audio.dispose();
  renderer?.dispose();
});
setMotion();
renderDestinations();
initScene();
last = performance.now();
frame = requestAnimationFrame(tick);
emit("ready");
