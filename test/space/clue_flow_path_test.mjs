import {readFile} from 'node:fs/promises';
import assert from 'node:assert/strict';
const source = await readFile(new URL('../../assets/space/clue-flow-path.js', import.meta.url), 'utf8');
const {clueFlowPoint} = await import('data:text/javascript;base64,' + Buffer.from(source).toString('base64'));
for(let lane=0;lane<5;lane++){
 const first=clueFlowPoint(0,lane), last=clueFlowPoint(1,lane);
 first.forEach((value,i)=>assert.ok(Math.abs(value-last[i])<1e-10,'closed seamless path'));
 for(let i=0;i<200;i++)assert.ok(clueFlowPoint(i/200,lane).every(Number.isFinite));
 const right=clueFlowPoint(.25,lane),left=clueFlowPoint(.75,lane);
 assert.ok(right[0]>2.4 && left[0]<-2.4,'two distinct lobes');
 assert.ok(clueFlowPoint(0,lane)[2]>clueFlowPoint(.5,lane)[2], 'crossing has separated depth');
}
console.log('Infinity flow: closed paths, finite positions, distinct lobes and depth crossing verified.');
