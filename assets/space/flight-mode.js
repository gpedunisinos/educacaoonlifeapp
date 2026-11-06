// Confirmed account state controls the lever; no optimistic permission changes.
export class FlightModeSwitch {
  constructor(root, {request, changed}) {
    this.root = root;
    this.request = request;
    this.changed = changed;
    this.mode = 'explorer';
    this.ready = false;
    this.busy = false;
    this.buttons = ['explorer', 'inventor'].map(mode => {
      const button = root.querySelector(`#mode-${mode}`);
      button.onclick = () => this.choose(mode);
      return button;
    });
  }
  choose(mode) {
    if (!this.ready || this.busy || mode === this.mode || !['explorer', 'inventor'].includes(mode)) return;
    this.busy = true;
    this.buttons.forEach(button => { button.disabled = true; });
    this.root.setAttribute('aria-busy', 'true');
    this.root.querySelector('#mode-status').textContent = `Ativando ${mode === 'inventor' ? 'Inventor' : 'Explorador'}…`;
    this.request(mode);
  }
  update({mode, error, announce = false}) {
    if (!['explorer', 'inventor'].includes(mode)) return;
    const previous = this.mode;
    this.mode = mode;
    this.ready = true;
    this.busy = false;
    this.root.setAttribute('aria-busy', 'false');
    this.root.dataset.mode = mode;
    document.body.dataset.flightMode = mode;
    const tag = document.getElementById?.('ship-mode-tag');
    if (tag) tag.textContent = `EC–01 / ${mode === 'inventor' ? 'INVENTOR' : 'EXPLORADOR'}`;
    this.buttons.forEach((button, index) => {
      button.disabled = false;
      button.setAttribute('aria-pressed', String(index === (mode === 'inventor' ? 1 : 0)));
    });
    this.root.querySelector('#mode-status').textContent = error || '';
    this.root.classList.toggle('mode-error', Boolean(error));
    if (!error && announce && mode !== previous) this.changed(mode);
  }
  focus() {
    this.root.scrollIntoView({block: 'nearest', behavior: document.body.classList?.contains('reduced') ? 'instant' : 'smooth'});
    this.buttons[this.mode === 'inventor' ? 1 : 0].focus({preventScroll: true});
  }
}
