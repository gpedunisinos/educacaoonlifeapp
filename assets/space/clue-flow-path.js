// A closed, horizontal figure eight. The small depth offset separates the
// crossing; parallel strands stay close enough to preserve its silhouette.
export function clueFlowPoint(u, lane = 2) {
  const angle = u * Math.PI * 2;
  const strand = lane * Math.PI * 2 / 5;
  const dx = 2.55 * Math.cos(angle);
  const dy = 2.4 * Math.cos(2 * angle);
  const length = Math.hypot(dx, dy);
  const offset = Math.cos(strand) * .115;
  return [
    2.55 * Math.sin(angle) - dy / length * offset,
    2.4 * Math.sin(angle) * Math.cos(angle) + dx / length * offset,
    .36 * Math.cos(angle) + Math.sin(strand) * .115,
  ];
}
