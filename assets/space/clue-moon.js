import * as THREE from "./vendor/three.module.js";

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

export function createClueMoon(destination) {
  const group = new THREE.Group();
  group.name = "research-hollow-clue-moon";
  group.position.set(...destination.position);
  const shell = new THREE.Group();
  group.add(shell);
  const materials = stories.map(
    (story, i) =>
      new THREE.MeshBasicMaterial({
        map: cardTexture(story, i),
        side: THREE.DoubleSide,
        transparent: true,
        alphaTest: 0.1,
        // Cards occlude cards behind them, while their open gaps reveal the space.
        depthWrite: true,
      }),
  );
  const geometry = new THREE.PlaneGeometry(0.57, 0.75);
  const normal = new THREE.Vector3(0, 0, 1);
  const count = 96;
  const cards = Array.from({ length: count }, (_, i) => {
    const y = 1 - (2 * (i + 0.5)) / count;
    const angle = i * 2.399963229728653;
    const spread = Math.sqrt(1 - y * y);
    const direction = new THREE.Vector3(
      Math.cos(angle) * spread,
      y,
      Math.sin(angle) * spread,
    );
    const card = new THREE.Mesh(geometry, materials[i % materials.length]);
    const radius = 2.36 + Math.sin(i * 9.17) * 0.065;
    card.position.copy(direction).multiplyScalar(radius);
    card.quaternion.setFromUnitVectors(normal, direction);
    card.rotateZ(Math.sin(i * 3.71) * 0.12);
    shell.add(card);
    return { card, direction, radius, phase: i * 1.618 };
  });
  let time = 0;
  function update(dt) {
    time += dt;
    shell.rotation.set(
      0.2 + Math.sin(time * 0.037) * 0.12,
      time * 0.055,
      -0.14 + Math.sin(time * 0.041) * 0.07,
    );
    for (const { card, direction, radius, phase } of cards) {
      card.position
        .copy(direction)
        .multiplyScalar(radius + Math.sin(time * 0.33 + phase) * 0.035);
    }
  }
  update(0);
  return { group, update };
}
