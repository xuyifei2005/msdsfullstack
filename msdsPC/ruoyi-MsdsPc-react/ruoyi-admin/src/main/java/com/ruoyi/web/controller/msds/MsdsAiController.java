package com.ruoyi.web.controller.msds;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.system.domain.vo.MsdsParseVo;
import com.ruoyi.system.service.IMsdsParserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

/**
 * MSDS AI 智能解析接口
 */
@Tag(name = "MSDS智能解析", description = "AI 解析相关接口")
@RestController
@RequestMapping("/msds/ai")
public class MsdsAiController extends BaseController {

    private static final Logger log = LoggerFactory.getLogger(MsdsAiController.class);

    @Autowired
    private IMsdsParserService msdsParserService;

    /**
     * 智能解析 MSDS 文件
     */
    @Operation(summary = "解析上传的 MSDS PDF 文件")
    @PreAuthorize("@ss.hasPermi('system:msds:import')")
    @PostMapping("/parse")
    public AjaxResult parse(@RequestParam("file") MultipartFile file) {
        if (file == null || file.isEmpty()) {
            return AjaxResult.error("上传文件不能为空");
        }
        try {
            MsdsParseVo result = msdsParserService.parseMsdsFile(file);
            return AjaxResult.success(result);
        } catch (Exception e) {
            log.error("MSDS AI 解析失败", e);
            return AjaxResult.error("解析失败: " + e.getMessage());
        }
    }
}
