import * as THREE from "./vendor/three.module.js";
import { clueFlowPoint } from "./clue-flow-path.js";

// Illustrative clue cards: no requests, personal records or solid lunar core.
const stories = [
  ["Águas do território", "O rio revela caminhos", "e memórias da paisagem."],
  ["Memórias do lugar", "Histórias que atravessam", "gerações e encontros."],
  ["Paisagens vivas", "Pequenos sinais da vida", "nos espaços que habitamos."],
  ["Redes de cuidado", "Gestos que aproximam", "pessoas e comunidades."],
  [
    "Caminhos e encontros",
    "Percursos do cotidiano",
    "abrem novas descobertas.",
  ],
  ["Vozes do cotidiano", "Escutar o território", "é descobrir outras pistas."],
  [
    "Sinais da comunidade",
    "Um olhar atento encontra",
    "relações por toda parte.",
  ],
  ["Transformações", "O que muda ao redor", "também nos transforma."],
];

function cardTexture(story, index) {
  const canvas = document.createElement("canvas");
  canvas.width = 256;
  canvas.height = 336;
  const c = canvas.getContext("2d");
  const accent = ["#97edcf", "#9ddbe9", "#b9b8f2", "#d6dfb1"][index % 4];
  c.fillStyle = "#081c28";
  c.strokeStyle = accent;
  c.lineWidth = 2;
  c.beginPath();
  c.roundRect(5, 5, 246, 326, 14);
  c.fill();
  c.globalAlpha = 0.65;
  c.stroke();
  c.globalAlpha = 1;
  c.fillStyle = accent;
  c.fillRect(20, 22, 4, 14);
  c.font = "500 12px Space, sans-serif";
  c.fillText("PISTA / TERRITÓRIO", 34, 33);
  // Each shared card has a small abstract landscape/contour illustration.
  const sky = c.createLinearGradient(0, 52, 0, 150);
  sky.addColorStop(0, "#183d4d");
  sky.addColorStop(1, "#0b2735");
  c.fillStyle = sky;
  c.fillRect(20, 52, 216, 103);
  c.strokeStyle = accent;
  for (let layer = 0; layer < 5; layer++) {
    c.globalAlpha = 0.18 + layer * 0.1;
    c.lineWidth = layer === 2 ? 2 : 1;
    c.beginPath();
    for (let x = 20; x <= 236; x += 3) {
      const y =
        100 + Math.sin(x * 0.021 + index + layer * 0.4) * 19 + layer * 7;
      if (x === 20) c.moveTo(x, y);
      else c.lineTo(x, y);
    }
    c.stroke();
  }
  c.globalAlpha = 1;
  c.fillStyle = accent;
  c.beginPath();
  c.arc(185 - index * 9, 78 + (index % 3) * 8, 4, 0, Math.PI * 2);
  c.fill();
  c.fillStyle = "#edf9f7";
  c.font = "500 21px Space, sans-serif";
  // Explicit word wrapping keeps long titles within their own card.
  const words = story[0].split(" ");
  let line = "",
    titleY = 190;
  for (const word of words) {
    const next = line ? `${line} ${word}` : word;
    if (c.measureText(next).width > 210) {
      c.fillText(line, 22, titleY);
      titleY += 26;
      line = word;
    } else line = next;
  }
  c.fillText(line, 22, titleY);
  c.fillStyle = "#a5c5cb";
  c.font = "14px Space, sans-serif";
  c.fillText(story[1], 22, 254);
  c.fillText(story[2], 22, 274);
  c.globalAlpha = 0.4;
  c.fillStyle = accent;
  c.fillRect(22, 300, 140, 1);
  c.fillRect(222, 298, 4, 4);
  const texture = new THREE.CanvasTexture(canvas);
  texture.colorSpace = THREE.SRGBColorSpace;
  return texture;
}

// Five close strands of upright cards trace a continuous infinity symbol.
// Shared textures and geometry keep the landmark bounded on mobile GPUs.
export function createClueMoon(destination) {
  const group = new THREE.Group();
  group.name = "research-clue-infinity";
  group.position.set(...destination.position);
  const materials = stories.map((story, i) => new THREE.MeshBasicMaterial({
    map: cardTexture(story, i), side: THREE.DoubleSide,
    transparent: true, alphaTest: 0.1, depthWrite: true,
  }));
  const geometry = new THREE.PlaneGeometry(0.32, 0.43);
  const palette = [0x85e9d7, 0x82c9ee, 0xaaa1eb, 0x85d6ce, 0xa3cce9];
  function point(u, lane) {
    return new THREE.Vector3(...clueFlowPoint(u, lane));
  }
  const cards = [];
  for (let lane = 0; lane < 5; lane++) {
    for (let i = 0; i < 28; i++) {
      const card = new THREE.Mesh(geometry, materials[(i + lane) % materials.length]);
      group.add(card); cards.push({card, lane, u: (i + lane * .17) / 28});
    }
    const curve = new THREE.CatmullRomCurve3(Array.from({length: 81}, (_, i) => point(i / 80, lane)));
    const ribbon = new THREE.Mesh(new THREE.TubeGeometry(curve, 120, .012, 4, true),
      new THREE.MeshBasicMaterial({color: palette[lane], transparent: true, opacity: .32, depthWrite: false, blending: THREE.AdditiveBlending}));
    group.add(ribbon);
  }
  const canvas = document.createElement('canvas'); canvas.width = canvas.height = 64;
  const ctx = canvas.getContext('2d');
  const gradient = ctx.createRadialGradient(32, 32, 0, 32, 32, 32);
  gradient.addColorStop(0, 'rgba(255,255,255,.6)');
  gradient.addColorStop(.35, 'rgba(255,255,255,.22)');
  gradient.addColorStop(1, 'rgba(255,255,255,0)');
  ctx.fillStyle = gradient; ctx.fillRect(0, 0, 64, 64);
  const mistTexture = new THREE.CanvasTexture(canvas);
  const mist = [];
  for (let lane = 0; lane < 5; lane++) {
    const material = new THREE.SpriteMaterial({map: mistTexture, color: palette[lane], transparent: true,
      opacity: .07, depthWrite: false, blending: THREE.AdditiveBlending});
    for (let i = 0; i < 20; i++) {
      const cloud = new THREE.Sprite(material); cloud.scale.set(.72, .72, 1);
      group.add(cloud); mist.push({cloud, lane, u: i / 20});
    }
  }
  let time = 0;
  function update(dt) {
    time += dt;
    for (const item of cards) {
      const u = (item.u + time * .009) % 1;
      item.card.position.copy(point(u, item.lane));
      // Upright cards follow the current without random roll.
      item.card.rotation.y = Math.sin(u * Math.PI * 2 + item.lane) * .35;
    }
    for (const item of mist) item.cloud.position.copy(point(item.u, item.lane));
  }
  update(0);
  return {group, update};
}
