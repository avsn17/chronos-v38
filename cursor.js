(function() {
  const cursor = document.createElement('div');
  cursor.id = 'retro-cursor';
  cursor.style.cssText = `
    position:fixed; width:12px; height:12px;
    pointer-events:none; z-index:99999;
    transform:translate(-50%,-50%);
    will-change:left,top;
  `;
  const dot = document.createElement('div');
  dot.style.cssText = `
    width:4px; height:4px;
    background:var(--accent,#d4af37);
    position:absolute; top:50%; left:50%;
    transform:translate(-50%,-50%);
    image-rendering:pixelated;
    box-shadow:-4px 0 0 var(--accent,#d4af37),4px 0 0 var(--accent,#d4af37),
               0 -4px 0 var(--accent,#d4af37),0 4px 0 var(--accent,#d4af37);
  `;
  cursor.appendChild(dot);
  document.body.appendChild(cursor);

  const sparkleContainer = document.createElement('div');
  sparkleContainer.style.cssText = 'position:fixed;inset:0;pointer-events:none;z-index:99997;overflow:hidden;';
  document.body.appendChild(sparkleContainer);

  const SHAPES = ['✦','✧','⋆','·','★','✸'];

  function getAccent() {
    return getComputedStyle(document.documentElement).getPropertyValue('--accent').trim() || '#d4af37';
  }

  function spawnSparkle(x, y) {
    const el = document.createElement('div');
    const angle = Math.random() * 360;
    const dist  = Math.random() * 18 + 6;
    const dx    = Math.cos(angle * Math.PI / 180) * dist;
    const dy    = Math.sin(angle * Math.PI / 180) * dist;
    const accent = getAccent();
    el.textContent = SHAPES[Math.floor(Math.random() * SHAPES.length)];
    el.style.cssText = `
      position:absolute; left:${x}px; top:${y}px;
      font-size:${Math.random()*8+5}px;
      color:${accent}; pointer-events:none;
      transform:translate(-50%,-50%);
      text-shadow:0 0 4px ${accent};
      opacity:1;
      transition:opacity 200ms ease, transform 200ms ease;
      will-change:opacity,transform;
    `;
    sparkleContainer.appendChild(el);
    requestAnimationFrame(() => {
      el.style.opacity = '0';
      el.style.transform = `translate(calc(-50% + ${dx}px), calc(-50% + ${dy}px)) scale(0.2)`;
    });
    setTimeout(() => el.remove(), 220);
  }

  // Track mouse with requestAnimationFrame for zero lag
  let mx = 0, my = 0, frame = 0;

  document.addEventListener('mousemove', e => {
    mx = e.clientX; my = e.clientY;
    // Instant cursor — no RAF delay
    cursor.style.left = mx + 'px';
    cursor.style.top  = my + 'px';

    const accent = getAccent();
    dot.style.background = accent;
    dot.style.boxShadow = `-4px 0 0 ${accent},4px 0 0 ${accent},0 -4px 0 ${accent},0 4px 0 ${accent}`;

    if (frame++ % 3 !== 0) return;
    spawnSparkle(mx, my);
  });

  document.addEventListener('click', e => {
    for (let i = 0; i < 8; i++) spawnSparkle(e.clientX, e.clientY);
  });

  new MutationObserver(() => {
    const accent = getAccent();
    dot.style.background = accent;
    dot.style.boxShadow = `-4px 0 0 ${accent},4px 0 0 ${accent},0 -4px 0 ${accent},0 4px 0 ${accent}`;
  }).observe(document.documentElement, { attributes:true, attributeFilter:['data-theme'] });

})();
