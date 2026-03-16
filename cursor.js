(function() {
  // Cursor element
  const cursor = document.createElement('div');
  cursor.id = 'retro-cursor';
  cursor.style.cssText = `
    position:fixed; width:12px; height:12px;
    pointer-events:none; z-index:99999;
    transform:translate(-50%,-50%);
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

  // Sparkle container
  const sparkleContainer = document.createElement('div');
  sparkleContainer.style.cssText = 'position:fixed;inset:0;pointer-events:none;z-index:99997;overflow:hidden;';
  document.body.appendChild(sparkleContainer);

  // Sparkle shapes (pixel stars)
  const SHAPES = ['✦','✧','⋆','·','★','✸','✺','✹'];

  function getAccent() {
    return getComputedStyle(document.documentElement).getPropertyValue('--accent').trim() || '#d4af37';
  }

  function spawnSparkle(x, y) {
    const el = document.createElement('div');
    const shape = SHAPES[Math.floor(Math.random() * SHAPES.length)];
    const size  = Math.random() * 10 + 6;
    const angle = Math.random() * 360;
    const dist  = Math.random() * 24 + 8;
    const dx    = Math.cos(angle * Math.PI / 180) * dist;
    const dy    = Math.sin(angle * Math.PI / 180) * dist;
    const accent = getAccent();
    const duration = Math.random() * 300 + 350;

    el.textContent = shape;
    el.style.cssText = `
      position:absolute;
      left:${x}px; top:${y}px;
      font-size:${size}px;
      color:${accent};
      pointer-events:none;
      transform:translate(-50%,-50%);
      text-shadow:0 0 4px ${accent};
      opacity:1;
      transition:opacity ${duration}ms ease, transform ${duration}ms ease;
      font-family:monospace;
      image-rendering:pixelated;
    `;
    sparkleContainer.appendChild(el);

    requestAnimationFrame(() => {
      el.style.opacity = '0';
      el.style.transform = `translate(calc(-50% + ${dx}px), calc(-50% + ${dy}px)) scale(0.3)`;
    });
    setTimeout(() => el.remove(), duration + 50);
  }

  let frame = 0;
  document.addEventListener('mousemove', e => {
    // Move cursor
    cursor.style.left = e.clientX + 'px';
    cursor.style.top  = e.clientY + 'px';

    // Update dot color
    const accent = getAccent();
    dot.style.background = accent;
    dot.style.boxShadow = `-4px 0 0 ${accent},4px 0 0 ${accent},0 -4px 0 ${accent},0 4px 0 ${accent}`;

    // Spawn sparkles every 2nd frame
    if (frame++ % 2 !== 0) return;
    const count = Math.floor(Math.random() * 2) + 1;
    for (let i = 0; i < count; i++) {
      spawnSparkle(e.clientX, e.clientY);
    }
  });

  // Click burst — more sparkles on click
  document.addEventListener('click', e => {
    for (let i = 0; i < 8; i++) spawnSparkle(e.clientX, e.clientY);
  });

  // Theme change observer
  new MutationObserver(() => {
    const accent = getAccent();
    dot.style.background = accent;
    dot.style.boxShadow = `-4px 0 0 ${accent},4px 0 0 ${accent},0 -4px 0 ${accent},0 4px 0 ${accent}`;
  }).observe(document.documentElement, { attributes:true, attributeFilter:['data-theme'] });

})();
