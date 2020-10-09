const MAX_MULT = 130;
const CANVAS_SIZE = 250;
const BASE_MS = 700;
const RAND_MS = 180;
const FPS = 60;

const canvas = document.getElementById("hitpoints");
canvas.width = CANVAS_SIZE
canvas.height = CANVAS_SIZE
const ctx = canvas.getContext("2d");

function playSound(file) {
  const audio = document.createElement('audio')
  audio.src = file
  audio.autoplay = true
  audio.controls = false

  audio.addEventListener('complete', () => audio.remove())

  document.body.appendChild(audio)
}

function playHeadshot() {
  playSound('470586__silverillusionist__headshot-2.ogg')
}

function getTanFromDegrees(degrees) {
  return Math.tan((degrees * Math.PI) / 180);
}

class HitEffect {
  constructor(damage, isHeadshot = false) {
    this.damage = damage;
    this.isHeadshot = isHeadshot;
    this.slopeVector = this.randomSlopeVector();
    this.startMs = Date.now();
    this.endMs = this.randomEndMs();
  }

  randomSlopeVector() {
    const degrees = 15 + Math.floor(Math.random() * 60);
    const rads = (degrees * Math.PI) / 180;
    return [Math.cos(rads), Math.sin(rads)];
  }

  randomEndMs() {
    return this.startMs + BASE_MS + Math.floor(Math.random() * RAND_MS);
  }

  getCoordinates() {
    const prc = (Date.now() - this.startMs) / (this.endMs - this.startMs);
    const mult = 1 + prc * MAX_MULT;
    return this.slopeVector.map(
      (n, i) => i * CANVAS_SIZE + (1 + i * -2) * (n * mult)
    );
  }

  draw() {
    const [x, y] = this.getCoordinates();
    drawStroked(this.damage, x, y - 100, this.isHeadshot);
  }
}

function drawStroked(text, x, y, isHeadshot) {
  ctx.font = `${isHeadshot ? "48px" : "32px"} Knewave-Regular`;
  ctx.strokeStyle = "#000";
  ctx.lineWidth = isHeadshot ? 4 : 3;
  ctx.strokeText(text, x, y);
  ctx.fillStyle = isHeadshot ? "yellow" : "#fff";
  ctx.fillText(text, x, y);
}

let hits = [];

function updateCanvas() {
  // clear canvas
  ctx.clearRect(0, 0, canvas.width, canvas.height);

  // check if hits are empty
  if (hits.length < 1) return;

  // draw each hit
  for (let hit of hits) {
    hit.draw();
  }

  // update hits
  hits = hits.filter((hit) => Date.now() < hit.endMs);
}

function addHit(damage, isHeadshot) {
  if (isHeadshot) playHeadshot()
  hits.push(new HitEffect(damage, isHeadshot));
}

// sweet 60fps animations
setInterval(updateCanvas, 1000/FPS);
