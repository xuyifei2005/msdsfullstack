import * as AntdIcons from '@ant-design/icons'
import React from 'react'

// 将 antd 所有图标集中到一个映射，避免在业务侧发生静态命名导入
const allIcons: Record<string, any> = AntdIcons

// 兼容别名与后端返回的历史名称（示例：TrendingUpOutlined 在某些版本并不存在）
const ICON_ALIASES: Record<string, string> = {
  TrendingUpOutlined: 'RiseOutlined',
  trendingupoutlined: 'RiseOutlined',
  TrendingUp: 'RiseOutlined',
  'trending-up': 'RiseOutlined',
}

// 名称规范化：
// - 支持 "dashboard" -> "DashboardOutlined"
// - 支持 "line-chart" -> "LineChartOutlined"
// - 保持已是标准命名的名称不变
function resolveIconName(name?: string): string {
  if (!name || typeof name !== 'string') return ''

  // 先走别名表（大小写/连接符常见变体）
  const alias = ICON_ALIASES[name]
  if (alias && allIcons[alias]) return alias

  // 直接命中
  if (allIcons[name]) return name

  // 尝试将短名或连字符名转为 PascalCase + Outlined
  if (/^[a-z0-9-]+$/.test(name)) {
    const pascal = name
      .split('-')
      .filter(Boolean)
      .map((s) => s.charAt(0).toUpperCase() + s.slice(1))
      .join('')

    const withOutlined = `${pascal}Outlined`
    if (allIcons[withOutlined]) return withOutlined
    if (allIcons[pascal]) return pascal
  }

  return ''
}

export function getIcon(name: string): React.ReactNode | string {
  const resolved = resolveIconName(name)
  const icon = resolved ? allIcons[resolved] : undefined
  return icon || ''
}

export function createIcon(icon: string | any): React.ReactNode | string {
  if (icon && typeof icon === 'object') {
    return icon
  }

  const resolved = resolveIconName(icon)
  if (resolved && allIcons[resolved]) {
    return React.createElement(allIcons[resolved])
  }

  if (process.env.NODE_ENV !== 'production') {
    // 开发态给出提示，便于排查后端/配置中不兼容的图标名
    // eslint-disable-next-line no-console
    console.warn('[IconUtil] 未找到图标，已返回空节点 ->', icon)
  }
  return ''
}
