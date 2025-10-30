import React from 'react';
import { render, screen } from '@testing-library/react';

// 将 umi 的 useLocation 替换为可控的 mock，以便注入路由 state（previewList / previewSectionsMap）
let mockLocationState: any = {};
jest.mock('@umijs/max', () => ({
  useLocation: () => ({ state: mockLocationState }),
}));

// 简化 PageContainer 渲染，避免不必要的布局依赖影响单元测试稳定性
// 注意：jest.mock 会被 hoist 到文件顶部执行，避免在此使用 JSX，否则会出现 React 未定义错误
jest.mock('@ant-design/pro-components', () => {
  const React = require('react');
  return {
    PageContainer: ({ children }: any) => React.createElement('div', { 'data-testid': 'page-container' }, children),
  };
});

// 轻量 polyfill，避免 antd 对 ResizeObserver 的依赖在 jsdom 下报错
beforeEach(() => {
  // @ts-ignore
  global.ResizeObserver = class {
    observe() {}
    unobserve() {}
    disconnect() {}
  };
});

// 使用相对路径，避免 Jest 对路径别名解析的额外配置
import MsdsPreviewPage from '../src/pages/Msds/Preview';

/**
 * 用例1：未提供 previewSectionsMap 时，组件应基于 previewList 构建兜底的 16 章节视图，
 * 并在“1 基本信息”中渲染顶层基础字段（如 中文名/英文名/CAS号 等）。
 */
 test('MsdsPreviewPage 在无 previewSectionsMap 时，基于 previewList 兜底渲染章节与字段', async () => {
  mockLocationState = {
    previewList: [
      {
        fileName: 'a.txt',
        productName: '甲苯',
        productEnglishName: 'Toluene',
        casNumber: '108-88-3',
        companyName: '供应商A',
        version: 'V1.0',
        status: 'success',
      },
    ],
  };

  render(<MsdsPreviewPage />);

  // 顶部基础信息
  expect(await screen.findByText('MSDS 预览')).toBeInTheDocument();
  expect(screen.getByText('a.txt')).toBeInTheDocument();
  expect(screen.getByText('甲苯')).toBeInTheDocument();

  // 左侧或右侧内容中应出现“1 基本信息”
  expect(screen.getAllByText(/1 基本信息/)[0]).toBeInTheDocument();

  // 字段标签 + 值 + 状态文案（命中/不确定/错误）
  expect(screen.getByText('中文名')).toBeInTheDocument();
  expect(screen.getByText('Toluene')).toBeInTheDocument();
  expect(screen.getByText('108-88-3')).toBeInTheDocument();
  // 至少存在一个“命中”标签
  expect(screen.getAllByText('命中').length).toBeGreaterThan(0);
});

/**
 * 用例2：当存在 previewSectionsMap（后端已结构化章节）时，组件应优先消费该结构进行渲染。
 */
 test('MsdsPreviewPage 在有 previewSectionsMap 时优先消费后端结构化章节', async () => {
  mockLocationState = {
    previewList: [
      {
        fileName: 'b.txt',
        productName: '乙醇',
        productEnglishName: 'Ethanol',
        casNumber: '64-17-5',
        companyName: '供应商B',
        version: 'V2.0',
        status: 'warning',
      },
    ],
    previewSectionsMap: {
      'b.txt': [
        {
          id: 1,
          title: '1 基本信息',
          fields: [
            { key: 'productName', label: '中文名', value: '乙醇', status: 'success' },
            { key: 'productEnglishName', label: '英文名', value: 'Ethanol', status: 'success' },
            { key: 'casNumber', label: 'CAS号', value: '64-17-5', status: 'success' },
          ],
        },
      ],
    },
  };

  render(<MsdsPreviewPage />);

  // 断言使用后端传入的字段值
  expect(await screen.findByText('1 基本信息')).toBeInTheDocument();
  expect(screen.getByText('乙醇')).toBeInTheDocument();
  expect(screen.getByText('Ethanol')).toBeInTheDocument();
  expect(screen.getByText('64-17-5')).toBeInTheDocument();

  // 由于使用了后端 map，仍应存在状态标签
  expect(screen.getAllByText('命中').length).toBeGreaterThan(0);
});