import { createConfig } from '@umijs/max/test';

export default async () => {
  const config = createConfig({
    target: 'browser',
  });
  return {
    ...config,
    testEnvironmentOptions: {
      ...(config?.testEnvironmentOptions || {}),
      url: 'http://msdsbackend:8080',
    },
    setupFilesAfterEnv: [...(config.setupFilesAfterEnv || []), './tests/setupTests.jsx'],
    globals: {
      ...config.globals,
      localStorage: null,
    },
    moduleNameMapper: {
      ...(config as any).moduleNameMapper,
      '^@/(.*)$': '<rootDir>/src/$1',
      '^canvas$': '<rootDir>/tests/__mocks__/canvas.ts',
    },
  };
};
