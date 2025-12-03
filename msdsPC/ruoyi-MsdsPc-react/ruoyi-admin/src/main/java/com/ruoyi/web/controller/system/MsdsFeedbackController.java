package com.ruoyi.web.controller.system;

import java.util.List;
import java.util.Date;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.system.domain.MsdsFeedback;
import com.ruoyi.system.service.IMsdsFeedbackService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 意见反馈Controller
 * 
 * @author ruoyi
 * @date 2025-01-27
 */
@RestController
@RequestMapping("/system/feedback")
public class MsdsFeedbackController extends BaseController
{
    @Autowired
    private IMsdsFeedbackService msdsFeedbackService;

    /**
     * 查询意见反馈列表
     */
    @PreAuthorize("@ss.hasPermi('system:feedback:list')")
    @GetMapping("/list")
    public TableDataInfo list(MsdsFeedback msdsFeedback)
    {
        startPage();
        List<MsdsFeedback> list = msdsFeedbackService.selectMsdsFeedbackList(msdsFeedback);
        return getDataTable(list);
    }

    /**
     * 导出意见反馈列表
     */
    @PreAuthorize("@ss.hasPermi('system:feedback:export')")
    @Log(title = "意见反馈", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, MsdsFeedback msdsFeedback)
    {
        List<MsdsFeedback> list = msdsFeedbackService.selectMsdsFeedbackList(msdsFeedback);
        ExcelUtil<MsdsFeedback> util = new ExcelUtil<MsdsFeedback>(MsdsFeedback.class);
        util.exportExcel(response, list, "意见反馈数据");
    }

    /**
     * 获取意见反馈详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:feedback:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return AjaxResult.success(msdsFeedbackService.selectMsdsFeedbackById(id));
    }

    /**
     * 新增意见反馈
     */
    @PreAuthorize("@ss.hasPermi('system:feedback:add')")
    @Log(title = "意见反馈", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody MsdsFeedback msdsFeedback)
    {
        msdsFeedback.setCreateBy(getUsername());
        return toAjax(msdsFeedbackService.insertMsdsFeedback(msdsFeedback));
    }

    /**
     * 修改意见反馈 (主要是回复)
     */
    @PreAuthorize("@ss.hasPermi('system:feedback:edit')")
    @Log(title = "意见反馈", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody MsdsFeedback msdsFeedback)
    {
        msdsFeedback.setUpdateBy(getUsername());
        if (msdsFeedback.getReplyContent() != null) {
            msdsFeedback.setReplyBy(getUsername());
            msdsFeedback.setReplyTime(new Date());
            msdsFeedback.setStatus("1"); // 已处理
        }
        return toAjax(msdsFeedbackService.updateMsdsFeedback(msdsFeedback));
    }

    /**
     * 删除意见反馈
     */
    @PreAuthorize("@ss.hasPermi('system:feedback:remove')")
    @Log(title = "意见反馈", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(msdsFeedbackService.deleteMsdsFeedbackByIds(ids));
    }
}
