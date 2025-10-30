// jest setup: polyfills & mocks
// 说明：该文件在每个测试文件前执行，提供 jsdom 环境缺失能力的补齐，以及常见 API 的 mock。

// 1) 引入 jest-dom 扩展，使得可以使用 toBeInTheDocument 等匹配器
import '@testing-library/jest-dom';

// 2) localStorage mock（简化实现）
if (!global.localStorage) {
  const store = new Map();
  // @ts-ignore
  global.localStorage = {
    getItem: (k) => (store.has(k) ? String(store.get(k)) : null),
    setItem: (k, v) => store.set(k, String(v)),
    removeItem: (k) => store.delete(k),
    clear: () => store.clear(),
  };
}

// 3) URL & object URL
if (typeof URL.createObjectURL === 'undefined') {
  // @ts-ignore
  URL.createObjectURL = () => 'blob://mocked';
}

// 4) Worker mock
class MockWorker {
  onmessage = null;
  onerror = null;
  postMessage() {}
  terminate() {}
  addEventListener() {}
  removeEventListener() {}
}
// @ts-ignore
window.Worker = MockWorker;

// 5) matchMedia mock（AntD 相关）
Object.defineProperty(window, 'matchMedia', {
  writable: true,
  value: (query) => ({
    matches: false,
    media: query,
    onchange: null,
    addListener: () => {},
    removeListener: () => {},
    addEventListener: () => {},
    removeEventListener: () => {},
    dispatchEvent: () => false,
  }),
});

// 6) 屏蔽非关键错误日志，保留必要调试能力
const error = console.error;
console.error = (...args) => {
  const msg = args[0] || '';
  if (
    typeof msg === 'string' &&
    (msg.includes('Warning: ReactDOM.render is no longer supported') ||
      msg.includes('ReactDOMTestUtils.act'))
  ) {
    return;
  }
  error.apply(console, args);
};
