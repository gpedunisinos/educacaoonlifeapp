// A living weave rather than a solid core. Drawn locally, with no image asset.
export class IareteFlow {
  constructor(canvas) {
    this.canvas = canvas;
    this.ctx = canvas.getContext("2d");
    this.time = 0;
    this.activity = 0;
    this.accumulator = 1;
    this.lastReduced = null;
    this.colors = ["#80e9e0", "#a7deff", "#b8adf4", "#e8afbc", "#dceac9"];
  }

  point(u, strand, time) {
    const envelope = Math.pow(Math.sin(Math.PI * u), 0.8);
    const phase = strand * 2.39996;
    const swell = 1 + this.activity * 0.12;
    return [
      12 + u * 216,
      67 + Math.sin(u * 6.5 - time * 0.45) * 10 +
        envelope * swell * (
          Math.sin(u * 9 + phase + time * (0.32 + strand % 3 * 0.05)) * (13 + strand % 5 * 3) +
          Math.cos(u * 16 - phase - time * 0.22) * 5),
    ];
  }

  draw(dt, reduced, speaking) {
    if (!this.ctx) return;
    this.accumulator += dt;
    const rect = this.canvas.getBoundingClientRect();
    const ratio = Math.min(window.devicePixelRatio || 1, 2);
    const width = Math.round(rect.width * ratio);
    const height = Math.round(rect.height * ratio);
    if (!width || !height) return;
    const resized = this.canvas.width !== width || this.canvas.height !== height;
    // Static, stable composition in reduced motion; pause follows the scene RAF.
    if (!resized && reduced && this.lastReduced === true) return;
    if (!resized && !reduced && this.accumulator < 1 / 30) return;
    const delta = Math.min(this.accumulator, 0.1);
    this.accumulator = 0;
    this.lastReduced = reduced;
    if (!reduced) this.time += delta;
    this.activity += ((speaking && !reduced ? 1 : 0) - this.activity) * Math.min(delta * 4, 1);
    if (resized) {
      this.canvas.width = width;
      this.canvas.height = height;
    }
    const c = this.ctx;
    c.setTransform(width / 240, 0, 0, height / 134, 0, 0);
    c.clearRect(0, 0, 240, 134);
    const time = reduced ? 0 : this.time;
    c.globalCompositeOperation = "lighter";
    // Fine filaments braid across an asymmetric, gently undulating silhouette.
    for (let strand = 0; strand < 30; strand++) {
      const color = this.colors[strand % this.colors.length];
      const fade = c.createLinearGradient(12, 0, 228, 0);
      fade.addColorStop(0, color + "00");
      fade.addColorStop(0.18, color + "70");
      fade.addColorStop(0.48, color + (strand % 4 === 0 ? "d0" : "80"));
      fade.addColorStop(0.82, color + "60");
      fade.addColorStop(1, color + "00");
      c.strokeStyle = fade;
      c.shadowColor = color;
      c.shadowBlur = 4 + this.activity * 3;
      c.lineWidth = strand % 4 === 0 ? 1.05 : 0.5;
      c.beginPath();
      for (let step = 0; step <= 80; step++) {
        const [x, y] = this.point(step / 80, strand, time);
        if (step === 0) c.moveTo(x, y);
        else c.lineTo(x, y);
      }
      c.stroke();
      // Short cross-threads evoke an organic network without a central nucleus.
      if (strand % 2 === 0) {
        const u = 0.22 + (strand * 0.137 % 0.57);
        const a = this.point(u, strand, time);
        const b = this.point(u + 0.055, strand + 1, time);
        c.globalAlpha = 0.3;
        c.beginPath();
        c.moveTo(...a);
        c.bezierCurveTo(a[0] + 7, a[1], b[0] - 7, b[1], ...b);
        c.stroke();
        c.globalAlpha = 1;
      }
      // Glints travel along their own filament, never around a mechanical ring.
      if (strand % 3 === 0) {
        const u = (strand * 0.173 + time * (0.035 + this.activity * 0.018)) % 1;
        const [x, y] = this.point(u, strand, time);
        c.globalAlpha = Math.sin(Math.PI * u) * 0.85;
        c.fillStyle = color;
        c.shadowBlur = 7;
        c.beginPath();
        c.arc(x, y, strand % 2 === 0 ? 1.05 : 0.7, 0, Math.PI * 2);
        c.fill();
        c.globalAlpha = 1;
      }
    }
    c.shadowBlur = 0;
    c.globalCompositeOperation = "source-over";
  }
}
