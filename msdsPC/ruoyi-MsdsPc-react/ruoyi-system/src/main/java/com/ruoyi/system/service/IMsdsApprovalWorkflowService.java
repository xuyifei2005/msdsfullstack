package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.MsdsApprovalWorkflow;

/**
 * MSDS审批流程Service接口
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
public interface IMsdsApprovalWorkflowService 
{
    /**
     * 查询MSDS审批流程
     * 
     * @param id MSDS审批流程主键
     * @return MSDS审批流程
     */
    public MsdsApprovalWorkflow selectMsdsApprovalWorkflowById(Long id);

    /**
     * 根据MSDS ID查询审批流程列表
     * 
     * @param msdsId MSDS主表ID
     * @return MSDS审批流程集合
     */
    public List<MsdsApprovalWorkflow> selectMsdsApprovalWorkflowByMsdsId(Long msdsId);

    /**
     * 根据MSDS ID和步骤号查询审批流程
     * 
     * @param msdsId MSDS主表ID
     * @param stepNo 步骤号
     * @return MSDS审批流程
     */
    public MsdsApprovalWorkflow selectMsdsApprovalWorkflowByMsdsIdAndStepNo(Long msdsId, Integer stepNo);

    /**
     * 查询MSDS审批流程列表
     * 
     * @param msdsApprovalWorkflow MSDS审批流程
     * @return MSDS审批流程集合
     */
    public List<MsdsApprovalWorkflow> selectMsdsApprovalWorkflowList(MsdsApprovalWorkflow msdsApprovalWorkflow);

    /**
     * 查询待审批任务列表
     * 
     * @param approver 审批人
     * @return MSDS审批流程集合
     */
    public List<MsdsApprovalWorkflow> selectPendingApprovalTasks(String approver);

    /**
     * 获取当前审批步骤
     * 
     * @param msdsId MSDS主表ID
     * @return MSDS审批流程
     */
    public MsdsApprovalWorkflow selectCurrentApprovalStep(Long msdsId);

    /**
     * 获取下一个审批步骤
     * 
     * @param msdsId MSDS主表ID
     * @return MSDS审批流程
     */
    public MsdsApprovalWorkflow selectNextApprovalStep(Long msdsId);

    /**
     * 新增MSDS审批流程
     * 
     * @param msdsApprovalWorkflow MSDS审批流程
     * @return 结果
     */
    public int insertMsdsApprovalWorkflow(MsdsApprovalWorkflow msdsApprovalWorkflow);

    /**
     * 批量新增MSDS审批流程
     * 
     * @param msdsApprovalWorkflowList MSDS审批流程列表
     * @return 结果
     */
    public int batchInsertMsdsApprovalWorkflow(List<MsdsApprovalWorkflow> msdsApprovalWorkflowList);

    /**
     * 修改MSDS审批流程
     * 
     * @param msdsApprovalWorkflow MSDS审批流程
     * @return 结果
     */
    public int updateMsdsApprovalWorkflow(MsdsApprovalWorkflow msdsApprovalWorkflow);

    /**
     * 批量删除MSDS审批流程
     * 
     * @param ids 需要删除的MSDS审批流程主键集合
     * @return 结果
     */
    public int deleteMsdsApprovalWorkflowByIds(Long[] ids);

    /**
     * 删除MSDS审批流程信息
     * 
     * @param id MSDS审批流程主键
     * @return 结果
     */
    public int deleteMsdsApprovalWorkflowById(Long id);

    /**
     * 根据MSDS ID删除审批流程
     * 
     * @param msdsId MSDS主表ID
     * @return 结果
     */
    public int deleteMsdsApprovalWorkflowByMsdsId(Long msdsId);

    /**
     * 审批通过
     * 
     * @param id 审批流程ID
     * @param approvalComments 审批意见
     * @return 结果
     */
    public int approveWorkflow(Long id, String approvalComments);

    /**
     * 审批拒绝
     * 
     * @param id 审批流程ID
     * @param approvalComments 审批意见
     * @return 结果
     */
    public int rejectWorkflow(Long id, String approvalComments);
}