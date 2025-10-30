import { request } from '@umijs/max';

const mimeMap = {
  xlsx: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
  zip: 'application/zip',
};

/**
 * 解析blob响应内容并下载
 * @param {*} res blob响应内容
 * @param {String} mimeType MIME类型
 */
export function resolveBlob(res: any, mimeType: string) {
  const aLink = document.createElement('a');
  const blob = new Blob([res.data], { type: mimeType });
  // 从response的headers中获取filename, 后端response.setHeader("Content-disposition", "attachment; filename=xxxx.docx") 设置的文件名;
  // 兼容处理 filename 和 filename* 两种格式
  let fileName = 'file';
  const contentDisposition = res.headers['content-disposition'];
  
  if (contentDisposition) {
    // 优先处理 filename* 格式（RFC 6266，支持编码和特殊字符）
    const filenameStar = contentDisposition.match(/filename\*=UTF-8''([^;]+)/i);
    if (filenameStar) {
      fileName = decodeURIComponent(filenameStar[1]);
    } else {
      // 处理普通 filename 格式
      const filenamePattern = /filename=([^;]+\.[^\\.;]+);*/;
      const decodedCD = decodeURI(contentDisposition);
      const result = filenamePattern.exec(decodedCD);
      if (result) {
        fileName = result[1].replace(/"/g, '');
      }
    }
  }
  
  aLink.style.display = 'none';
  aLink.href = URL.createObjectURL(blob);
  aLink.setAttribute('download', fileName); // 设置下载文件名称
  document.body.appendChild(aLink);
  aLink.click();
  URL.revokeObjectURL(aLink.href); // 清除引用
  document.body.removeChild(aLink);
}

export function downLoadZip(url: string) {
  request(url, {
    method: 'GET',
    responseType: 'blob',
    getResponse: true,
  }).then((res) => {
    resolveBlob(res, mimeMap.zip);
  });
}

export async function downLoadXlsx(url: string, params: any, fileName?: string) {
  // 统一改为获取完整响应，优先从响应头解析文件名，保持对旧用法（传入文件名）的兼容作为兜底
  return request(url, {
    ...params,
    method: 'POST',
    responseType: 'blob',
    getResponse: true,
  }).then((res) => {
    try {
      const cd = res?.headers?.['content-disposition'];
      if (cd) {
        // 后端提供了文件名，优先使用
        resolveBlob(res, mimeMap.xlsx);
        return;
      }
    } catch (e) {
      // ignore and fallback
    }

    // 兜底：未提供响应头文件名时使用入参 fileName
    const data = res?.data ?? res;
    const aLink = document.createElement('a');
    const blob = data as any;
    aLink.style.display = 'none';
    aLink.href = URL.createObjectURL(blob);
    aLink.setAttribute('download', fileName || `export_${Date.now()}.xlsx`);
    document.body.appendChild(aLink);
    aLink.click();
    URL.revokeObjectURL(aLink.href);
    document.body.removeChild(aLink);
  });
}


export function download(fileName: string) {
  window.location.href = `/api/common/download?fileName=${encodeURI(fileName)}&delete=${true}`;
}
