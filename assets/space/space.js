import * as THREE from "./vendor/three.module.js";
import { SpaceAudio } from "./audio.js";
const $ = (id) => document.getElementById(id);
const audio = new SpaceAudio();
const flightTiming = { charge: 3.6, jump: 2.4, settle: 1.2 };
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
  current = null;
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
  rotationFrom,
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
  if (travelling || transferTime >= 0 || !allowed.includes(d.id)) return;
  selected = d;
  // Selection changes the planned route, never the physical flight state.
  audio.select();
  $("navigate").hidden = false;
  $("direct").hidden = arrived && current === d.id;
  $("skip").hidden = true;
  $("destination-title").textContent = d.name;
  $("destination-subtitle").textContent = d.subtitle;
  $("module-title").textContent = d.module;
  $("coordinates").textContent = d.sector;
  $("distance").textContent = `0${destinations.indexOf(d) + 1} / 05`;
  $("navigate").textContent =
    arrived && current === d.id
      ? `Abrir ${d.module} ↗`
      : d.id === "earth"
        ? "Navegar até a Terra →"
        : "Navegar até a estação →";
  $("reticle-label").textContent =
    current === d.id
      ? `${d.short.toUpperCase()} / SINAL ESTÁVEL`
      : "ROTA DISPONÍVEL";
  $("flight-status").textContent =
    current && current !== d.id
      ? "Destino selecionado · aguardando iniciar navegação"
      : arrived
        ? "Órbita estabelecida"
        : "Rota contínua · destino selecionado";
  $("progress").style.width = "0%";
  renderDestinations();
  say(d.message);
  emit("select", { name: d.name });
}
let cruisePhase = 0,
  orbitPhase = 0,
  jumpPhase = "",
  transferTime = -1,
  transferDestination;
let streaks, streakPositions, cockpitRig, destinationWorld;
const dustSeeds = Array.from({ length: 260 }, () => ({
  x: (Math.random() - 0.5) * 70,
  y: (Math.random() - 0.5) * 42,
  z: -3 - Math.random() * 110,
  speed: 0.25 + Math.random() ** 2 * 2.75,
}));
function cruisePoint(t) {
  return new THREE.Vector3(
    Math.sin(t) * 90,
    18 + Math.sin(t * 2) * 5,
    Math.cos(t) * 80,
  );
}
function navigate() {
  if (
    !started ||
    paused ||
    travelling ||
    transferTime >= 0 ||
    !allowed.includes(selected.id)
  )
    return;
  if (arrived && current === selected.id) {
    openModule();
    return;
  }
  travelling = true;
  if (destinationWorld) destinationWorld.visible = true;
  travelTime = 0;
  jumpPhase = "charge";
  audio.warpCharge(flightTiming.charge);
  document.body.classList.add("travelling");
  $("navigate").hidden = true;
  $("direct").hidden = true;
  $("skip").hidden = false;
  $("flight-status").textContent = "Alinhando vetor · carregando salto";
  $("speed").textContent = "CARGA";
  say(
    `Rota confirmada. Seguimos para ${selected.id === "earth" ? "a Terra" : selected.name}. Carregando o salto conectivo.`,
  );
  record("Partida autorizada · " + selected.name);
  renderDestinations();
  if (camera) {
    flightFrom = camera.position.clone();
    rotationFrom = camera.quaternion.clone();
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
  audio.throttle(0.12);
  audio.arrival();
  orbitPhase = 0;
  jumpPhase = "";
  document.body.style.setProperty("--warp-strength", "0");
  if (camera) {
    camera.fov = 48;
    camera.updateProjectionMatrix();
  }
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
  if (!allowed.includes(selected.id) || transferTime >= 0 || travelling) return;
  transferDestination = selected.id;
  transferTime = 0;
  audio.select();
  record("Preparando saída do cockpit · " + selected.module);
  say(
    selected.id === "earth"
      ? "Preparando a imersão territorial. O cockpit se recolhe para dar lugar ao mapa."
      : "Preparando acesso à estação. Transferindo os controles para o módulo.",
  );
  $("transfer-label").textContent =
    selected.id === "earth"
      ? "Entrando no observatório territorial"
      : "Acessando " + selected.module;
  document.body.classList.add("disembarking");
  document
    .querySelectorAll("#flight-ui button")
    .forEach((button) => (button.disabled = true));
}
function completeTransfer() {
  transferTime = -1;
  document.body.classList.remove("disembarking");
  document.body.classList.add("transfer-covered");
  emit("open", { destination: transferDestination });
  if (parent === window && !window.SpaceBridge) restoreCockpit();
}
function restoreCockpit() {
  transferTime = -1;
  document.body.classList.remove("transfer-covered", "disembarking");
  document
    .querySelectorAll("#flight-ui button")
    .forEach((button) => (button.disabled = false));
  renderDestinations();
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
    restoreCockpit();
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
  destinationWorld.add(group);
  stations.push(group);
}
function buildCockpit() {
  scene.add(camera);
  cockpitRig = new THREE.Group();
  camera.add(cockpitRig);
  const hull = new THREE.MeshStandardMaterial({
    color: 0x263541,
    metalness: 0.75,
    roughness: 0.38,
  });
  const inset = new THREE.MeshStandardMaterial({
    color: 0x080e16,
    metalness: 0.4,
    roughness: 0.62,
  });
  const strip = new THREE.MeshBasicMaterial({ color: 0x73d7cf });
  function beam(a, b, width, material = hull) {
    const start = new THREE.Vector3(...a),
      end = new THREE.Vector3(...b);
    const mesh = new THREE.Mesh(
      new THREE.BoxGeometry(width, start.distanceTo(end), width * 0.8),
      material,
    );
    mesh.position.copy(start).add(end).multiplyScalar(0.5);
    mesh.quaternion.setFromUnitVectors(
      new THREE.Vector3(0, 1, 0),
      end.sub(start).normalize(),
    );
    cockpitRig.add(mesh);
    return mesh;
  }
  // A continuous opaque pressure shell surrounds the windshield. It extends
  // beyond the widest jump FOV, so widening the lens reveals cabin, never gaps.
  function panel(width, height, depth, x, y, z, material = hull) {
    const mesh = new THREE.Mesh(
      new THREE.BoxGeometry(width, height, depth),
      material,
    );
    mesh.position.set(x, y, z);
    cockpitRig.add(mesh);
    return mesh;
  }
  panel(6, 2, 0.22, 0, 1.58, -1.52);
  panel(6, 2.2, 0.32, 0, -1.53, -1.32);
  const amber = new THREE.MeshBasicMaterial({ color: 0xffbe73 });
  const screen = new THREE.MeshStandardMaterial({
    color: 0x102c35,
    emissive: 0x0a333a,
    emissiveIntensity: 0.65,
    metalness: 0.25,
    roughness: 0.3,
  });
  for (const side of [-1, 1]) {
    panel(2.55, 4, 0.22, side * 1.735, 0, -1.52);
    // Layered service covers, recessed instruments and illuminated switches.
    panel(0.24, 0.84, 0.065, side * 0.59, -0.04, -1.36);
    panel(0.19, 0.28, 0.035, side * 0.59, 0.13, -1.31, inset);
    panel(0.16, 0.23, 0.018, side * 0.59, 0.13, -1.285, screen);
    for (let row = 0; row < 5; row++) {
      panel(
        0.1 - row * 0.011,
        0.006,
        0.008,
        side * 0.59,
        0.205 - row * 0.035,
        -1.27,
        strip,
      );
      panel(0.13, 0.012, 0.016, side * 0.59, -0.17 - row * 0.035, -1.3, inset);
    }
    for (let row = 0; row < 3; row++) {
      panel(
        0.04,
        0.025,
        0.03,
        side * 0.55,
        -0.065 - row * 0.035,
        -1.28,
        row === 0 ? amber : strip,
      );
      panel(0.04, 0.025, 0.03, side * 0.63, -0.065 - row * 0.035, -1.28, inset);
    }
    // Outer ribs and ceiling equipment become visible as the jump lens widens.
    for (let rib = 0; rib < 3; rib++) {
      panel(0.035, 2.4, 0.12, side * (0.78 + rib * 0.25), 0, -1.34, inset);
    }
    panel(0.26, 0.12, 0.08, side * 0.28, 0.66, -1.35, inset);
    panel(0.19, 0.012, 0.012, side * 0.28, 0.65, -1.3, strip);
    beam([side * 0.47, 0.63, -1.5], [side * 0.38, -0.48, -1.1], 0.085);
    beam([side * 0.49, 0.6, -1.5], [side * 0.4, -0.5, -1.1], 0.014, strip);
    beam([side * 0.25, 0.64, -1.5], [side * 0.34, 0.12, -1.4], 0.045);
    beam([side * 0.34, 0.12, -1.4], [side * 0.44, -0.39, -1.15], 0.045);
    for (let i = 0; i < 7; i++) {
      const screw = new THREE.Mesh(
        new THREE.CylinderGeometry(0.009, 0.009, 0.015, 8),
        inset,
      );
      screw.rotation.x = Math.PI / 2;
      screw.position.set(
        side * (0.47 - i * 0.012),
        0.51 - i * 0.13,
        -1.075 - i * 0.05,
      );
      cockpitRig.add(screw);
    }
    const sidePanel = new THREE.Mesh(
      new THREE.BoxGeometry(0.19, 0.08, 0.65),
      hull,
    );
    sidePanel.position.set(side * 0.4, -0.39, -1.05);
    sidePanel.rotation.z = side * 0.16;
    cockpitRig.add(sidePanel);
    for (let i = 0; i < 5; i++) {
      const key = new THREE.Mesh(
        new THREE.BoxGeometry(0.027, 0.012, 0.045),
        i % 2 ? strip : inset,
      );
      key.position.set(side * 0.4, -0.34, -0.83 - i * 0.09);
      cockpitRig.add(key);
    }
  }
  beam([-0.55, 0.54, -1.2], [0.55, 0.54, -1.2], 0.14);
  beam([-0.42, -0.4, -1.15], [0.42, -0.4, -1.15], 0.14);
  const dash = new THREE.Mesh(new THREE.BoxGeometry(1.05, 0.15, 0.55), hull);
  dash.position.set(0, -0.48, -0.96);
  dash.rotation.x = 0.16;
  cockpitRig.add(dash);
  const lamp = new THREE.PointLight(0x89e7e5, 1.3, 4);
  lamp.position.set(0, 0.1, -0.55);
  camera.add(lamp);
  const warm = new THREE.PointLight(0xffb174, 0.3, 3);
  warm.position.set(-0.6, -0.15, -0.6);
  camera.add(warm);
  cockpitRig.scale.x = camera.aspect;
  const geometry = new THREE.BufferGeometry();
  streakPositions = new Float32Array(dustSeeds.length * 6);
  geometry.setAttribute(
    "position",
    new THREE.BufferAttribute(streakPositions, 3),
  );
  streaks = new THREE.LineSegments(
    geometry,
    new THREE.LineBasicMaterial({
      color: 0xa2dbff,
      transparent: true,
      opacity: 0.3,
      depthWrite: false,
    }),
  );
  streaks.frustumCulled = false;
  camera.add(streaks);
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
    camera.position.copy(cruisePoint(0));
    look.copy(cruisePoint(0.35));
    camera.lookAt(look);
    destinationWorld = new THREE.Group();
    destinationWorld.visible = false;
    scene.add(destinationWorld);
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
    buildCockpit();
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
        size: 0.8,
        vertexColors: true,
        transparent: true,
        opacity: 0.95,
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
    destinationWorld.add(earth);
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
    destinationWorld.add(atmosphere);
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
    destinationWorld.add(orbit);
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
  if (transferTime >= 0) {
    transferTime += dt;
    if (transferTime >= (reduced ? 0.25 : 1.9)) completeTransfer();
  }
  if (travelling) {
    travelTime += dt;
    const { charge, jump, settle } = flightTiming;
    const t = Math.min(Math.max((travelTime - charge) / jump, 0), 1);
    const ease = t < 0.5 ? 4 * t * t * t : 1 - Math.pow(-2 * t + 2, 3) / 2;
    $("progress").style.width =
      `${Math.min(travelTime / (charge + jump + settle), 1) * 100}%`;
    if (travelTime >= charge && jumpPhase === "charge") {
      jumpPhase = "jump";
      audio.warpJump();
      $("flight-status").textContent = "Salto conectivo · corredor aberto";
      $("speed").textContent = "SALTO";
      record("Salto iniciado · " + selected.name);
    }
    if (t >= 1 && jumpPhase === "jump") {
      jumpPhase = "settle";
      $("flight-status").textContent = "Desacelerando · aproximação orbital";
      $("speed").textContent = "APROXIMAÇÃO";
    }
    const strength = jumpPhase === "jump" ? Math.sin(t * Math.PI) : 0;
    document.body.style.setProperty("--warp-strength", String(strength));
    audio.throttle(
      jumpPhase === "charge" ? (travelTime / charge) * 0.6 : strength,
    );
    if (camera) {
      camera.position.lerpVectors(flightFrom, flightTo, ease);
      look.copy(lookTo);
      camera.fov = 48 + strength * 30;
      camera.updateProjectionMatrix();
    }
    if (travelTime >= charge + jump + settle) finishTravel();
  } else if (camera && !reduced && transferTime < 0) {
    if (arrived) {
      // Continue a slow survey orbit after arrival, without losing the destination.
      orbitPhase += dt * 0.018;
      const body = destinations.find((d) => d.id === current);
      const target = new THREE.Vector3(...body.position);
      camera.position
        .copy(target)
        .add(
          new THREE.Vector3(
            Math.sin(orbitPhase) * body.radius * 3.2 - body.radius * 0.85,
            body.radius * 0.4,
            Math.cos(orbitPhase) * body.radius * 3.2,
          ),
        );
      look.copy(target).add(new THREE.Vector3(-body.radius * 0.65, 0, 0));
    } else {
      cruisePhase += dt * 0.025;
      camera.position.lerp(cruisePoint(cruisePhase), 1 - Math.exp(-dt * 0.4));
      look.lerp(cruisePoint(cruisePhase + 0.35), 1 - Math.exp(-dt * 0.4));
      $("speed").textContent = "CRUZEIRO";
    }
    audio.throttle(0.16);
  }
  if (streaks && !reduced) {
    const strength =
      travelling && jumpPhase === "jump"
        ? Math.sin(
            Math.min(
              (travelTime - flightTiming.charge) / flightTiming.jump,
              1,
            ) * Math.PI,
          )
        : 0;
    dustSeeds.forEach((particle, i) => {
      particle.z +=
        dt * (travelling ? 15 + strength * 180 : 5 * particle.speed);
      if (particle.z > -2) particle.z = -110;
      const length = 0.12 + particle.speed * 0.14 + strength * 16;
      streakPositions.set(
        [
          particle.x,
          particle.y,
          particle.z,
          particle.x,
          particle.y,
          particle.z - length,
        ],
        i * 6,
      );
    });
    streaks.geometry.attributes.position.needsUpdate = true;
    streaks.material.opacity = travelling ? 0.35 + strength * 0.65 : 0.3;
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
    if (travelling) {
      // Interpolate orientation instead of a world-space target: target distances
      // otherwise concentrate a large turn into the first moments of alignment.
      const alignment = Math.min(travelTime / flightTiming.charge, 1);
      const easedAlignment =
        alignment *
        alignment *
        alignment *
        (alignment * (alignment * 6 - 15) + 10);
      camera.quaternion.slerpQuaternions(
        rotationFrom,
        camera.quaternion.clone(),
        easedAlignment,
      );
    }
    renderer.render(scene, camera);
  }
  frame = requestAnimationFrame(tick);
}
$("start").onclick = async () => {
  started = true;
  $("flight-status").textContent = "Rota contínua · piloto automático";
  $("reticle-label").textContent = "PILOTO AUTOMÁTICO / ROTA CONTÍNUA";
  $("welcome").hidden = true;
  $("flight-ui").hidden = false;
  await audio.enable($("start-sound").checked);
  updateSound();
  audio.arrival();
  record("Expedição iniciada · Iareté online");
  say(
    "Olá, sou a Iareté, sua inteligência de bordo. Já estamos em uma rota contínua de exploração. Escolha a Terra ou uma estação e eu preparo nosso salto.",
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
  if (cockpitRig) cockpitRig.scale.x = camera.aspect;
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
