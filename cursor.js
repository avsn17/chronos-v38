(function() {
  // Create cursor element
  const cursor = document.createElement('div');
  cursor.id = 'retro-cursor';
  cursor.style.cssText = `
    position: fixed;
    width: 12px;
    height: 12px;
    pointer-events: none;
    z-index: 99999;
    transform: translate(-50%, -50%);
  `;

  // Inner pixel dot
  const dot = document.createElement('div');
  dot.style.cssText = `
    width: 4px;
    height: 4px;
    background: var(--accent, #d4af37);
    position: absolute;
    top: 50%; left: 50%;
    transform: translate(-50%,-50%);
    image-rendering: pixelated;
    box-shadow:
      -4px 0 0 var(--accent, #d4af37),
       4px 0 0 var(--accent, #d4af37),
       0 -4px 0 var(--accent, #d4af37),
       0  4px 0 var(--accent, #d4af37);
  `;

  cursor.appendChild(dot);
  document.body.appendChild(cursor);

  // Trail container
  const trail = document.createElement('div');
  trail.style.cssText = 'position:fixed;inset:0;pointer-events:none;z-index:99998;';
  document.body.appendChild(trail);

  let frame = 0;

  document.addEventListener('mousemove', e => {
    cursor.style.left = e.clientX + 'px';
    cursor.style.top  = e.clientY + 'px';

    // Update dot color to match current theme
    const accent = getComputedStyle(document.documentElement).getPropertyValue('--accent').trim() || '#d4af37';
    dot.style.background = accent;
    dot.style.boxShadow = `
      -4px 0 0 ${accent}, 4px 0 0 ${accent},
       0 -4px 0 ${accent}, 0  4px 0 ${accent}
    `;

    // Spawn trail every 2nd move
    if (frame++ % 2 !== 0) return;
    const td = document.createElement('div');
    td.style.cssText = `
      position:absolute;
      left:${e.clientX}px; top:${e.clientY}px;
      width:3px; height:3px;
      background:${accent};
      transform:translate(-50%,-50%);
      opacity:0.6;
      transition:opacity 0.35s ease, transform 0.35s ease;
      image-rendering:pixelated;
    `;
    trail.appendChild(td);
    requestAnimationFrame(() => { td.style.opacity = '0'; td.style.transform = 'translate(-50%,-50%) scale(0)'; });
    setTimeout(() => td.remove(), 380);
  });

  // Observe theme changes
  new MutationObserver(() => {
    const accent = getComputedStyle(document.documentElement).getPropertyValue('--accent').trim() || '#d4af37';
    dot.style.background = accent;
  }).observe(document.documentElement, { attributes: true, attributeFilter: ['data-theme'] });

})();
