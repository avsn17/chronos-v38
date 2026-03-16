// Retro pixel cursor — matches current theme accent color
(function() {
  const cursorEl    = document.getElementById('cursor-canvas');
  const trailEl     = document.getElementById('cursor-trail');
  const ctx         = cursorEl.getContext('2d');
  let mx = -100, my = -100;

  // 16x16 pixel arrow cursor bitmap (1=filled, 0=empty)
  const ARROW = [
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0],
    [1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0],
    [1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0],
    [1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0],
    [1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0],
    [1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0],
    [1,1,0,1,1,1,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
  ];

  function getAccent() {
    return getComputedStyle(document.documentElement)
      .getPropertyValue('--accent').trim() || '#d4af37';
  }

  function drawCursor() {
    ctx.clearRect(0, 0, 16, 16);
    const color = getAccent();
    // outline (black, 1px offset)
    ctx.fillStyle = 'rgba(0,0,0,0.9)';
    for (let y = 0; y < 16; y++) {
      for (let x = 0; x < 16; x++) {
        if (!ARROW[y][x]) continue;
        const neighbors = [[-1,0],[1,0],[0,-1],[0,1],[-1,-1],[1,-1],[-1,1],[1,1]];
        for (const [dy,dx] of neighbors) {
          const ny = y+dy, nx = x+dx;
          if (ny>=0&&ny<16&&nx>=0&&nx<16&&!ARROW[ny][nx]) {
            ctx.fillRect(nx, ny, 1, 1);
          }
        }
      }
    }
    // fill
    ctx.fillStyle = color;
    for (let y = 0; y < 16; y++)
      for (let x = 0; x < 16; x++)
        if (ARROW[y][x]) ctx.fillRect(x, y, 1, 1);
  }

  function moveCursor(e) {
    mx = e.clientX; my = e.clientY;
    cursorEl.parentElement.style.left = mx + 'px';
    cursorEl.parentElement.style.top  = my + 'px';
    spawnTrail(mx, my);
    drawCursor();
  }

  let trailCount = 0;
  function spawnTrail(x, y) {
    if (trailCount++ % 3 !== 0) return; // every 3rd move
    const dot = document.createElement('div');
    dot.className = 'trail-dot';
    dot.style.left = x + 'px';
    dot.style.top  = y + 'px';
    dot.style.background = getAccent();
    trailEl.appendChild(dot);
    setTimeout(() => dot.remove(), 420);
  }

  document.addEventListener('mousemove', moveCursor);

  // Redraw on theme change (accent color changes)
  const observer = new MutationObserver(drawCursor);
  observer.observe(document.documentElement, { attributes: true, attributeFilter: ['data-theme'] });

  drawCursor();
})();
