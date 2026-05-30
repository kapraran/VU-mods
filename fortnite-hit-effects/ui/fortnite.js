import { easeExpOut } from "d3";
import config from "./config.js";

function playSound(file) {
  const video = document.createElement("video");
  video.src = file;
  video.autoplay = true;
  video.controls = false;
  video.addEventListener("ended", () => video.remove());

  document.body.appendChild(video);
}

function playHeadshot() {
  playSound("/470586__silverillusionist__headshot-2.webm");
}

// get a dynamic font size based on damage
function getFontSize(damage, isHeadshot) {
  damage = Math.min(config.maxDamageThreshold, Math.max(config.minDamageThreshold, damage));
  const prc =
    1 -
    (config.maxDamageThreshold - damage) / (config.maxDamageThreshold - config.minDamageThreshold);
  const fontSize = config.minFontSize + prc * (config.maxFontSize - config.minFontSize);

  const px = (window.innerHeight * fontSize * (isHeadshot ? 1.2 : 1)) / 100;

  return `${px}px`;
}

function drawStroked(ctx, damage, x, y, isHeadshot, timeLeft) {
  // calculate opacity
  const alpha = Math.min(timeLeft / config.fadeOutMs, 1.0);

  ctx.font = `${getFontSize(damage, isHeadshot)} Knewave-Regular`;

  // draw stroke
  ctx.strokeStyle = `rgba(0, 0, 0, ${alpha})`;
  ctx.lineWidth = (isHeadshot ? 5 : 3) * (config.canvasScale || 1);
  ctx.strokeText(damage, x, y);

  // draw text
  ctx.fillStyle = isHeadshot ? `rgba(240, 255, 0, ${alpha})` : `rgba(255, 255, 255, ${alpha})`;
  ctx.fillText(damage, x, y);
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
    const degrees = 10 + Math.floor(Math.random() * 70);
    const rads = (degrees * Math.PI) / 180;
    return [Math.cos(rads), Math.sin(rads)];
  }

  randomEndMs() {
    const randomMs = Math.floor(Math.random() * config.randMs) * (this.isHeadshot ? 1.4 : 1);
    return this.startMs + config.baseMs + randomMs;
  }

  getCoordinates() {
    const prc = (Date.now() - this.startMs) / (this.endMs - this.startMs);
    const mult = easeExpOut(prc) * config.maxMult * (config.canvasScale || 1);
    const startX = window.innerWidth / 2;
    const startY = window.innerHeight / 2;
    return [startX + this.slopeVector[0] * mult, startY - this.slopeVector[1] * mult];
  }

  draw(ctx) {
    const [x, y] = this.getCoordinates();

    drawStroked(ctx, this.damage, x, y, this.isHeadshot, this.endMs - Date.now());
  }
}

let hits = [];

export function updateCanvas(canvas, ctx) {
  // clear canvas
  ctx.clearRect(0, 0, canvas.width, canvas.height);

  // check if hits are empty
  if (hits.length < 1) return;

  // clear expired hits
  hits = hits.filter((hit) => Date.now() <= hit.endMs);

  // draw each hit
  hits.forEach((hit) => hit.draw(ctx));
}

function addHit(damage, isHeadshot) {
  if (damage <= 1) return;
  if (isHeadshot && config.soundEnabled) playHeadshot();
  hits.push(new HitEffect(damage, isHeadshot));
}

// expose addHit to global object
window.addHit = addHit;

function enableSound(enabled) {
  config.soundEnabled = enabled;
}

// expose enableSound to global object
window.enableSound = enableSound;
