import React, { useEffect, useMemo, useState, useCallback } from 'react';
import { PageContainer } from '@ant-design/pro-components';
import {
  Avatar,
  Badge,
  Button,
  Card,
  Col,
  Dropdown,
  Form,
  Input,
  List,
  Modal,
  Progress,
  Row,
  Select,
  Space,
  Spin,
  Statistic,
  message,
  type MenuProps,
} from 'antd';
import {
  BellOutlined,
  CheckCircleOutlined,
  ClockCircleOutlined,
  CloseCircleOutlined,
  ExclamationCircleOutlined,
  FilterOutlined,
  MessageOutlined,
  PaperClipOutlined,
  PlusOutlined,
  SendOutlined,
  TeamOutlined,
  UserOutlined,
  MoreOutlined,
} from '@ant-design/icons';
import classNames from 'classnames';
import dayjs from 'dayjs';
import {
  addComment,
  addWorkflowTask,
  assignTask,
  getRecentActivities,
  getTaskActivities,
  getTaskComments,
  getWorkflowStatistics,
  listWorkflowTask,
  removeWorkflowTask,
  updateTaskStatus,
  updateWorkflowTask,
} from '@/services/workflow';
import styles from './index.less';

const { TextArea } = Input;
const { Option } = Select;

type WorkflowStatus = 'pending' | 'reviewing' | 'approved' | 'rejected';

type WorkflowStats = {
  pending: number;
  reviewing: number;
  approved: number;
  rejected: number;
};

type WorkflowTaskItem = API.Workflow.WorkflowTask & {
  taskId?: string | number;
  attachments?: number;
  comments?: number;
  dueLabel?: string;
  status: WorkflowStatus;
  priority?: string;
};

type TeamMember = {
  name: string;
  role: string;
  status: 'online' | 'busy' | 'offline';
};

type ActivityItem = {
  id: string | number;
  userName: string;
  action: string;
  target: string;
  time: string;
  state?: 'completed' | 'current' | 'default';
};

type ChatMessage = {
  id: number;
  author: string;
  content: string;
  time: string;
  isMine?: boolean;
};

const STATUS_META: Record<WorkflowStatus, { title: string; gradient: string; summaryBg: string; summaryColor: string; badgeColor: string; }> = {
  pending: {
    title: '待处理',
    gradient: 'linear-gradient(135deg, #1890ff, #40a9ff)',
    summaryBg: '#E6F4FF',
    summaryColor: '#1677FF',
    badgeColor: '#ffffff33',
  },
  reviewing: {
    title: '审核中',
    gradient: 'linear-gradient(135deg, #faad14, #ffd666)',
    summaryBg: '#FFF7E6',
    summaryColor: '#FA8C16',
    badgeColor: '#ffffff33',
  },
  approved: {
    title: '已通过',
    gradient: 'linear-gradient(135deg, #52c41a, #73d13d)',
    summaryBg: '#F6FFED',
    summaryColor: '#52C41A',
    badgeColor: '#ffffff33',
  },
  rejected: {
    title: '已拒绝',
    gradient: 'linear-gradient(135deg, #ff4d4f, #ff7875)',
    summaryBg: '#FFF1F0',
    summaryColor: '#F5222D',
    badgeColor: '#ffffff33',
  },
};

const defaultTeamMembers: TeamMember[] = [];
const defaultActivities: ActivityItem[] = [];

const statusMapping: Record<string, WorkflowStatus> = {
  pending: 'pending',
  reviewing: 'reviewing',
  approved: 'approved',
  rejected: 'rejected',
  待处理: 'pending',
  审核中: 'reviewing',
  已通过: 'approved',
  已拒绝: 'rejected',
};

const priorityMapping: Record<string, string> = {
  urgent: 'urgent',
  normal: 'normal',
  low: 'low',
  紧急: 'urgent',
  普通: 'normal',
  低: 'low',
};

const normalizeStatus = (status?: string): WorkflowStatus => {
  if (!status) return 'pending';
  return statusMapping[status] ?? 'pending';
};

const normalizePriority = (priority?: string): string => {
  if (!priority) return 'normal';
  return priorityMapping[priority] ?? priority.toLowerCase();
};

const capitalize = (value: string) => value.charAt(0).toUpperCase() + value.slice(1);

const cardPriorityClass = (priority?: string) => {
  const key = capitalize(normalizePriority(priority ?? 'normal'));
  return styles[`card${key}`] ?? styles.cardNormal;
};

const badgePriorityClass = (priority?: string) => {
  const key = capitalize(normalizePriority(priority ?? 'normal'));
  return styles[`badge${key}`] ?? styles.badgeNormal;
};

const computeStats = (list: WorkflowTaskItem[]): WorkflowStats => {
  return list.reduce<WorkflowStats>(
    (acc, item) => {
      const status = normalizeStatus(item.status);
      acc[status] += 1;
      return acc;
    },
    { pending: 0, reviewing: 0, approved: 0, rejected: 0 },
  );
};

const normalizeTaskList = (rows: API.Workflow.WorkflowTask[]): WorkflowTaskItem[] => {
  return rows.map((item, index) => {
    const status = normalizeStatus((item as any).status);
    const priority = normalizePriority((item as any).priority);
    const dueDate = (item as any).dueDate ?? (item as any).deadline;
    const dueLabel = dueDate ? dayjs(dueDate).format('MM-DD HH:mm') : (item as any).dueLabel;
    return {
      ...item,
      taskId: (item as any).taskId ?? item.id ?? index + 1,
      status,
      priority,
      attachments: (item as any).attachmentCount ?? (item as any).attachments ?? 0,
      comments: (item as any).commentCount ?? (item as any).comments ?? 0,
      dueLabel,
    } as WorkflowTaskItem;
  });
};

const deriveTeamMembers = (list: WorkflowTaskItem[]): TeamMember[] => {
  const uniqueNames = Array.from(new Set(list.map((item) => item.assigneeName).filter(Boolean))) as string[];
  if (!uniqueNames.length) return defaultTeamMembers;
  const statusCycle: TeamMember['status'][] = ['online', 'online', 'busy', 'offline'];
  return uniqueNames.map((name, idx) => {
    const meta = defaultTeamMembers.find((member) => member.name === name);
    return {
      name,
      role: meta?.role ?? '协作成员',
      status: statusCycle[idx % statusCycle.length],
    };
  });
};

const mapActivitiesFromApi = (rows: API.Workflow.WorkflowActivity[]): ActivityItem[] => {
  return rows.map((row, idx) => ({
    id: (row as any).activityId ?? idx,
    userName: row.userName ?? '成员',
    action: row.actionDescription ?? '执行了操作',
    target: row.newValue ?? row.oldValue ?? '',
    time: row.createTime ? dayjs(row.createTime).fromNow?.() ?? dayjs(row.createTime).format('MM-DD HH:mm') : '',
    state: idx === 0 ? 'completed' : idx === 1 ? 'current' : 'default',
  }));
};

const statusDotColor: Record<TeamMember['status'], string> = {
  online: '#34C759',
  busy: '#FAAD14',
  offline: '#D9D9D9',
};

const WorkflowPage: React.FC = () => {
  const [form] = Form.useForm();
  const [tasks, setTasks] = useState<WorkflowTaskItem[]>([]);
  const [statistics, setStatistics] = useState<WorkflowStats>({ pending: 0, reviewing: 0, approved: 0, rejected: 0 });
  const [teamMembers, setTeamMembers] = useState<TeamMember[]>([]);
  const [activityList, setActivityList] = useState<ActivityItem[]>([]);
  const [chatMessages, setChatMessages] = useState<ChatMessage[]>([]);
  const [chatInput, setChatInput] = useState('');
  const [chatSending, setChatSending] = useState(false);
  const [chatTaskId, setChatTaskId] = useState<number | null>(null);
  const [loading, setLoading] = useState(false);
  const [taskModalVisible, setTaskModalVisible] = useState(false);
  const [selectedTask, setSelectedTask] = useState<WorkflowTaskItem | null>(null);

  const loadChatMessages = useCallback(async (taskId: number) => {
    try {
      const res = await getTaskComments(taskId);
      if ((res as any)?.code === 200) {
        const comments = ((res as any).data ?? []) as API.Workflow.WorkflowComment[];
        const list: ChatMessage[] = comments
          .filter((item) => !!item.content)
          .map((item, index) => ({
            id: Number(item.commentId ?? index + 1),
            author: item.userName || '成员',
            content: item.content || '',
            time: item.createTime ? dayjs(item.createTime).format('MM-DD HH:mm') : '',
            isMine: item.userName === 'admin' || item.createBy === 'admin',
          }));
        setChatMessages(list);
      } else {
        setChatMessages([]);
      }
    } catch (error) {
      setChatMessages([]);
    }
  }, []);

  const resolveChatTaskId = useCallback((taskList: WorkflowTaskItem[]): number | null => {
    if (selectedTask?.taskId && Number.isFinite(Number(selectedTask.taskId))) {
      return Number(selectedTask.taskId);
    }
    const first = taskList.find((item) => Number.isFinite(Number(item.taskId)));
    if (first?.taskId !== undefined) {
      return Number(first.taskId);
    }
    return null;
  }, [selectedTask]);

  const loadData = useCallback(async () => {
    setLoading(true);
    try {
      const [statsRes, tasksRes, activitiesRes] = await Promise.all([
        getWorkflowStatistics().catch(() => undefined),
        listWorkflowTask({}).catch(() => undefined),
        getRecentActivities().catch(() => undefined),
      ]);

      let normalizedTasks: WorkflowTaskItem[] = [];
      if (tasksRes && (tasksRes as any).code === 200) {
        const rawList = (tasksRes as any).rows ?? (tasksRes as any).data ?? [];
        normalizedTasks = normalizeTaskList(rawList);
      }
      setTasks(normalizedTasks);

      let stats: WorkflowStats | null = null;
      if (statsRes && (statsRes as any).code === 200) {
        const rawStats = (statsRes as any).data ?? statsRes;
        stats = {
          pending: Number(rawStats.pending ?? rawStats.waiting ?? rawStats.todo ?? 0),
          reviewing: Number(rawStats.reviewing ?? rawStats.inProgress ?? rawStats.doing ?? 0),
          approved: Number(rawStats.approved ?? rawStats.done ?? rawStats.completed ?? 0),
          rejected: Number(rawStats.rejected ?? rawStats.refused ?? rawStats.fail ?? 0),
        };
      }
      if (!stats) {
        stats = computeStats(normalizedTasks);
      }
      setStatistics(stats);

      let mappedActivities: ActivityItem[] = [];
      if (activitiesRes && (activitiesRes as any).code === 200) {
        const rawActivities = (activitiesRes as any).data ?? (activitiesRes as any).rows ?? [];
        mappedActivities = mapActivitiesFromApi(rawActivities).slice(0, 8);
      }
      setActivityList(mappedActivities);

      const derivedMembers = deriveTeamMembers(normalizedTasks);
      setTeamMembers(derivedMembers);

      const nextChatTaskId = resolveChatTaskId(normalizedTasks);
      setChatTaskId(nextChatTaskId);
      if (nextChatTaskId) {
        await loadChatMessages(nextChatTaskId);
      } else {
        setChatMessages([]);
      }
    } catch (error) {
      message.error('加载数据失败');
      setTasks([]);
      setStatistics({ pending: 0, reviewing: 0, approved: 0, rejected: 0 });
      setActivityList([]);
      setTeamMembers([]);
      setChatMessages([]);
    } finally {
      setLoading(false);
    }
  }, [loadChatMessages, resolveChatTaskId]);

  useEffect(() => {
    loadData();
  }, [loadData]);

  const handleTaskClick = (task: WorkflowTaskItem) => {
    setSelectedTask(task);
    setTaskModalVisible(true);
    const nextTaskId = Number(task.taskId);
    if (Number.isFinite(nextTaskId)) {
      setChatTaskId(nextTaskId);
      loadChatMessages(nextTaskId);
    }
  };

  const handleStatusChange = async (taskId: number, newStatus: WorkflowStatus) => {
    try {
      await updateTaskStatus({ taskId, status: newStatus });
      message.success('任务状态更新成功');
      await loadData();
    } catch (error) {
      message.error('更新任务状态失败');
    }
  };

  const handleSendMessage = useCallback(async () => {
    const content = chatInput.trim();
    if (!content) {
      message.warning('请输入消息内容');
      return;
    }
    if (!chatTaskId) {
      message.warning('暂无可关联的任务，无法发送消息');
      return;
    }
    setChatSending(true);
    try {
      const res = await addComment({
        taskId: chatTaskId,
        content,
      });
      if ((res as any)?.code === 200) {
        setChatInput('');
        message.success('发送成功');
        await loadChatMessages(chatTaskId);
        await loadData();
      } else {
        message.warning((res as any)?.msg || '发送失败');
      }
    } catch (error) {
      message.error('发送失败');
    } finally {
      setChatSending(false);
    }
  }, [addComment, chatInput, chatTaskId, loadChatMessages, loadData]);

  const onlineCount = useMemo(() => teamMembers.filter((item) => item.status === 'online').length, [teamMembers]);

  const getTasksByStatus = (status: WorkflowStatus) => tasks.filter((task) => normalizeStatus(task.status) === status);

  const renderTaskMeta = (task: WorkflowTaskItem) => (
    <div className={styles.taskMeta}>
      <span><PaperClipOutlined /> {task.attachments ?? 0}个附件</span>
      <span><MessageOutlined /> {task.comments ?? 0}条评论</span>
    </div>
  );

  const handleStatusMenuClick = (task: WorkflowTaskItem, status: WorkflowStatus) => {
    const numericId = Number(task.taskId);
    if (!Number.isFinite(numericId)) {
      message.info('示例任务仅用于展示，无法直接修改状态');
      return;
    }
    handleStatusChange(numericId, status);
  };

  const renderKanbanColumn = (status: WorkflowStatus) => {
    const columnTasks = getTasksByStatus(status);
    const menuItems = (task: WorkflowTaskItem): MenuProps['items'] => {
      const candidates: WorkflowStatus[] = ['pending', 'reviewing', 'approved', 'rejected'];
      return candidates
        .filter((item) => item !== normalizeStatus(task.status))
        .map((item) => ({ key: item, label: STATUS_META[item].title }));
    };

    return (
      <div key={status} className={styles.kanbanColumn}>
        <div
          className={classNames(styles.kanbanHeader, styles[`kanbanHeader${capitalize(status)}`])}
          style={{ background: STATUS_META[status].gradient }}
        >
          <span>{STATUS_META[status].title}</span>
          <span className={styles.kanbanHeaderCount} style={{ background: STATUS_META[status].badgeColor }}>
            {columnTasks.length}
          </span>
        </div>
        <div className={styles.kanbanBody}>
          {columnTasks.length === 0 && <div className={styles.emptyState}>暂无任务</div>}
          {columnTasks.map((task) => (
            <div key={task.taskId || task.taskTitle} className={styles.taskWrapper}>
              <Card
                className={classNames(styles.taskCard, cardPriorityClass(task.priority))}
                hoverable
                onClick={() => handleTaskClick(task)}
              >
                <div className={styles.taskHeader}>
                  <div className={styles.taskTitle}>{task.taskTitle}</div>
                  <span className={classNames(styles.priorityBadge, badgePriorityClass(task.priority))}>
                    {normalizePriority(task.priority) === 'urgent'
                      ? '紧急'
                      : normalizePriority(task.priority) === 'low'
                      ? '低'
                      : '普通'}
                  </span>
                </div>
                <div className={styles.taskDescription}>{task.taskDescription}</div>
                <div className={styles.taskAssignee}>
                  <Avatar size={28} icon={<UserOutlined />}>{task.assigneeName?.charAt(0) || '用户'}</Avatar>
                  <span>{task.assigneeName || '未指派'}</span>
                  <span className={styles.taskTime}>{task.dueLabel || '进行中'}</span>
                </div>
                {task.progress !== undefined && (
                  <div className={styles.taskProgress}>
                    <Progress percent={task.progress} size="small" showInfo={false} strokeColor={STATUS_META.reviewing.summaryColor} />
                    <span className={styles.taskProgressText}>审核进度 {task.progress}%</span>
                  </div>
                )}
                {renderTaskMeta(task)}
              </Card>
              <Dropdown
                menu={{
                  items: menuItems(task),
                  onClick: ({ key }) => handleStatusMenuClick(task, key as WorkflowStatus),
                }}
                trigger={['click']}
              >
                <Button
                  type="text"
                  icon={<MoreOutlined />}
                  className={styles.taskMore}
                  onClick={(event) => event.stopPropagation()}
                />
              </Dropdown>
            </div>
          ))}
        </div>
      </div>
    );
  };

  return (
    <PageContainer className={styles.pageContainer} title={false} ghost>
      <div className={styles.workflowWrapper}>
        <div className={styles.topNav}>
          <div className={styles.topNavLeft}>
            <div className={styles.logoBox}>
              <TeamOutlined />
            </div>
            <div className={styles.topNavTitle}>
              <h1>协作工作流</h1>
              <p>MSDS Collaboration Workflow</p>
            </div>
            <div className={styles.onlineInfo}>
              <span className={styles.onlineBadge}>
                <span className={styles.onlineDot} />团队在线
              </span>
              <span className={styles.onlineCount}>{onlineCount} 人在线</span>
            </div>
          </div>
          <div className={styles.topNavActions}>
            <Button type="primary" icon={<PlusOutlined />} onClick={() => setTaskModalVisible(true)}>
              新建任务
            </Button>
            <Button icon={<FilterOutlined />}>筛选</Button>
            <Button shape="circle" icon={<BellOutlined />} className={styles.iconButton} />
          </div>
        </div>

        <div className={styles.layout}>
          <aside className={styles.sidebar}>
            <div className={styles.sidebarSection}>
              <h3 className={styles.sectionTitle}>工作流概览</h3>
              <div className={styles.overviewGrid}>
                {(['pending', 'reviewing', 'approved', 'rejected'] as WorkflowStatus[]).map((status) => (
                  <div key={status} className={classNames(styles.overviewCard, styles[`overview${status}`])}>
                    <div className={styles.overviewValue} style={{ color: STATUS_META[status].summaryColor }}>
                      {statistics[status]}
                    </div>
                    <div className={styles.overviewLabel}>{STATUS_META[status].title}</div>
                  </div>
                ))}
              </div>
            </div>

            <div className={styles.sidebarSection}>
              <h3 className={styles.sectionTitle}>团队成员</h3>
              <div className={styles.teamList}>
                {teamMembers.length === 0 && <div className={styles.emptyState}>暂无团队成员</div>}
                {teamMembers.map((member) => (
                  <div key={member.name} className={styles.teamItem}>
                    <div className={styles.teamAvatar}>{member.name.slice(0, 2)}</div>
                    <div className={styles.teamInfo}>
                      <div className={styles.teamName}>{member.name}</div>
                      <div className={styles.teamRole}>{member.role}</div>
                    </div>
                    <span
                      className={styles.statusDot}
                      style={{ background: statusDotColor[member.status] }}
                    />
                  </div>
                ))}
              </div>
            </div>

            <div className={styles.sidebarSection}>
              <h3 className={styles.sectionTitle}>最近活动</h3>
              <div className={styles.timeline}>
                {activityList.length === 0 && <div className={styles.emptyState}>暂无活动记录</div>}
                {activityList.map((activity) => (
                  <div
                    key={activity.id}
                    className={classNames(styles.timelineItem, {
                      [styles.completed]: activity.state === 'completed',
                      [styles.current]: activity.state === 'current',
                    })}
                  >
                    <div className={styles.timelineContent}>
                      <span className={styles.timelineUser}>{activity.userName}</span>
                      <span className={styles.timelineAction}>{activity.action}</span>
                      <span className={styles.timelineTarget}>{activity.target}</span>
                    </div>
                    <div className={styles.timelineTime}>{activity.time}</div>
                  </div>
                ))}
              </div>
            </div>
          </aside>

          <div className={styles.mainArea}>
            <div className={styles.statusSummary}>
              {(['pending', 'reviewing', 'approved', 'rejected'] as WorkflowStatus[]).map((status) => (
                <div key={status} className={styles.summaryCard} style={{ background: STATUS_META[status].summaryBg }}>
                  <div className={styles.summaryTitle}>{STATUS_META[status].title}</div>
                  <div className={styles.summaryValue} style={{ color: STATUS_META[status].summaryColor }}>
                    {statistics[status]}
                  </div>
                </div>
              ))}
            </div>

            <Spin spinning={loading}>
              <div className={styles.kanbanBoard}>
                {(['pending', 'reviewing', 'approved', 'rejected'] as WorkflowStatus[]).map(renderKanbanColumn)}
              </div>
            </Spin>
          </div>
        </div>

        <div className={styles.chatWidget}>
          <div className={styles.chatHeader}>团队协作</div>
          <div className={styles.chatBody}>
            {chatMessages.length === 0 && <div className={styles.emptyState}>暂无消息</div>}
            {chatMessages.map((msg) => (
              <div
                key={msg.id}
                className={classNames(styles.chatMessage, { [styles.mine]: msg.isMine })}
              >
                <div className={styles.chatBubble}>{msg.content}</div>
                <div className={styles.chatTime}>{msg.time}</div>
              </div>
            ))}
          </div>
          <div className={styles.chatFooter}>
            <Input
              value={chatInput}
              onChange={(event) => setChatInput(event.target.value)}
              onPressEnter={handleSendMessage}
              placeholder="输入消息..."
              bordered={false}
            />
            <Button type="primary" shape="circle" icon={<SendOutlined />} onClick={handleSendMessage} loading={chatSending} />
          </div>
        </div>

        <Modal
          title={selectedTask ? '任务详情' : '新建任务'}
          open={taskModalVisible}
          onCancel={() => {
            setTaskModalVisible(false);
            setSelectedTask(null);
          }}
          footer={null}
          width={720}
        >
          <Form form={form} layout="vertical" initialValues={selectedTask ?? { priority: 'normal' }}>
            <Form.Item name="taskTitle" label="任务标题" rules={[{ required: true, message: '请输入任务标题' }] }>
              <Input placeholder="请输入任务标题" />
            </Form.Item>
            <Form.Item name="taskDescription" label="任务描述">
              <TextArea rows={4} placeholder="请输入任务描述" />
            </Form.Item>
            <Form.Item name="priority" label="优先级">
              <Select>
                <Option value="urgent">紧急</Option>
                <Option value="normal">普通</Option>
                <Option value="low">低</Option>
              </Select>
            </Form.Item>
          </Form>
        </Modal>
      </div>
    </PageContainer>
  );
};

export default WorkflowPage;

