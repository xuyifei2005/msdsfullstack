package com.ruoyi.system.service.impl;

import java.util.Date;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.MsdsApprovalWorkflowMapper;
import com.ruoyi.system.domain.MsdsApprovalWorkflow;
import com.ruoyi.system.service.IMsdsApprovalWorkflowService;
import com.ruoyi.common.utils.SecurityUtils;

/**
 * MSDS审批流程Service业务层处理
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
@Service
public class MsdsApprovalWorkflowServiceImpl implements IMsdsApprovalWorkflowService 
{
    @Autowired
    private MsdsApprovalWorkflowMapper msdsApprovalWorkflowMapper;

    /**
     * 查询MSDS审批流程
     * 
     * @param id MSDS审批流程主键
     * @return MSDS审批流程
     */
    @Override
    public MsdsApprovalWorkflow selectMsdsApprovalWorkflowById(Long id)
    {
        return msdsApprovalWorkflowMapper.selectMsdsApprovalWorkflowById(id);
    }

    /**
     * 根据MSDS ID查询审批流程列表
     * 
     * @param msdsId MSDS主表ID
     * @return MSDS审批流程集合
     */
    @Override
    public List<MsdsApprovalWorkflow> selectMsdsApprovalWorkflowByMsdsId(Long msdsId)
    {
        return msdsApprovalWorkflowMapper.selectMsdsApprovalWorkflowByMsdsId(msdsId);
    }

    /**
     * 根据MSDS ID和步骤号查询审批流程
     * 
     * @param msdsId MSDS主表ID
     * @param stepNo 步骤号
     * @return MSDS审批流程
     */
    @Override
    public MsdsApprovalWorkflow selectMsdsApprovalWorkflowByMsdsIdAndStepNo(Long msdsId, Integer stepNo)
    {
        return msdsApprovalWorkflowMapper.selectMsdsApprovalWorkflowByMsdsIdAndStep(msdsId, stepNo);
    }

    /**
     * 查询MSDS审批流程列表
     * 
     * @param msdsApprovalWorkflow MSDS审批流程
     * @return MSDS审批流程集合
     */
    @Override
    public List<MsdsApprovalWorkflow> selectMsdsApprovalWorkflowList(MsdsApprovalWorkflow msdsApprovalWorkflow)
    {
        return msdsApprovalWorkflowMapper.selectMsdsApprovalWorkflowList(msdsApprovalWorkflow);
    }

    /**
     * 查询待审批任务列表
     * 
     * @param approver 审批人
     * @return MSDS审批流程集合
     */
    @Override
    public List<MsdsApprovalWorkflow> selectPendingApprovalTasks(String approver)
    {
        return msdsApprovalWorkflowMapper.selectPendingApprovalsByApprover(approver);
    }

    /**
     * 获取当前审批步骤
     * 
     * @param msdsId MSDS主表ID
     * @return MSDS审批流程
     */
    @Override
    public MsdsApprovalWorkflow selectCurrentApprovalStep(Long msdsId)
    {
        return msdsApprovalWorkflowMapper.selectCurrentApprovalStepByMsdsId(msdsId);
    }

    /**
     * 获取下一个审批步骤
     * 
     * @param msdsId MSDS主表ID
     * @return MSDS审批流程
     */
    @Override
    public MsdsApprovalWorkflow selectNextApprovalStep(Long msdsId)
    {
        // 首先获取当前步骤
        MsdsApprovalWorkflow currentStep = msdsApprovalWorkflowMapper.selectCurrentApprovalStepByMsdsId(msdsId);
        if (currentStep != null) {
            return msdsApprovalWorkflowMapper.selectNextApprovalStepByMsdsId(msdsId, currentStep.getStepNo());
        }
        return null;
    }

    /**
     * 新增MSDS审批流程
     * 
     * @param msdsApprovalWorkflow MSDS审批流程
     * @return 结果
     */
    @Override
    public int insertMsdsApprovalWorkflow(MsdsApprovalWorkflow msdsApprovalWorkflow)
    {
        return msdsApprovalWorkflowMapper.insertMsdsApprovalWorkflow(msdsApprovalWorkflow);
    }

    /**
     * 批量新增MSDS审批流程
     * 
     * @param msdsApprovalWorkflowList MSDS审批流程列表
     * @return 结果
     */
    @Override
    public int batchInsertMsdsApprovalWorkflow(List<MsdsApprovalWorkflow> msdsApprovalWorkflowList)
    {
        return msdsApprovalWorkflowMapper.batchInsertMsdsApprovalWorkflow(msdsApprovalWorkflowList);
    }

    /**
     * 修改MSDS审批流程
     * 
     * @param msdsApprovalWorkflow MSDS审批流程
     * @return 结果
     */
    @Override
    public int updateMsdsApprovalWorkflow(MsdsApprovalWorkflow msdsApprovalWorkflow)
    {
        return msdsApprovalWorkflowMapper.updateMsdsApprovalWorkflow(msdsApprovalWorkflow);
    }

    /**
     * 批量删除MSDS审批流程
     * 
     * @param ids 需要删除的MSDS审批流程主键集合
     * @return 结果
     */
    @Override
    public int deleteMsdsApprovalWorkflowByIds(Long[] ids)
    {
        return msdsApprovalWorkflowMapper.deleteMsdsApprovalWorkflowByIds(ids);
    }

    /**
     * 删除MSDS审批流程信息
     * 
     * @param id MSDS审批流程主键
     * @return 结果
     */
    @Override
    public int deleteMsdsApprovalWorkflowById(Long id)
    {
        return msdsApprovalWorkflowMapper.deleteMsdsApprovalWorkflowById(id);
    }

    /**
     * 根据MSDS ID删除审批流程
     * 
     * @param msdsId MSDS主表ID
     * @return 结果
     */
    @Override
    public int deleteMsdsApprovalWorkflowByMsdsId(Long msdsId)
    {
        return msdsApprovalWorkflowMapper.deleteMsdsApprovalWorkflowByMsdsId(msdsId);
    }

    /**
     * 审批通过
     * 
     * @param id 审批流程ID
     * @param approvalComments 审批意见
     * @return 结果
     */
    @Override
    public int approveWorkflow(Long id, String approvalComments)
    {
        MsdsApprovalWorkflow workflow = new MsdsApprovalWorkflow();
        workflow.setId(id);
        workflow.setApprovalStatus("approved");
        workflow.setApprovalDate(new Date());
        workflow.setApprovalComments(approvalComments);
        return msdsApprovalWorkflowMapper.updateMsdsApprovalWorkflow(workflow);
    }

    /**
     * 审批拒绝
     * 
     * @param id 审批流程ID
     * @param approvalComments 审批意见
     * @return 结果
     */
    @Override
    public int rejectWorkflow(Long id, String approvalComments)
    {
        MsdsApprovalWorkflow workflow = new MsdsApprovalWorkflow();
        workflow.setId(id);
        workflow.setApprovalStatus("rejected");
        workflow.setApprovalDate(new Date());
        workflow.setApprovalComments(approvalComments);
        return msdsApprovalWorkflowMapper.updateMsdsApprovalWorkflow(workflow);
    }
}