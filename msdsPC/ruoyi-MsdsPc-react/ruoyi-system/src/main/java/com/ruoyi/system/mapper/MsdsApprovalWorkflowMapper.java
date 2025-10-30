package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.MsdsApprovalWorkflow;

/**
 * MSDS审批流程Mapper接口
 * 
 * @author ruoyi
 * @date 2024-01-01
 */
public interface MsdsApprovalWorkflowMapper 
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
     * @param msdsId MSDS主键
     * @return MSDS审批流程集合
     */
    public List<MsdsApprovalWorkflow> selectMsdsApprovalWorkflowByMsdsId(Long msdsId);

    /**
     * 根据MSDS ID和步骤号查询审批流程
     * 
     * @param msdsId MSDS主键
     * @param stepNo 步骤号
     * @return MSDS审批流程
     */
    public MsdsApprovalWorkflow selectMsdsApprovalWorkflowByMsdsIdAndStep(Long msdsId, Integer stepNo);

    /**
     * 查询MSDS审批流程列表
     * 
     * @param msdsApprovalWorkflow MSDS审批流程
     * @return MSDS审批流程集合
     */
    public List<MsdsApprovalWorkflow> selectMsdsApprovalWorkflowList(MsdsApprovalWorkflow msdsApprovalWorkflow);

    /**
     * 查询指定审批人的待审批任务
     * 
     * @param approver 审批人
     * @return MSDS审批流程集合
     */
    public List<MsdsApprovalWorkflow> selectPendingApprovalsByApprover(String approver);

    /**
     * 查询指定MSDS的当前审批步骤
     * 
     * @param msdsId MSDS主键
     * @return MSDS审批流程
     */
    public MsdsApprovalWorkflow selectCurrentApprovalStepByMsdsId(Long msdsId);

    /**
     * 查询指定MSDS的下一个审批步骤
     * 
     * @param msdsId MSDS主键
     * @param currentStepNo 当前步骤号
     * @return MSDS审批流程
     */
    public MsdsApprovalWorkflow selectNextApprovalStepByMsdsId(Long msdsId, Integer currentStepNo);

    /**
     * 新增MSDS审批流程
     * 
     * @param msdsApprovalWorkflow MSDS审批流程
     * @return 结果
     */
    public int insertMsdsApprovalWorkflow(MsdsApprovalWorkflow msdsApprovalWorkflow);

    /**
     * 修改MSDS审批流程
     * 
     * @param msdsApprovalWorkflow MSDS审批流程
     * @return 结果
     */
    public int updateMsdsApprovalWorkflow(MsdsApprovalWorkflow msdsApprovalWorkflow);

    /**
     * 删除MSDS审批流程
     * 
     * @param id MSDS审批流程主键
     * @return 结果
     */
    public int deleteMsdsApprovalWorkflowById(Long id);

    /**
     * 批量删除MSDS审批流程
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteMsdsApprovalWorkflowByIds(Long[] ids);

    /**
     * 根据MSDS ID删除审批流程
     * 
     * @param msdsId MSDS主键
     * @return 结果
     */
    public int deleteMsdsApprovalWorkflowByMsdsId(Long msdsId);

    /**
     * 批量新增MSDS审批流程
     * 
     * @param msdsApprovalWorkflowList MSDS审批流程集合
     * @return 结果
     */
    public int batchInsertMsdsApprovalWorkflow(List<MsdsApprovalWorkflow> msdsApprovalWorkflowList);
}