import config from "./config.js";
import "./fortnite.css";
import { updateCanvas } from "./fortnite.js";

function resizeCanvas(canvas) {
  const newCanvasSize = Math.floor(
    Math.max(window.innerWidth / 2, window.innerHeight / 2)
  );

  config.canvasSize = newCanvasSize;

  canvas.width = newCanvasSize;
  canvas.height = newCanvasSize;
}

function main() {
  const canvas = document.createElement("canvas");
  canvas.id = "hitpoints";
  canvas.width = config.canvasSize;
  canvas.height = config.canvasSize;
  const ctx = canvas.getContext("2d");

  document.body.appendChild(canvas);

  window.addEventListener("resize", () => resizeCanvas(canvas));

  setInterval(() => updateCanvas(canvas, ctx, config), 1000 / config.fps);
}

main();
