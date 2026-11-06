// Keep destinations in the visible windshield on a narrow portrait display.
// Wide cockpit framing is unchanged.
export function approachOffset(destination, aspect) {
  const scale=aspect<.85 ? Math.max(1,.95/Math.max(.25,aspect)) : 1;
  return [-destination.radius*.85,destination.radius*.4,destination.radius*3.2*scale];
}
export function focusOffset(destination, aspect) {
  const offset=[...(destination.focusOffset??[-destination.radius*.65,0,0])];
  if(aspect<.85) {
    offset[0]*=Math.min(1,aspect/1.4);
    const scale=Math.max(1,.95/Math.max(.25,aspect));
    offset[1]=-destination.radius*.4*scale;
  }
  return offset;
}
