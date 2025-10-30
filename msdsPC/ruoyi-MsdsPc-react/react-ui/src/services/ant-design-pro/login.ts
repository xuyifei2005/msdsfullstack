// @ts-ignore
/* eslint-disable */
import { request } from '@umijs/max';

/** 登录接口 POST /api/login */
export async function login(body: API.LoginParams, options?: { [key: string]: any }) {
  return request<API.LoginResult>('/api/login', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      isToken: false
    },
    data: body,
    ...(options || {}),
  });
}

/** 获取验证码 GET /api/captchaImage */
export async function getFakeCaptcha(options?: { [key: string]: any }) {
  return request('/api/captchaImage', {
    method: 'GET',
    headers: {
      isToken: false
    },
    ...(options || {}),
  });
}

/** 退出登录接口 DELETE /api/logout */
export async function outLogin(options?: { [key: string]: any }) {
  return request<Record<string, any>>('/api/logout', {
    method: 'DELETE',
    ...(options || {}),
  });
}
