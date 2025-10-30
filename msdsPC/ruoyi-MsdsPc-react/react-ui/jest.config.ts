import { configUmiAlias, createConfig } from '@umijs/max/test';

export default async () => {
  const config = await configUmiAlias({
    ...createConfig({
      target: 'browser',
    }),
  });

  console.log();
  return {
    ...config,
    testEnvironmentOptions: {
      ...(config?.testEnvironmentOptions || {}),
      // 容器外部运行测试：使用 http://localhost:8080  容器内部运行测试：使用 http://msdsbackend:8080（Compose 服务名）
      url: 'http://msdsbackend:8080',
    },
    // 注意：jest-dom 需要在 expect 可用后加载，因此应当放在 setupFilesAfterEnv
    setupFilesAfterEnv: [...(config.setupFilesAfterEnv || []), './tests/setupTests.jsx'],
    globals: {
      ...config.globals,
      localStorage: null,
    },
    moduleNameMapper: {
      ...(config as any).moduleNameMapper,
      // 避免 Jest 在 jsdom 环境下尝试加载 node-canvas（Windows 下常见构建失败），统一映射为轻量 mock
      '^canvas$': '<rootDir>/tests/__mocks__/canvas.ts',
    },
  };
};
