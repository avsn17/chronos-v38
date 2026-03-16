(function() {
  const el = document.createElement('div');
  el.style.cssText = `
    position:fixed;
    top:0; left:0;
    width:8px; height:8px;
    background:var(--accent,#d4af37);
    pointer-events:none;
    z-index:999999;
    image-rendering:pixelated;
    box-shadow:
      -4px 0 0 0 var(--accent,#d4af37),
       4px 0 0 0 var(--accent,#d4af37),
       0 -4px 0 0 var(--accent,#d4af37),
       0  4px 0 0 var(--accent,#d4af37),
       0 0 8px 2px var(--accent,#d4af37);
    will-change:transform;
  `;
  document.body.appendChild(el);

  const sparkles = document.createElement('div');
  sparkles.style.cssText = 'position:fixed;inset:0;pointer-events:none;z-index:999998;';
  document.body.appendChild(sparkles);

  const CHARS = ['✦','✧','⋆','·','★'];
  let tick = 0;

  function accent() {
    return getComputedStyle(document.documentElement)
      .getPropertyValue('--accent').trim() || '#d4af37';
  }

  function spark(x, y) {
    const s = document.createElement('span');
    const a = accent();
    const dx = (Math.random()-0.5)*28;
    const dy = (Math.random()-0.5)*28;
    s.textContent = CHARS[tick % CHARS.length];
    s.style.cssText = `
      position:absolute;
      left:${x}px; top:${y}px;
      font-size:${6+Math.random()*8}px;
      color:${a};
      text-shadow:0 0 6px ${a};
      pointer-events:none;
      transform:translate(-50%,-50%);
      transition:transform 180ms linear, opacity 180ms linear;
      will-change:transform,opacity;
    `;
    sparkles.appendChild(s);
    requestAnimationFrame(() => {
      s.style.transform = `translate(calc(-50% + ${dx}px), calc(-50% + ${dy}px)) scale(0.1)`;
      s.style.opacity = '0';
    });
    setTimeout(() => s.remove(), 200);
  }

  document.addEventListener('mousemove', e => {
    // Use transform instead of left/top — GPU accelerated, no layout
    el.style.transform = `translate(${e.clientX - 4}px, ${e.clientY - 4}px)`;
    const a = accent();
    el.style.background = a;
    el.style.boxShadow = `-4px 0 0 ${a},4px 0 0 ${a},0 -4px 0 ${a},0 4px 0 ${a},0 0 8px 2px ${a}`;
    if (++tick % 4 === 0) spark(e.clientX, e.clientY);
  }, { passive: true });

  document.addEventListener('click', e => {
    for (let i = 0; i < 7; i++) spark(e.clientX, e.clientY);
  });

  new MutationObserver(() => {
    const a = accent();
    el.style.background = a;
    el.style.boxShadow = `-4px 0 0 ${a},4px 0 0 ${a},0 -4px 0 ${a},0 4px 0 ${a},0 0 8px 2px ${a}`;
  }).observe(document.documentElement, { attributes:true, attributeFilter:['data-theme'] });

})();
