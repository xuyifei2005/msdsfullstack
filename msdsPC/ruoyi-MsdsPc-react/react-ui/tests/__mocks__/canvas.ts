// 轻量级 canvas mock，供 Jest 在 jsdom 环境下使用，避免加载 node-canvas 的原生依赖。
// 满足常见库对 Canvas 的最小化需求。

export class CanvasRenderingContext2D {
  fillStyle: any;
  strokeStyle: any;
  font: string = '';
  measureText(text: string) {
    return { width: text.length * 10 } as any;
  }
  fillRect() {}
  strokeRect() {}
  beginPath() {}
  moveTo() {}
  lineTo() {}
  stroke() {}
  fillText() {}
  drawImage() {}
}

export class CanvasGradient {}
export class CanvasPattern {}

export class ImageData {
  constructor(public data: Uint8ClampedArray, public width: number, public height: number) {}
}

export class Image {
  onload: (() => void) | null = null;
  onerror: ((err?: any) => void) | null = null;
  src = '';
}

export default class Canvas {
  width: number = 0;
  height: number = 0;
  getContext(type: string) {
    if (type === '2d') return new CanvasRenderingContext2D();
    return null;
  }
  toDataURL() { return 'data:image/png;base64,'; }
}