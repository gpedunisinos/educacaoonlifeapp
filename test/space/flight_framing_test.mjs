import {test} from 'node:test';
import assert from 'node:assert/strict';
import {approachOffset,focusOffset} from '../../assets/space/flight-framing.js';
import * as THREE from '../../assets/space/vendor/three.module.js';
test('wide cockpit framing preserves the established approach',()=>{
 const d={radius:5};
 assert.deepEqual(approachOffset(d,16/9),[-4.25,2,16]);
 assert.deepEqual(focusOffset(d,16/9),[-3.25,0,0]);
});
test('portrait targets remain inside the unobstructed windshield',()=>{
 for(const aspect of [360/800,411/914,600/960])for(const radius of [3.3,4,5]){
  const d={radius,focusOffset:[-radius*.65,0,0]};
  const camera=new THREE.PerspectiveCamera(48,aspect,.1,2000);
  camera.position.fromArray(approachOffset(d,aspect));
  camera.lookAt(new THREE.Vector3(...focusOffset(d,aspect)));
  camera.updateMatrixWorld();
  const projected=new THREE.Vector3().project(camera);
  assert.ok(Math.abs(projected.x)<.4,`center horizontally visible: ${projected.x}`);
  assert.ok(projected.y>.05 && projected.y<.7,`center above console: ${projected.y}`);
 }
});
