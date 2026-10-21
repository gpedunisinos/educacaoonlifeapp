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
    this.profile = document.getElementById('participant-dialog');
    this.selectedPerson = null;
    this.raycaster = new THREE.Raycaster();
    this.pointer = new THREE.Vector2();
    document.getElementById('participant-close').onclick = () => this.profile.close();
    document.getElementById('participant-list').onclick = () => { this.profile.close();this.showList(this.selectedPerson?.id); };
    document.getElementById('participant-converse').onclick = () => { const id=this.selectedPerson?.id;if(!id)return;this.profile.close();this.emit('participant-chat',{participant:id}); };
    this.profile.addEventListener('click',e=>{if(e.target===this.profile)this.profile.close();});
    this.profile.addEventListener('close',()=>this.button.focus());
    document.getElementById('conversations-open').onclick=()=>this.emit('conversations');
    this.bodyGeometry = new THREE.ConeGeometry(.24, .95, 4);
    this.wingGeometry = new THREE.BoxGeometry(1.15, .045, .37);
    this.engineGeometry = new THREE.SphereGeometry(.095, 8, 6);
    this.trimGeometry = new THREE.BoxGeometry(.88, .015, .025);
    this.trailGeometry = new THREE.ConeGeometry(.065, .9, 6);
    this.trailMaterial = new THREE.MeshBasicMaterial({color:0x7de8e4,transparent:true,opacity:.28,depthWrite:false,blending:THREE.AdditiveBlending});
    this.material = new THREE.MeshStandardMaterial({color:0x54788c,metalness:.35,roughness:.45,emissive:0x183d4a,emissiveIntensity:1.2});
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
        object.userData.participant=id;
        label.onclick=()=>this.showParticipant(id);this.layer.append(label);
        ship={object,label,seed:this.hash(id),initialized:false,person:p,engine};this.ships.set(id,ship);this.group.add(object);
      }
      ship.person=p;ship.label.textContent=p.name;ship.label.title=`${p.name} — ${p.activity}`;
      ship.label.setAttribute('aria-label',`${p.name} — ${p.activity}. Ver identificação`);
    }
    if(this.dialog.open) this.renderList();
    if(this.profile.open) this.renderParticipant();
  }
  renderList(selected) {
    this.list.replaceChildren();
    if(!this.available) {const line=document.createElement('p');line.textContent='Presença temporariamente indisponível. A navegação continua normalmente.';this.list.append(line);return;}
    for(const p of [...this.people].sort((a,b)=>a.name.localeCompare(b.name))) {
      const row=document.createElement('li');if(p.id===selected)row.className='presence-selected';
      const name=document.createElement('strong');name.textContent=p.id===this.self?`${p.name} · Você`:p.name;
      const activity=document.createElement('span');activity.textContent=p.activity;
      row.append(name,activity);
      if(p.id!==this.self) {const action=document.createElement('button');action.className='participant-identify';action.type='button';action.textContent='Ver identificação';action.setAttribute('aria-label',`Ver identificação de ${p.name}`);action.onclick=()=>{this.dialog.close();this.showParticipant(p.id);};row.append(action);}
      this.list.append(row);
    }
  }
  showList(id) { this.renderList(id);if(!this.dialog.open)this.dialog.showModal();const selected=this.list.querySelector('.presence-selected');selected?.scrollIntoView({block:'nearest'}); }
  showParticipant(id) {
    const p=this.people.find(p=>p.id===id&&p.id!==this.self);if(!p)return;
    this.selectedPerson=p;this.renderParticipant();if(!this.profile.open)this.profile.showModal();
  }
  renderParticipant() {
    const current=this.people.find(p=>p.id===this.selectedPerson?.id);
    const p=current||this.selectedPerson;if(!p)return;
    if(current)this.selectedPerson=current;
    document.getElementById('participant-name').textContent=p.name;
    document.getElementById('participant-activity').textContent=current&&this.available?p.activity:'Participante desconectado';
    const destination=this.destinations.find(d=>d.id===p.destination);
    document.getElementById('participant-destination').textContent=`Região: ${destination?.name||'Espaço aberto · cockpit'}`;
    document.getElementById('participant-converse').disabled=!current||!this.available;
  }
  pick(event,camera) {
    if(!this.available||this.dialog.open||this.profile.open||event.target.closest('button,a,input,textarea,dialog,header,.console,.glass-instrument,#ship-tutorial'))return;
    const x=event.clientX/innerWidth,y=event.clientY/innerHeight;
    if(x<.2||x>.8||y<.18||y>.58)return;
    this.pointer.set(x*2-1,-y*2+1);this.raycaster.setFromCamera(this.pointer,camera);
    const hit=this.raycaster.intersectObjects([...this.ships.values()].map(s=>s.object),true)[0];
    if(!hit) {
      // Keep small ships usable by touch; the name and list remain keyboard alternatives.
      let nearest=null,distance=24;
      for(const ship of this.ships.values()) {
        const p=ship.object.position.clone().project(camera);if(p.z<=-1||p.z>=1)continue;
        const pixels=Math.hypot((p.x*.5+.5)*innerWidth-event.clientX,(-p.y*.5+.5)*innerHeight-event.clientY);
        if(pixels<distance){distance=pixels;nearest=ship.person.id;}
      }
      if(nearest)this.showParticipant(nearest);return;
    }
    let object=hit.object;while(object&&!object.userData.participant)object=object.parent;
    if(object?.userData.participant)this.showParticipant(object.userData.participant);
  }
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
    const up=new THREE.Vector3(0,1,0).applyQuaternion(camera.quaternion);
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
        target=camera.position.clone().addScaledVector(forward,19+ring*3).addScaledVector(right,Math.cos(angle)*4.5);
        target.addScaledVector(up,1.4+Math.sin(angle)*1.2);
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
