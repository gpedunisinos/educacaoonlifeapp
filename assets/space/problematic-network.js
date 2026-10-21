import * as THREE from "./vendor/three.module.js";

// Illustrative spatial landmark; actual research data remains in /nodes/graph.
export function createProblematicNetwork(destination) {
  const group = new THREE.Group();
  group.name = "observatory-problematic-network";
  group.position.set(...destination.position);
  const weave = new THREE.Group();
  group.add(weave);
  let seed = 9512;
  const random = () => {
    seed = (seed * 1664525 + 1013904223) >>> 0;
    return seed / 4294967296;
  };
  const count = 26;
  const points = Array.from({ length: count }, (_, i) => {
    const y = 1 - (i / (count - 1)) * 2;
    const angle = i * 2.3999632297 + random() * 0.2;
    const spread = Math.sqrt(1 - y * y);
    const radius = 1.8 + random() * 0.65;
    return new THREE.Vector3(
      Math.cos(angle) * spread * radius,
      y * radius * 0.84,
      Math.sin(angle) * spread * radius,
    );
  });
  const positions = points.map((p) => p.clone());
  const edges = [];
  const edgeKeys = new Set();
  const connect = (a, b) => {
    const key = `${Math.min(a, b)}:${Math.max(a, b)}`;
    if (!edgeKeys.has(key)) {
      edgeKeys.add(key);
      edges.push([a, b]);
    }
  };
  // A minimum spanning tree guarantees a single connected constellation.
  const reached = new Set([0]);
  while (reached.size < count) {
    let best = Infinity, from = 0, to = 0;
    for (const a of reached) {
      for (let b = 0; b < count; b++) {
        if (reached.has(b)) continue;
        const distance = points[a].distanceToSquared(points[b]);
        if (distance < best) {
          best = distance;
          from = a;
          to = b;
        }
      }
    }
    connect(from, to);
    reached.add(to);
  }
  // Local cross-links give the network a legible mesh, without a dense tangle.
  points.forEach((point, a) => {
    points.map((other, b) => ({ b, distance: point.distanceToSquared(other) }))
      .filter(({ b }) => b !== a)
      .sort((x, y) => x.distance - y.distance)
      .slice(0, 2)
      .forEach(({ b }) => connect(a, b));
  });
  const edgePositions = new Float32Array(edges.length * 6);
  const geometry = new THREE.BufferGeometry();
  geometry.setAttribute("position", new THREE.BufferAttribute(edgePositions, 3));
  const lines = new THREE.LineSegments(geometry, new THREE.LineBasicMaterial({
    color: 0x8dbce5,
    transparent: true,
    opacity: 0.38,
    blending: THREE.AdditiveBlending,
    depthWrite: false,
  }));
  lines.frustumCulled = false;
  weave.add(lines);

  const haloCanvas = document.createElement("canvas");
  haloCanvas.width = haloCanvas.height = 64;
  const ctx = haloCanvas.getContext("2d");
  const glow = ctx.createRadialGradient(32, 32, 0, 32, 32, 32);
  glow.addColorStop(0, "#ffffff");
  glow.addColorStop(0.15, "#ffffffa0");
  glow.addColorStop(0.45, "#ffffff22");
  glow.addColorStop(1, "#ffffff00");
  ctx.fillStyle = glow;
  ctx.fillRect(0, 0, 64, 64);
  const texture = new THREE.CanvasTexture(haloCanvas);
  const sphere = new THREE.SphereGeometry(1, 12, 10);
  // Cool tones remain predominant, with restrained rose and amber accents.
  const palette = [
    0x58d9eb, // cyan
    0xac8ce3, // violet
    0x6ba5f3, // blue
    0x6cddbb, // jade
    0xd99cbd, // muted rose
    0x899ee5, // periwinkle
    0xd8ba78, // soft amber
    0x9ad7be, // mint
  ];
  const nodes = points.map((_, i) => {
    const tint = palette[i % palette.length];
    const degree = edges.filter(([a, b]) => a === i || b === i).length;
    const radius = 0.052 + degree * 0.009;
    const core = new THREE.Mesh(sphere, new THREE.MeshBasicMaterial({ color: tint }));
    core.scale.setScalar(radius);
    weave.add(core);
    const halo = new THREE.Sprite(new THREE.SpriteMaterial({
      map: texture,
      color: tint,
      transparent: true,
      opacity: 0.72,
      blending: THREE.AdditiveBlending,
      depthWrite: false,
    }));
    halo.scale.setScalar(radius * 6);
    weave.add(halo);
    return { core, halo, phase: random() * Math.PI * 2 };
  });
  // Sparse light impulses reveal the links without competing with the nodes.
  const impulses = Array.from({ length: 5 }, (_, i) => {
    const light = new THREE.Mesh(sphere, new THREE.MeshBasicMaterial({ color: 0xdbf9ff }));
    light.scale.setScalar(0.023);
    weave.add(light);
    return { light, edge: edges[Math.floor(i * edges.length / 5)], phase: random() };
  });
  let time = 0;
  function update(dt) {
    time += dt;
    // Continuous slow turns on several axes; no abrupt random direction changes.
    weave.rotation.set(
      0.22 + Math.sin(time * 0.071) * 0.3,
      time * 0.075 + Math.sin(time * 0.043) * 0.18,
      -0.13 + Math.sin(time * 0.059) * 0.17,
    );
    nodes.forEach((node, i) => {
      const phase = node.phase;
      positions[i].set(
        points[i].x + Math.sin(time * 0.24 + phase) * 0.07,
        points[i].y + Math.cos(time * 0.19 + phase) * 0.07,
        points[i].z + Math.sin(time * 0.21 + phase * 2) * 0.07,
      );
      node.core.position.copy(positions[i]);
      node.halo.position.copy(positions[i]);
      node.halo.material.opacity = 0.65 + Math.sin(time * 0.7 + phase) * 0.1;
    });
    edges.forEach(([a, b], i) => {
      positions[a].toArray(edgePositions, i * 6);
      positions[b].toArray(edgePositions, i * 6 + 3);
    });
    geometry.attributes.position.needsUpdate = true;
    impulses.forEach(({ light, edge: [a, b], phase }) => {
      light.position.lerpVectors(positions[a], positions[b], (time * 0.12 + phase) % 1);
    });
  }
  update(0);
  return { group, update };
}
