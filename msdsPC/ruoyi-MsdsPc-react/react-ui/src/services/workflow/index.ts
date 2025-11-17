import { request } from '@umijs/max';

const BASE_URL = '/api/system/workflow';

/** 获取工作流任务列表 */
export async function listWorkflowTask(params: API.Workflow.WorkflowTaskQuery) {
  return request<API.TableListResponse<API.Workflow.WorkflowTask>>(`${BASE_URL}/list`, {
    method: 'get',
    params,
  });
}

/** 获取工作流统计信息 */
export async function getWorkflowStatistics() {
  return request<API.Workflow.WorkflowStatistics>(`${BASE_URL}/statistics`, {
    method: 'get',
  });
}

/** 获取工作流任务详情 */
export async function getWorkflowTask(taskId: number) {
  return request<API.Workflow.WorkflowTaskDetail>(`${BASE_URL}/${taskId}`, {
    method: 'get',
  });
}

/** 新增工作流任务 */
export async function addWorkflowTask(data: API.Workflow.WorkflowTask) {
  return request(`${BASE_URL}`, {
    method: 'post',
    headers: {
      'Content-Type': 'application/json;charset=UTF-8',
    },
    data,
  });
}

/** 更新工作流任务 */
export async function updateWorkflowTask(data: API.Workflow.WorkflowTask) {
  return request(`${BASE_URL}`, {
    method: 'put',
    headers: {
      'Content-Type': 'application/json;charset=UTF-8',
    },
    data,
  });
}

/** 删除工作流任务 */
export async function removeWorkflowTask(taskIds: string) {
  return request(`${BASE_URL}/${taskIds}`, {
    method: 'delete',
  });
}

/** 更新任务状态 */
export async function updateTaskStatus(params: {
  taskId: number;
  status: string;
  rejectionReason?: string;
}) {
  return request(`${BASE_URL}/status`, {
    method: 'put',
    headers: {
      'Content-Type': 'application/json;charset=UTF-8',
    },
    data: params,
  });
}

/** 分配任务 */
export async function assignTask(params: {
  taskId: number;
  assigneeId: number;
  assigneeName: string;
}) {
  return request(`${BASE_URL}/assign`, {
    method: 'put',
    headers: {
      'Content-Type': 'application/json;charset=UTF-8',
    },
    data: params,
  });
}

/** 获取任务评论列表 */
export async function getTaskComments(taskId: number) {
  return request<API.Workflow.WorkflowComment[]>(`${BASE_URL}/${taskId}/comments`, {
    method: 'get',
  });
}

/** 添加评论 */
export async function addComment(data: API.Workflow.WorkflowComment) {
  return request(`${BASE_URL}/comment`, {
    method: 'post',
    headers: {
      'Content-Type': 'application/json;charset=UTF-8',
    },
    data,
  });
}

/** 获取任务活动日志 */
export async function getTaskActivities(taskId: number) {
  return request<API.Workflow.WorkflowActivity[]>(`${BASE_URL}/${taskId}/activities`, {
    method: 'get',
  });
}

/** 获取最近活动列表 */
export async function getRecentActivities() {
  return request<API.Workflow.WorkflowActivity[]>(`${BASE_URL}/recent-activities`, {
    method: 'get',
  });
}

