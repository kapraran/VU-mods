import config from "./config.js";
import "./fortnite.css";
import { updateCanvas } from "./fortnite.js";

function resizeCanvas(canvas) {
  config.canvasSize = Math.max(window.innerWidth, window.innerHeight);

  canvas.width = window.innerWidth;
  canvas.height = window.innerHeight;
  canvas.style.width = canvas.width + "px";
  canvas.style.height = canvas.height + "px";
  config.canvasScale = window.innerHeight / config.referenceHeight;
}

function main() {
  const canvas = document.createElement("canvas");
  canvas.id = "hitpoints";
  const ctx = canvas.getContext("2d");

  resizeCanvas(canvas);

  document.body.appendChild(canvas);

  window.addEventListener("resize", () => resizeCanvas(canvas));

  setInterval(() => updateCanvas(canvas, ctx, config), 1000 / config.fps);
}

window.addEventListener("load", main);
