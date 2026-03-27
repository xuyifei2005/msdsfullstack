package com.ruoyi.system.service;

import com.ruoyi.system.domain.vo.MsdsParseVo;
import org.springframework.web.multipart.MultipartFile;

/**
 * MSDS 解析服务接口
 */
public interface IMsdsParserService {
    /**
     * 解析 MSDS 文件 (支持 PDF/图片)
     * @param file 上传的文件
     * @return 解析结果
     */
    MsdsParseVo parseMsdsFile(MultipartFile file);
}
