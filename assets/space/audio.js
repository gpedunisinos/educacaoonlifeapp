// Original procedural score. No recordings or external audio requests.
export class SpaceAudio {
  constructor() {
    this.enabled = false;
    this.paused = false;
    this.tickIndex = 0;
  }
  async enable(value) {
    this.enabled = value;
    if (!value) {
      this.ctx?.suspend();
      return;
    }
    try {
      if (!this.ctx) this.create();
      if (!this.paused) await this.ctx.resume();
    } catch (_) {
      this.enabled = false;
    }
  }
  create() {
    const AudioContext = window.AudioContext || window.webkitAudioContext;
    this.ctx = new AudioContext();
    const ctx = this.ctx;
    this.master = ctx.createGain();
    this.master.gain.value = 0.24;
    const compressor = ctx.createDynamicsCompressor();
    this.master.connect(compressor);
    compressor.connect(ctx.destination);
    [55, 82.4069, 110, 164.8138].forEach((frequency, i) => {
      const oscillator = ctx.createOscillator(),
        gain = ctx.createGain();
      oscillator.type = "sine";
      oscillator.frequency.value = frequency;
      gain.gain.value = 0.025 / (i + 1);
      oscillator.connect(gain);
      gain.connect(this.master);
      oscillator.start();
      const lfo = ctx.createOscillator(),
        depth = ctx.createGain();
      lfo.frequency.value = 0.08 + i * 0.023;
      depth.gain.value = 0.008 / (i + 1);
      lfo.connect(depth);
      depth.connect(gain.gain);
      lfo.start();
    });
    this.engine = ctx.createOscillator();
    this.engine.type = "triangle";
    this.engine.frequency.value = 42;
    this.engineGain = ctx.createGain();
    this.engineGain.gain.value = 0.008;
    const filter = ctx.createBiquadFilter();
    filter.type = "lowpass";
    filter.frequency.value = 180;
    this.engine.connect(filter);
    filter.connect(this.engineGain);
    this.engineGain.connect(this.master);
    this.engine.start();
  }
  tone(frequency, duration = 0.09, volume = 0.06, delay = 0, type = "sine") {
    if (!this.enabled || this.paused || this.ctx?.state !== "running") return;
    const ctx = this.ctx,
      now = ctx.currentTime + delay;
    const oscillator = ctx.createOscillator(),
      gain = ctx.createGain();
    oscillator.type = type;
    oscillator.frequency.value = frequency;
    gain.gain.setValueAtTime(0, now);
    gain.gain.linearRampToValueAtTime(volume, now + 0.008);
    gain.gain.exponentialRampToValueAtTime(0.0001, now + duration);
    oscillator.connect(gain);
    gain.connect(this.master);
    oscillator.start(now);
    oscillator.stop(now + duration + 0.03);
    oscillator.onended = () => {
      oscillator.disconnect();
      gain.disconnect();
    };
  }
  type() {
    const notes = [523.25, 659.25, 783.99, 987.77, 783.99, 659.25];
    this.tone(
      notes[this.tickIndex++ % notes.length],
      0.055,
      0.028,
      0,
      "triangle",
    );
  }
  select() {
    this.tone(523.25, 0.12, 0.08);
    this.tone(783.99, 0.16, 0.05, 0.07);
  }
  arrival() {
    [261.63, 329.63, 392, 523.25].forEach((n, i) =>
      this.tone(n, 0.8, 0.08, i * 0.12),
    );
  }
  depart() {
    [130.81, 196, 261.63, 392].forEach((n, i) =>
      this.tone(n, 0.45, 0.07, i * 0.1),
    );
  }
  throttle(value) {
    if (!this.ctx) return;
    this.engine.frequency.setTargetAtTime(
      42 + value * 65,
      this.ctx.currentTime,
      0.3,
    );
    this.engineGain.gain.setTargetAtTime(
      0.008 + value * 0.14,
      this.ctx.currentTime,
      0.4,
    );
  }
  pause(value) {
    this.paused = value;
    if (value) this.ctx?.suspend();
    else if (this.enabled) this.ctx?.resume().catch(() => {});
  }
  dispose() {
    this.ctx?.close();
  }
}
