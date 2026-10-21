import * as THREE from "./vendor/three.module.js";
import { SpaceAudio } from "./audio.js";
const $ = (id) => document.getElementById(id);
const audio = new SpaceAudio();
const flightTiming = { charge: 3.6, jump: 2.4, settle: 1.2 };
const destinations = [
  {
    id: "earth",
    description:
      "Explore as pistas dos territórios em um mapa georreferenciado.",
    contents: ["Pistas no mapa", "Territórios e localizações"],
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
    description:
      "Reúna pistas, vivências e descobertas para conhecer melhor os territórios.",
    contents: ["Pistas", "Vivências e descobertas"],
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
    description:
      "Explore problemáticas e observe as relações entre os desafios dos territórios.",
    contents: ["Problemáticas", "Questões dos territórios"],
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
    description:
      "Descubra vínculos entre pistas e construa novos sentidos para suas explorações.",
    contents: ["Conexões entre pistas", "Relações e vínculos"],
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
    description:
      "Conheça os agentes de inteligência artificial que acompanham suas explorações.",
    contents: ["Agentes de IA", "Conversas e apoio à exploração"],
    name: "Campo de Inteligências",
    module: "Agentes",
    short: "Inteligências",
    symbol: "✧",
    sector: "SETOR · 24",
    subtitle: "Múltiplas inteligências. Outros horizontes.",
    position: [36, 3, -28],
    radius: 2.7,
    color: 0x82d8ff,
    message:
      "Órbitas luminosas entrelaçam as inteligências que acompanham nossas explorações. Vamos nos aproximar?",
    arrival:
      "Chegamos ao Campo de Inteligências. Não há uma estrutura central: as luzes se conectam em movimento. Os agentes estão disponíveis para conversar.",
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
const look = new THREE.Vector3(0, 0, -14);
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
  if (reduced) updateMission(selected);
  document.body.classList.toggle("reduced", reduced);
  $("motion").textContent = reduced ? "Movimento reduzido" : "Movimento suave";
  $("motion").setAttribute("aria-pressed", String(reduced));
}
const mapShipPoint = { x: 110, y: 122 };
let mapDeparture = { ...mapShipPoint };
function mapPoint(destination) {
  return {
    x: 110 + destination.position[0] * 2,
    y: 108 + destination.position[2] * 1.8,
  };
}
function renderExpeditionMap() {
  const ns = "http://www.w3.org/2000/svg";
  $("map-nodes").replaceChildren(
    ...destinations
      .filter((d) => allowed.includes(d.id))
      .map((d) => {
        const point = mapPoint(d),
          group = document.createElementNS(ns, "g");
        group.classList.toggle("map-current", current === d.id);
        group.classList.toggle("map-selected", selected.id === d.id);
        const dot = document.createElementNS(ns, "circle");
        dot.setAttribute("cx", point.x);
        dot.setAttribute("cy", point.y);
        dot.setAttribute("r", d.id === "earth" ? 5 : 3.5);
        const label = document.createElementNS(ns, "text");
        label.setAttribute("x", point.x);
        label.setAttribute("y", point.y + (point.y > 108 ? 17 : -13));
        label.setAttribute("text-anchor", "middle");
        label.textContent = d.short;
        group.append(dot, label);
        return group;
      }),
  );
  const currentDestination = destinations.find((d) => d.id === current);
  const location = travelling
    ? `Em salto → ${selected.short}`
    : currentDestination
      ? `Você está em ${currentDestination.name}`
      : "Espaço aberto · em cruzeiro";
  $("map-location").textContent = location;
  $("expedition-map").setAttribute(
    "aria-label",
    `Mapa da expedição. ${location}`,
  );
  const target = mapPoint(selected);
  $("map-route").setAttribute(
    "d",
    travelling
      ? `M${mapDeparture.x},${mapDeparture.y} L${target.x},${target.y}`
      : "",
  );
}
function updateMapShip() {
  if (travelling) {
    const t = Math.min(
      Math.max((travelTime - flightTiming.charge) / flightTiming.jump, 0),
      1,
    );
    const ease = t * t * (3 - 2 * t),
      target = mapPoint(selected);
    mapShipPoint.x = mapDeparture.x + (target.x - mapDeparture.x) * ease;
    mapShipPoint.y = mapDeparture.y + (target.y - mapDeparture.y) * ease;
  } else if (current) {
    Object.assign(
      mapShipPoint,
      mapPoint(destinations.find((d) => d.id === current)),
    );
  } else if (!reduced) {
    mapShipPoint.x = 110 + Math.sin(elapsed * 0.12) * 8;
    mapShipPoint.y = 122 + Math.cos(elapsed * 0.12) * 4;
  }
  $("map-ship").setAttribute(
    "transform",
    `translate(${mapShipPoint.x} ${mapShipPoint.y})`,
  );
}
function renderDestinations() {
  document.body.classList.toggle("at-destination", Boolean(current));
  document.body.classList.toggle(
    "at-current-destination",
    arrived && current === selected.id && !travelling,
  );
  renderExpeditionMap();
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
let missionId = "earth",
  missionAnimation = null,
  missionRevision = 0;
function updateMission(destination) {
  const panel = $("destination-summary"),
    revision = ++missionRevision;
  const opacity = getComputedStyle(panel).opacity;
  const pending = missionAnimation?.playState === "running";
  missionAnimation?.cancel();
  const update = () => {
    $("destination-title").textContent = destination.name;
    $("destination-subtitle").textContent = destination.subtitle;
    $("coordinates").textContent = destination.sector;
    missionId = destination.id;
  };
  if (reduced || (!pending && missionId === destination.id)) {
    update();
    return;
  }
  missionAnimation = panel.animate(
    [
      { opacity, transform: "translateY(0)" },
      { opacity: 0, transform: "translateY(-4px)" },
    ],
    { duration: 180, easing: "ease-in", fill: "forwards" },
  );
  missionAnimation.finished
    .then(() => {
      if (revision !== missionRevision) return;
      update();
      missionAnimation.cancel();
      if (!reduced)
        missionAnimation = panel.animate(
          [
            { opacity: 0, transform: "translateY(6px)" },
            { opacity: 1, transform: "translateY(0)" },
          ],
          { duration: 500, easing: "cubic-bezier(.2,.7,.2,1)" },
        );
    })
    .catch(() => {}); // Fast destination changes supersede the pending fade.
}
function select(d) {
  if (travelling || transferTime >= 0 || !allowed.includes(d.id)) return;
  selected = d;
  // Selection changes the planned route, never the physical flight state.
  audio.select();
  $("navigate").hidden = arrived && current === d.id;
  $("direct").hidden = arrived && current === d.id;
  $("skip").hidden = true;
  updateMission(d);
  $("module-title").textContent = d.module;
  $("distance").textContent = `0${destinations.indexOf(d) + 1} / 05`;
  $("navigate").textContent =
    arrived && current === d.id
      ? `Abrir ${d.module} ↗`
      : d.id === "earth"
        ? "Navegar até a Terra →"
        : d.id === "agents"
          ? "Navegar até Inteligências →"
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
  mapDeparture = { ...mapShipPoint };
  travelling = true;
  renderLocalPanel();
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
  renderLocalPanel();
  audio.throttle(0.12);
  audio.arrival();
  orbitPhase = 0;
  jumpPhase = "";
  document.body.style.setProperty("--warp-strength", "0");
  if (camera && flightTo) {
    camera.position.copy(flightTo);
    look.copy(lookTo);
    camera.lookAt(look);
  }
  document.body.classList.remove("travelling");
  $("navigate").hidden = true;
  $("direct").hidden = true;
  $("skip").hidden = true;
  $("navigate").textContent = `Abrir ${selected.module} ↗`;
  $("flight-status").textContent =
    selected.id === "earth"
      ? "Órbita terrestre estabelecida"
      : selected.id === "agents"
        ? "Campo de Inteligências alcançado"
        : "Acoplamento concluído";
  $("speed").textContent = "ÓRBITA";
  $("progress").style.width = "100%";
  $("reticle-label").textContent =
    `${selected.short.toUpperCase()} / CONEXÃO ESTABELECIDA`;
  record("Chegada · " + selected.name);
  say(selected.arrival);
  renderDestinations();
}
let localPanelId = null,
  localPanelAnimation = null,
  localPanelRevision = 0;
function renderLocalPanel() {
  const destination = destinations.find((d) => d.id === current);
  if (destination) {
    const changed = localPanelId !== destination.id;
    const revision = ++localPanelRevision;
    localPanelAnimation?.cancel();
    const details = $("local-details");
    const update = () => {
      $("local-sector").textContent = destination.sector;
      $("local-emblem").textContent = destination.symbol;
      $("local-name").textContent = destination.name;
      $("local-description").textContent = destination.description;
      $("local-status").textContent = travelling
        ? "EM TRÂNSITO · ÚLTIMO LOCAL"
        : "CONEXÃO ESTABELECIDA";
      $("local-contents").replaceChildren(
        ...destination.contents.map((text) => {
          const item = document.createElement("span");
          item.textContent = text;
          return item;
        }),
      );
      $("local-open").hidden = !allowed.includes(destination.id);
      $("local-open").disabled = travelling || transferTime >= 0;
      $("local-open").textContent = `Abrir ${destination.module} ↗`;
      localPanelId = destination.id;
      if (changed && !travelling)
        $("local-open").focus({ preventScroll: true });
    };
    if (!changed || reduced) {
      update();
      return;
    }
    // Keep the old location visible until it fades, then reveal the new data.
    $("local-open").disabled = true;
    localPanelAnimation = details.animate(
      [
        { opacity: 1, transform: "translateY(0)" },
        { opacity: 0, transform: "translateY(-4px)" },
      ],
      { duration: 180, easing: "ease-in", fill: "forwards" },
    );
    localPanelAnimation.finished
      .then(() => {
        if (revision !== localPanelRevision) return;
        update();
        localPanelAnimation.cancel();
        if (!reduced)
          localPanelAnimation = details.animate(
            [
              { opacity: 0, transform: "translateY(6px)" },
              { opacity: 1, transform: "translateY(0)" },
            ],
            { duration: 520, easing: "cubic-bezier(.2,.7,.2,1)" },
          );
      })
      .catch(() => {}); // A newer update can supersede this transition.
  }
}
$("local-open").onclick = () => {
  const destination = destinations.find((d) => d.id === current);
  if (destination) openDestination(destination);
};
function openModule() {
  openDestination(selected);
}
function openDestination(destination) {
  if (!allowed.includes(destination.id) || transferTime >= 0 || travelling)
    return;
  transferDestination = destination.id;
  transferTime = 0;
  audio.select();
  record("Preparando saída do cockpit · " + destination.module);
  say(
    destination.id === "earth"
      ? "Preparando a imersão territorial. O cockpit se recolhe para dar lugar ao mapa."
      : destination.id === "connections"
        ? "Preparando a sala de Conexões da nave. A tela de exploração está pronta para receber você."
        : "Preparando acesso à estação. Transferindo os controles para o módulo.",
  );
  $("transfer-label").textContent =
    destination.id === "earth"
      ? "Entrando no observatório territorial"
      : destination.id === "connections"
        ? "Entrando na sala de Conexões"
        : "Acessando " + destination.module;
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
  renderLocalPanel();
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
let intelligenceClock = 0;
const intelligenceOrbits = [];
function intelligenceField(destination) {
  const field = new THREE.Group();
  field.position.set(...destination.position);
  destinationWorld.add(field);
  // Procedural light halos; no central mesh or central light source.
  const haloCanvas = document.createElement("canvas");
  haloCanvas.width = haloCanvas.height = 64;
  const ctx = haloCanvas.getContext("2d");
  const gradient = ctx.createRadialGradient(32, 32, 0, 32, 32, 32);
  gradient.addColorStop(0, "rgba(255,255,255,1)");
  gradient.addColorStop(0.12, "rgba(255,255,255,.85)");
  gradient.addColorStop(0.35, "rgba(255,255,255,.22)");
  gradient.addColorStop(1, "rgba(255,255,255,0)");
  ctx.fillStyle = gradient;
  ctx.fillRect(0, 0, 64, 64);
  const texture = new THREE.CanvasTexture(haloCanvas);
  const palette = [0x83eaff, 0xbca1ff, 0x62caff, 0xc3fff1];
  const coreGeometry = new THREE.SphereGeometry(0.028, 10, 8);
  const coreMaterial = new THREE.MeshBasicMaterial({ color: 0xe6faff });
  const samples = 72;
  // A seeded layout keeps the same field when the app is reopened.
  let seed = 95;
  const random = () => {
    seed = (seed * 1664525 + 1013904223) >>> 0;
    return seed / 4294967296;
  };
  for (let i = 0; i < 18; i++) {
    const plane = new THREE.Group();
    field.add(plane);
    const radius = 1.7 + random() * 1.15,
      eccentricity = 0.68 + random() * 0.3;
    const tint = new THREE.Color(palette[i % palette.length]);
    const positions = new Float32Array(samples * 3),
      colors = new Float32Array(samples * 3);
    for (let j = 0; j < samples; j++) {
      const brightness = Math.pow(1 - j / (samples - 1), 1.7) * 0.8;
      colors.set(
        [tint.r * brightness, tint.g * brightness, tint.b * brightness],
        j * 3,
      );
    }
    const geometry = new THREE.BufferGeometry();
    geometry.setAttribute("position", new THREE.BufferAttribute(positions, 3));
    geometry.setAttribute("color", new THREE.BufferAttribute(colors, 3));
    const trail = new THREE.Line(
      geometry,
      new THREE.LineBasicMaterial({
        vertexColors: true,
        transparent: true,
        opacity: 0.9,
        blending: THREE.AdditiveBlending,
        depthWrite: false,
      }),
    );
    trail.frustumCulled = false;
    plane.add(trail);
    const halo = new THREE.Sprite(
      new THREE.SpriteMaterial({
        map: texture,
        color: tint,
        transparent: true,
        opacity: 0.8,
        blending: THREE.AdditiveBlending,
        depthWrite: false,
      }),
    );
    halo.scale.setScalar(0.4 + random() * 0.18);
    plane.add(halo);
    const core = new THREE.Mesh(coreGeometry, coreMaterial);
    plane.add(core);
    intelligenceOrbits.push({
      plane,
      halo,
      core,
      geometry,
      positions,
      radius,
      eccentricity,
      phase: random() * Math.PI * 2,
      speed: (0.2 + random() * 0.32) * (i % 2 ? 1 : -1),
      tiltX: random() * Math.PI,
      tiltY: random() * Math.PI,
      tiltZ: random() * Math.PI,
      drift: (random() - 0.5) * 0.08,
      tail: 0.75 + random() * 0.8,
    });
  }
  updateIntelligenceField(0);
}
function updateIntelligenceField(dt) {
  intelligenceClock += dt;
  for (const orbit of intelligenceOrbits) {
    const phase = orbit.phase + intelligenceClock * orbit.speed;
    orbit.plane.rotation.set(
      orbit.tiltX + Math.sin(intelligenceClock * 0.06) * 0.12,
      orbit.tiltY + intelligenceClock * orbit.drift,
      orbit.tiltZ + Math.cos(intelligenceClock * 0.045) * 0.1,
    );
    for (let j = 0; j < 72; j++) {
      const t = phase - ((Math.sign(orbit.speed) * j) / 71) * orbit.tail;
      orbit.positions.set(
        [
          Math.cos(t) * orbit.radius,
          Math.sin(t) * orbit.radius * orbit.eccentricity,
          Math.sin(t * 3) * 0.06,
        ],
        j * 3,
      );
    }
    orbit.core.position.fromArray(orbit.positions);
    orbit.halo.position.copy(orbit.core.position);
    orbit.geometry.attributes.position.needsUpdate = true;
  }
}
function researchThread() {
  // A continuous research thread, independent from the ship's flight path.
  const curve = new THREE.CatmullRomCurve3(
    destinations.map((d) => new THREE.Vector3(...d.position)),
    true,
    "centripetal",
  );
  const thread = new THREE.Group();
  thread.name = "research-red-thread";
  for (const [radius, opacity, color] of [
    [0.022, 0.95, 0xff2845],
    [0.065, 0.14, 0xff1233],
    [0.14, 0.035, 0xff1640],
  ]) {
    const mesh = new THREE.Mesh(
      new THREE.TubeGeometry(curve, 640, radius, 8, true),
      new THREE.MeshBasicMaterial({
        color,
        transparent: true,
        opacity,
        blending: THREE.AdditiveBlending,
        depthWrite: false,
      }),
    );
    thread.add(mesh);
  }
  destinationWorld.add(thread);
}
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
    color: 0x15212c,
    metalness: 0.86,
    roughness: 0.3,
  });
  const inset = new THREE.MeshStandardMaterial({
    color: 0x03080e,
    metalness: 0.6,
    roughness: 0.44,
  });
  const trim = new THREE.MeshStandardMaterial({
    color: 0x405663,
    metalness: 0.9,
    roughness: 0.23,
  });
  const cyan = new THREE.MeshBasicMaterial({ color: 0x56cadc });
  const amber = new THREE.MeshBasicMaterial({ color: 0xe7a86c });
  function box(w, h, d, x, y, z, material = hull) {
    const mesh = new THREE.Mesh(new THREE.BoxGeometry(w, h, d), material);
    mesh.position.set(x, y, z);
    cockpitRig.add(mesh);
    return mesh;
  }
  function beam(a, b, width, material = hull) {
    const start = new THREE.Vector3(...a),
      end = new THREE.Vector3(...b);
    const mesh = new THREE.Mesh(
      new THREE.BoxGeometry(width, start.distanceTo(end), width * 0.7),
      material,
    );
    mesh.position.copy(start).add(end).multiplyScalar(0.5);
    mesh.quaternion.setFromUnitVectors(
      new THREE.Vector3(0, 1, 0),
      end.sub(start).normalize(),
    );
    cockpitRig.add(mesh);
  }
  function armor(points, z, material = hull) {
    const shape = new THREE.Shape();
    points.forEach(([x, y], i) =>
      i ? shape.lineTo(x, y) : shape.moveTo(x, y),
    );
    shape.closePath();
    const mesh = new THREE.Mesh(
      new THREE.ExtrudeGeometry(shape, {
        depth: 0.055,
        bevelEnabled: true,
        bevelThickness: 0.012,
        bevelSize: 0.012,
        bevelSegments: 2,
      }),
      material,
    );
    mesh.position.z = z;
    cockpitRig.add(mesh);
  }
  const glass = new THREE.MeshBasicMaterial({
    color: 0x78bddb,
    transparent: true,
    opacity: 0.025,
    depthWrite: false,
    side: THREE.DoubleSide,
  });
  function pane(points) {
    const shape = new THREE.Shape();
    points.forEach(([x, y], i) =>
      i ? shape.lineTo(x, y) : shape.moveTo(x, y),
    );
    shape.closePath();
    const mesh = new THREE.Mesh(new THREE.ShapeGeometry(shape), glass);
    mesh.position.z = -1.55;
    cockpitRig.add(mesh);
  }
  pane([
    [-0.6, 0.6],
    [0.6, 0.6],
    [0.28, -0.2],
    [-0.28, -0.2],
  ]);
  for (const side of [-1, 1]) {
    pane([
      [side * 0.6, 0.6],
      [side * 0.68, 0.6],
      [side * 0.64, -0.42],
      [side * 0.28, -0.2],
    ]);
  }
  // Panoramic glazed canopy: open side windows, framed by solid outer sills.
  box(6, 2.1, 0.2, 0, 1.64, -1.5);
  box(6, 2.4, 0.3, 0, -1.53, -1.25);
  for (const side of [-1, 1]) {
    // Keep the opaque shell at the perimeter instead of closing the side views.
    armor(
      [
        [side * 0.68, 0.64],
        [side * 3, 0.64],
        [side * 3, -2],
        [side * 0.64, -0.48],
      ],
      -1.53,
    );
    beam([side * 0.65, 0.64, -1.48], [side * 0.6, -0.42, -1.12], 0.045);
    beam(
      [side * 0.635, 0.62, -1.445],
      [side * 0.585, -0.4, -1.085],
      0.006,
      trim,
    );
    armor(
      [
        [side * 0.3, -0.19],
        [side * 0.95, -0.4],
        [side * 1.5, -0.95],
        [side * 0.17, -0.6],
      ],
      -1.18,
      inset,
    );
    // Diagonal canopy spars with inset light guides, collars and fasteners.
    beam([side * 0.35, 0.62, -1.42], [side * 0.14, -0.2, -1.18], 0.065);
    beam(
      [side * 0.335, 0.6, -1.375],
      [side * 0.125, -0.19, -1.135],
      0.009,
      trim,
    );
    beam([side * 0.34, 0.6, -1.36], [side * 0.13, -0.19, -1.12], 0.003, cyan);
    beam([side * 0.15, -0.2, -1.1], [side * 1.1, -0.57, -0.85], 0.045, trim);
    beam([side * 0.15, -0.19, -1.075], [side * 1.1, -0.56, -0.82], 0.005, cyan);
    for (let i = 0; i < 5; i++) {
      const x = side * (0.33 - i * 0.038),
        y = 0.5 - i * 0.15;
      box(0.045, 0.016, 0.028, x, y, -1.32 + i * 0.045, inset);
      const bolt = new THREE.Mesh(new THREE.SphereGeometry(0.006, 8, 6), trim);
      bolt.position.set(x, y, -1.29 + i * 0.045);
      cockpitRig.add(bolt);
    }
    for (const [x, y, z] of [
      [0.25, 0.25, -1.25],
      [0.18, -0.08, -1.16],
    ]) {
      const collar = new THREE.Mesh(
        new THREE.CylinderGeometry(0.026, 0.026, 0.07, 16),
        trim,
      );
      collar.rotation.x = Math.PI / 2;
      collar.position.set(side * x, y, z);
      cockpitRig.add(collar);
      const lens = new THREE.Mesh(new THREE.SphereGeometry(0.011, 12, 8), cyan);
      lens.position.set(side * x, y, z + 0.04);
      cockpitRig.add(lens);
    }
    // Faceted overhead equipment and switch banks.
    armor(
      [
        [side * 0.06, 0.59],
        [side * 0.53, 0.59],
        [side * 0.48, 0.48],
        [side * 0.06, 0.49],
      ],
      -1.33,
      inset,
    );
    beam([side * 0.07, 0.56, -1.25], [side * 0.47, 0.56, -1.25], 0.004, cyan);
    for (let i = 0; i < 7; i++) {
      box(
        0.019,
        0.009,
        0.008,
        side * (0.1 + i * 0.05),
        0.525,
        -1.24,
        i === 5 ? amber : trim,
      );
      box(
        0.022,
        0.012,
        0.018,
        side * (0.38 + i * 0.045),
        -0.34 - i * 0.022,
        -1.0,
        i % 3 ? trim : cyan,
      );
    }
  }
  armor(
    [
      [-0.3, -0.2],
      [0.3, -0.2],
      [0.48, -0.57],
      [-0.48, -0.57],
    ],
    -1.12,
  );
  beam([-0.28, -0.21, -1.04], [0.28, -0.21, -1.04], 0.025, inset);
  const pedestal = new THREE.Mesh(
    new THREE.CylinderGeometry(0.13, 0.17, 0.07, 40),
    inset,
  );
  pedestal.position.set(0, -0.36, -0.92);
  cockpitRig.add(pedestal);
  const ring = new THREE.Mesh(
    new THREE.TorusGeometry(0.12, 0.003, 6, 64),
    cyan,
  );
  ring.rotation.x = Math.PI / 2;
  ring.position.set(0, -0.32, -0.92);
  cockpitRig.add(ring);
  const lamp = new THREE.PointLight(0x7fbbdc, 1.8, 4);
  lamp.position.set(0, 0.22, -0.55);
  camera.add(lamp);
  const fill = new THREE.PointLight(0x218bc6, 0.55, 3);
  fill.position.set(0, -0.27, -0.65);
  camera.add(fill);
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
    destinations
      .slice(1)
      .forEach((d, i) =>
        d.id === "agents" ? intelligenceField(d) : station(d, i),
      );
    researchThread();
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
      updateIntelligenceField(dt);
      earth.rotation.y += dt * 0.012;
      stations.forEach((s, i) => {
        s.rotation.y += dt * (0.025 + i * 0.005);
      });
    }
    camera.lookAt(look);
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
  updateMapShip();
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
