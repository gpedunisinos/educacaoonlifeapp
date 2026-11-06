import {test} from 'node:test';
import assert from 'node:assert/strict';
import {positionTutorialCard} from '../../assets/space/ship-tutorial.js';

for (const [name, viewport, target, card] of [
  ['left panel', {width:1440,height:1000}, {left:25,right:330,top:370,bottom:610}, {width:370,height:330}],
  ['destination cards', {width:1280,height:720}, {left:100,right:1180,top:570,bottom:650}, {width:370,height:340}],
  ['mobile console', {width:390,height:844}, {left:25,right:365,top:500,bottom:790}, {width:358,height:350}],
  ['landscape controls', {width:844,height:390}, {left:500,right:820,top:12,bottom:60}, {width:370,height:358}],
]) {
  test(`guide stays inside viewport and avoids ${name}`, () => {
    const p = positionTutorialCard(target, viewport, card);
    assert.ok(p.x >= 16 && p.y >= 16);
    assert.ok(p.x + card.width <= viewport.width - 16);
    assert.ok(p.y + card.height <= viewport.height - 16);
    assert.equal(p.overlap, 0);
  });
}
