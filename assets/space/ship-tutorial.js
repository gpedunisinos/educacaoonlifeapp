// Guided, non-destructive tour. The actual cockpit remains visible beneath it.
export function positionTutorialCard(target, viewport, card) {
  const margin = 16,
    gap = 20;
  const clamp = (n, max) => Math.max(margin, Math.min(n, max - margin));
  const candidates = [
    [target.right + gap, target.top],
    [target.left - card.width - gap, target.top],
    [(viewport.width - card.width) / 2, target.top - card.height - gap],
    [(viewport.width - card.width) / 2, target.bottom + gap],
  ];
  return candidates
    .map(([x, y]) => {
      x = clamp(x, viewport.width - card.width);
      y = clamp(y, viewport.height - card.height);
      const overlap =
        Math.max(
          0,
          Math.min(x + card.width, target.right) - Math.max(x, target.left),
        ) *
        Math.max(
          0,
          Math.min(y + card.height, target.bottom) - Math.max(y, target.top),
        );
      return { x, y, overlap };
    })
    .sort((a, b) => a.overlap - b.overlap)[0];
}

export class ShipTutorial {
  constructor({ steps, say, complete, sound }) {
    this.steps = steps;
    this.say = say;
    this.complete = complete;
    this.sound = sound;
    this.root = document.getElementById("ship-tutorial");
    this.card = document.getElementById("tour-card");
    this.back = document.getElementById("tour-back");
    this.next = document.getElementById("tour-next");
    this.back.onclick = () => this.show(this.index - 1);
    this.next.onclick = () =>
      this.index === this.items.length - 1
        ? this.finish(false)
        : this.show(this.index + 1);
    document.getElementById("tour-skip").onclick = () => this.finish(true);
    this.layout = () => this.position();
    this.keys = (event) => {
      if (!this.active) return;
      event.stopImmediatePropagation();
      if (event.key === "Escape") {
        event.preventDefault();
        this.finish(true);
      }
      if (event.key === "ArrowRight") {
        event.preventDefault();
        this.next.click();
      }
      if (event.key === "ArrowLeft") {
        event.preventDefault();
        this.back.click();
      }
      if (event.key === "Tab") {
        const controls = [
          ...this.root.querySelectorAll("button:not(:disabled)"),
        ];
        const first = controls[0],
          last = controls.at(-1);
        if (event.shiftKey && document.activeElement === first) {
          event.preventDefault();
          last.focus();
        } else if (!event.shiftKey && document.activeElement === last) {
          event.preventDefault();
          first.focus();
        }
      }
    };
    window.addEventListener("keydown", this.keys, true);
    window.addEventListener("resize", this.layout);
    document.addEventListener("scroll", this.layout, true);
    this.observer = new ResizeObserver(this.layout);
    this.observer.observe(this.card);
    this.observer.observe(document.querySelector(".console"));
  }
  get active() {
    return !this.root.hidden;
  }
  target(step) {
    for (const selector of step.targets) {
      const node = document.querySelector(selector);
      if (
        node &&
        node.getClientRects().length &&
        getComputedStyle(node).visibility !== "hidden"
      )
        return node;
    }
    return document.querySelector("#destinations");
  }
  start() {
    if (this.active) return;
    this.previousFocus = document.activeElement;
    this.scrollTop = document.querySelector(".console").scrollTop;
    this.items = this.steps();
    this.root.hidden = false;
    document.body.classList.add("tour-active");
    document
      .getElementById("message-accessible")
      .setAttribute("aria-live", "off");
    this.show(0);
  }
  show(index) {
    if (index < 0 || index >= this.items.length) return;
    this.index = index;
    const step = this.items[index];
    document.getElementById("tour-title").textContent = step.title;
    document.getElementById("tour-text").textContent = step.text;
    document.getElementById("tour-count").textContent =
      `${index + 1} / ${this.items.length}`;
    this.back.disabled = index === 0;
    this.next.textContent =
      index === this.items.length - 1 ? "Começar a explorar" : "Próximo";
    this.target(step).scrollIntoView({
      block: "nearest",
      inline: "nearest",
      behavior: "instant",
    });
    this.position();
    this.say(step.text);
    this.sound();
    this.next.focus({ preventScroll: true });
  }
  position() {
    if (!this.active || !this.items) return;
    const rect = this.target(this.items[this.index]).getBoundingClientRect();
    const w = innerWidth,
      h = innerHeight;
    const x = Math.max(4, rect.left - 7),
      y = Math.max(4, rect.top - 7);
    const right = Math.min(w - 4, rect.right + 7),
      bottom = Math.min(h - 4, rect.bottom + 7);
    document
      .getElementById("tour-mask")
      .setAttribute(
        "d",
        `M0 0H${w}V${h}H0Z M${x} ${y}V${bottom}H${right}V${y}Z`,
      );
    const ring = document.getElementById("tour-ring");
    Object.assign(ring.style, {
      left: `${x}px`,
      top: `${y}px`,
      width: `${right - x}px`,
      height: `${bottom - y}px`,
    });
    const pos = positionTutorialCard(
      rect,
      { width: w, height: h },
      this.card.getBoundingClientRect(),
    );
    Object.assign(this.card.style, { left: `${pos.x}px`, top: `${pos.y}px` });
  }
  finish(skipped) {
    if (!this.active) return;
    this.root.hidden = true;
    document.body.classList.remove("tour-active");
    document.querySelector(".console").scrollTop = this.scrollTop;
    document
      .getElementById("message-accessible")
      .setAttribute("aria-live", "polite");
    this.complete(skipped);
    const focus = this.previousFocus?.isConnected
      ? this.previousFocus
      : document.getElementById("navigate");
    focus.focus({ preventScroll: true });
  }
}
