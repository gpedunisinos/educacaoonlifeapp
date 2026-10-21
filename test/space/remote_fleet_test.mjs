import {test} from 'node:test';
import assert from 'node:assert/strict';
import * as THREE from '../../assets/space/vendor/three.module.js';
import {RemoteFleet} from '../../assets/space/remote-fleet.js';

function fixture() {
  const nodes=new Map();
  const node=()=>({textContent:'',hidden:true,open:false,style:{},children:[],setAttribute(){},addEventListener(){},append(child){this.children.push(child);},remove(){},replaceChildren(){this.children=[];},focus(){},close(){this.open=false;},showModal(){this.open=true;},querySelector(){return null;}});
  globalThis.document={getElementById(id){if(!nodes.has(id))nodes.set(id,node());return nodes.get(id);},createElement:node};
  globalThis.innerWidth=1280;globalThis.innerHeight=720;
  const destinations=[{id:'earth',position:[0,0,0],radius:8},{id:'research',position:[80,5,-30],radius:5}];
  const fleet=new RemoteFleet(destinations,()=>{});
  const people=[['a','cockpit'],['b','earth'],['c','research']].map(([id,destination])=>({id,destination,name:id,activity:'Na plataforma'}));
  fleet.update({available:true,self:'self',participants:people});
  const camera=new THREE.PerspectiveCamera(60,1280/720,.1,1000);camera.position.set(0,5,30);camera.lookAt(0,0,0);camera.updateMatrixWorld();
  return {fleet,camera,people};
}
test('only ships in the observer region render, while online list stays global',()=>{
  const {fleet,camera}=fixture();
  for(const area of ['cockpit','earth','research','jump']) {
    fleet.draw(.016,camera,true,true,area);
    for(const ship of fleet.ships.values()) {
      assert.equal(ship.object.visible,ship.person.destination===area);
      if(!ship.object.visible)assert.equal(ship.label.hidden,true);
    }
    assert.equal(fleet.people.length,3);
  }
  fleet.dispose();
});
test('cruise ships remain anchored when the observer moves and turns',()=>{
  const {fleet,camera}=fixture();
  fleet.draw(.016,camera,true,true,'cockpit');
  const ship=fleet.ships.get('a');const original=ship.object.position.clone();
  camera.position.set(80,15,12);camera.lookAt(-90,0,40);camera.updateMatrixWorld();
  fleet.draw(.016,camera,true,true,'cockpit');
  assert.ok(ship.object.position.distanceTo(original)<1e-9);
  fleet.dispose();
});
test('remote arrival moves that participant only and never changes others regions',()=>{
  const {fleet,camera,people}=fixture();
  fleet.draw(.016,camera,true,true,'cockpit');
  fleet.update({available:true,self:'self',participants:people.map(p=>p.id==='a'?{...p,destination:'earth'}:p)});
  fleet.draw(.016,camera,true,true,'cockpit');
  assert.equal(fleet.ships.get('a').object.visible,false);
  fleet.draw(.016,camera,true,true,'earth');
  assert.equal(fleet.ships.get('a').object.visible,true);
  assert.equal(fleet.ships.get('b').object.visible,true);
  assert.equal(fleet.ships.get('c').object.visible,false);
  assert.ok(fleet.ships.get('a').object.position.length()<30);
  fleet.dispose();
});
test('invisible ships cannot be picked by raycasting or touch fallback',()=>{
  const {fleet,camera}=fixture();fleet.draw(.016,camera,true,true,'jump');
  let candidates=null;fleet.raycaster.intersectObjects=objects=>{candidates=objects;return [];};
  let selected=false;fleet.showParticipant=()=>{selected=true;};
  fleet.pick({clientX:640,clientY:300,target:{closest(){return null;}}},camera);
  assert.deepEqual(candidates,[]);assert.equal(selected,false);
  fleet.dispose();
});
