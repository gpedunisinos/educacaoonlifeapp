import * as THREE from './vendor/three.module.js';

// Section presence only. No tokens, user IDs or authored content enter this scene.
export class RemoteFleet {
  constructor(destinations, emit) {
    this.destinations = destinations;
    this.emit = emit;
    this.group = new THREE.Group();
    this.ships = new Map();
    this.slots = new Map();
    this.people = [];
    this.available = false;
    this.self = '';
    this.time = 0;
    this.layer = document.getElementById('presence-labels');
    this.button = document.getElementById('presence-open');
    this.dialog = document.getElementById('presence-dialog');
    this.list = document.getElementById('presence-list');
    this.bodyGeometry = new THREE.ConeGeometry(.24, .95, 4);
    this.wingGeometry = new THREE.BoxGeometry(1.15, .045, .37);
    this.engineGeometry = new THREE.SphereGeometry(.095, 8, 6);
    this.trimGeometry = new THREE.BoxGeometry(.88, .015, .025);
    this.trailGeometry = new THREE.ConeGeometry(.065, .9, 6);
    this.trailMaterial = new THREE.MeshBasicMaterial({color:0x7de8e4,transparent:true,opacity:.28,depthWrite:false,blending:THREE.AdditiveBlending});
    this.material = new THREE.MeshStandardMaterial({color:0x54788c,metalness:.8,roughness:.36,emissive:0x0d2839,emissiveIntensity:.7});
    this.light = new THREE.MeshBasicMaterial({color:0x93f4e5});
    this.button.onclick = () => this.showList();
    document.getElementById('presence-close').onclick = () => this.dialog.close();
    this.dialog.addEventListener('click', e => { if (e.target === this.dialog) this.dialog.close(); });
    this.dialog.addEventListener('close', () => this.button.focus());
  }
  hash(id) { let h=2166136261; for(const c of id) h=Math.imul(h^c.charCodeAt(0),16777619); return h>>>0; }
  update(data) {
    this.available = data.available === true;
    this.self = typeof data.self === 'string' ? data.self : '';
    this.people = Array.isArray(data.participants) ? data.participants.filter(p => typeof p.id==='string' && typeof p.name==='string' && typeof p.activity==='string' && ['cockpit',...this.destinations.map(d=>d.id)].includes(p.destination)) : [];
    this.button.textContent = this.available ? `◈ Pessoas online · ${this.people.length}` : '◈ Presença indisponível';
    this.button.setAttribute('aria-label',this.available ? `Pessoas online: ${this.people.length}. Ver participantes` : 'Presença temporariamente indisponível. Ver estado');
    const others = new Map(this.people.filter(p=>p.id!==this.self).map(p=>[p.id,p]));
    for(const [id,ship] of this.ships) if(!this.available || !others.has(id)) { this.group.remove(ship.object);ship.label.remove();this.ships.delete(id);for(const slots of this.slots.values())slots.delete(id); }
    for(const [id,p] of others) {
      if(!this.available) break;
      let ship=this.ships.get(id);
      if(!ship) {
        const object=new THREE.Group();object.scale.setScalar(.7);
        const hull=new THREE.Mesh(this.bodyGeometry,this.material);hull.rotation.x=-Math.PI/2;object.add(hull);
        const wings=new THREE.Mesh(this.wingGeometry,this.material);wings.position.z=.14;wings.rotation.z=.09;object.add(wings);
        const trim=new THREE.Mesh(this.trimGeometry,this.light);trim.position.set(0,.04,.14);object.add(trim);
        const trail=new THREE.Mesh(this.trailGeometry,this.trailMaterial);trail.rotation.x=Math.PI/2;trail.position.z=.93;object.add(trail);
        const engine=new THREE.Mesh(this.engineGeometry,this.light);engine.position.z=.48;object.add(engine);
        const label=document.createElement('button');label.className='presence-name';label.type='button';label.hidden=true;
        label.onclick=()=>this.showList(id);this.layer.append(label);
        ship={object,label,seed:this.hash(id),initialized:false,person:p,engine};this.ships.set(id,ship);this.group.add(object);
      }
      ship.person=p;ship.label.textContent=p.name;ship.label.title=`${p.name} — ${p.activity}`;
      ship.label.setAttribute('aria-label',`${p.name} — ${p.activity}. Ver identificação`);
    }
    if(this.dialog.open) this.renderList();
  }
  renderList(selected) {
    this.list.replaceChildren();
    if(!this.available) {const line=document.createElement('p');line.textContent='Presença temporariamente indisponível. A navegação continua normalmente.';this.list.append(line);return;}
    for(const p of [...this.people].sort((a,b)=>a.name.localeCompare(b.name))) {
      const row=document.createElement('li');if(p.id===selected)row.className='presence-selected';
      const name=document.createElement('strong');name.textContent=p.id===this.self?`${p.name} · Você`:p.name;
      const activity=document.createElement('span');activity.textContent=p.activity;
      row.append(name,activity);this.list.append(row);
    }
  }
  showList(id) { this.renderList(id);if(!this.dialog.open)this.dialog.showModal();const selected=this.list.querySelector('.presence-selected');selected?.scrollIntoView({block:'nearest'}); }
  dispose() {
    for(const ship of this.ships.values()) { this.group.remove(ship.object);ship.label.remove(); }
    this.ships.clear();
    this.bodyGeometry.dispose();this.wingGeometry.dispose();this.engineGeometry.dispose();this.trimGeometry.dispose();this.trailGeometry.dispose();this.trailMaterial.dispose();this.material.dispose();this.light.dispose();
  }
  draw(dt,camera,reduced,showLabels=true,area="") {
    this.time+=dt;
    const occupied=[];
    const forward=new THREE.Vector3(0,0,-1).applyQuaternion(camera.quaternion);
    const right=new THREE.Vector3(1,0,0).applyQuaternion(camera.quaternion);
    for(const ship of this.ships.values()) {
      const p=ship.person;
      if(!this.slots.has(p.destination)) this.slots.set(p.destination,new Map());
      const slots=this.slots.get(p.destination);
      if(!slots.has(p.id)) {let slot=ship.seed%36;const taken=new Set(slots.values());while(taken.has(slot))slot++;slots.set(p.id,slot);}
      const slot=slots.get(p.id);
      const angle=(slot%12)/12*Math.PI*2;
      const ring=Math.floor(slot/12);
      const destination=this.destinations.find(d=>d.id===p.destination);
      let target;
      if(destination) {
        const radius=destination.radius;
        target=new THREE.Vector3(...destination.position).add(new THREE.Vector3(Math.sin(angle)*radius*(.85+ring*.17),radius*.05+Math.cos(angle)*radius*.12, radius*(1.15+ring*.2)));
      } else {
        target=camera.position.clone().addScaledVector(forward,19+ring*3).addScaledVector(right,Math.cos(angle)*7);
        target.y+=Math.sin(angle)*2.3;
        if(area && ship.cruiseTarget) target.copy(ship.cruiseTarget);
        else if(!area) ship.cruiseTarget=target.clone();
      }
      if(!reduced)target.y+=Math.sin(this.time*.5+angle)*.13;
      if(!ship.initialized || reduced) {ship.object.position.copy(target);ship.initialized=true;} else ship.object.position.lerp(target,1-Math.exp(-dt*1.4));
      ship.object.lookAt(ship.object.position.clone().add(forward));
      ship.engine.scale.setScalar(reduced?1:1+Math.sin(this.time*3+angle)*.12);
      const screen=ship.object.position.clone().project(camera);
      const x=(screen.x*.5+.5)*innerWidth,y=(-screen.y*.5+.5)*innerHeight;
      const w=Math.max(84,Math.min(155,p.name.length*8+20));
      const safe=screen.z>-1&&screen.z<1&&x>innerWidth*.22&&x<innerWidth*.78&&y>innerHeight*.20&&y<innerHeight*.54;
      const overlap=occupied.some(r=>Math.abs(r.x-x)<(r.w+w)/2&&Math.abs(r.y-y)<42);
      ship.label.hidden=!showLabels||!safe||overlap||occupied.length>=12;
      if(!ship.label.hidden) {ship.label.style.left=`${x}px`;ship.label.style.top=`${y+22}px`;occupied.push({x,y,w});}
    }
  }
}
