import { request } from '@umijs/max';

/**
 * 智能解析 MSDS 文件
 * @param file 上传的文件
 */
export async function parseMsds(file: File | Blob) {
  const formData = new FormData();
  formData.append('file', file);
  
  return request<API.Result<API.Msds.MsdsParseVo>>('/api/msds/ai/parse', {
    method: 'POST',
    data: formData,
    requestType: 'form',
  });
}
