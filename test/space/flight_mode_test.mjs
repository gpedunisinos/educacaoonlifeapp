import {test} from 'node:test';
import assert from 'node:assert/strict';
import {FlightModeSwitch} from '../../assets/space/flight-mode.js';

function setup() {
  const nodes = Object.fromEntries(['mode-explorer','mode-inventor','mode-status','mode-label'].map(id => [`#${id}`, {disabled:true, attributes:{}, setAttribute(k,v){this.attributes[k]=v;}}]));
  const root = {dataset:{}, classList:{toggle(){}}, setAttribute(){}, querySelector(id){return nodes[id];}};
  globalThis.document = {body:{dataset:{}}};
  const requests=[], changes=[];
  const lever = new FlightModeSwitch(root, {request:m=>requests.push(m), changed:m=>changes.push(m)});
  return {nodes,root,lever,requests,changes};
}
test('lever waits for persistence and ignores duplicate requests', () => {
  const {lever,root,requests,changes,nodes} = setup();
  lever.update({mode:'explorer'});
  lever.choose('inventor');
  lever.choose('inventor');
  assert.deepEqual(requests,['inventor']);
  assert.equal(root.dataset.mode,'explorer');
  assert.equal(nodes['#mode-inventor'].disabled,true);
  lever.update({mode:'inventor',announce:true});
  assert.equal(root.dataset.mode,'inventor');
  assert.deepEqual(changes,['inventor']);
  assert.equal(nodes['#mode-inventor'].attributes['aria-pressed'],'true');
});
test('save failure retains confirmed mode and enables retry without speech', () => {
  const {lever,root,requests,changes,nodes} = setup();
  lever.update({mode:'inventor'});
  lever.choose('explorer');
  lever.update({mode:'inventor',error:'Falha ao salvar',announce:true});
  assert.equal(root.dataset.mode,'inventor');
  assert.deepEqual(changes,[]);
  assert.equal(nodes['#mode-status'].textContent,'Falha ao salvar');
  lever.choose('explorer');
  assert.deepEqual(requests,['explorer','explorer']);
  lever.update({mode:'explorer',announce:true});
  assert.deepEqual(changes,['explorer']);
});
