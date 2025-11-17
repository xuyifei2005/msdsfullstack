/* eslint-disable */
// 该文件由 OneAPI 自动生成，请勿手动修改！

declare namespace API {
  interface PageInfo {
    current?: number;
    pageSize?: number;
    total?: number;
    list?: Array<Record<string, any>>;
  }

  interface PageInfo_UserInfo_ {
    current?: number;
    pageSize?: number;
    total?: number;
    list?: Array<UserInfo>;
  }

  interface Result {
    code: number;
    msg: string;
    data?: Record<string, any>;
  }

  interface Result_PageInfo_UserInfo__ {
    code: number;
    msg: string;
    data?: PageInfo_UserInfo_;
  }
  interface UserInfoResult {
    code?: number;
    msg?: string;
    user: UserInfo;
    permissions: any;
    roles: any;
  }

  interface Result_string_ {
    success?: boolean;
    errorMessage?: string;
    data?: string;
  }

  type UserGenderEnum = 'MALE' | 'FEMALE';

  interface UserInfo {
    userId?: string;
    userName?: string;
    nickName?: string;
    avatar?: string;
    sex?: string;
    email?: string;
    gender?: UserGenderEnum;
    unreadCount: number;
    address?: string;
    phonenumber?: string;
    dept?: Dept;
    roles?: Role[];
    permissions: string[];
  }

  interface UserInfoVO {
    name?: string;
    /** nick */
    nickName?: string;
    /** email */
    email?: string;
  }

  type definitions_0 = null;

  type MenuItemMeta = {
    title: string;
    icon: string;
    noCache: boolean;
    link: string;
  };

  type RoutersMenuItem = {
    alwaysShow?: boolean;
    children?: RoutersMenuItem[];
    component?: string;
    hidden?: boolean;
    meta: MenuItemMeta;
    name: string;
    path: string;
    redirect?: string;
    [key: string]: any;
  };
  interface GetRoutersResult {
    code: number;
    msg: string;
    data: RoutersMenuItem[];
  }

  type NoticeIconList = {
    data?: NoticeIconItem[];
    /** 列表的内容总数 */
    total?: number;
    success?: boolean;
  };

  type NoticeIconItemType = 'notification' | 'message' | 'event';

  type NoticeIconItem = {
    id?: string;
    extra?: string;
    key?: string;
    read?: boolean;
    avatar?: string;
    title?: string;
    status?: string;
    datetime?: string;
    description?: string;
    type?: NoticeIconItemType;
  };

  export type MenuType = {
    menuId: number;
    menuName: string;
    parentId: string;
    orderNum: number;
    path: string;
    component: string;
    isFrame: number;
    isCache: number;
    menuType: string;
    visible: string;
    status: string;
    perms: string;
    icon: string;
    createBy: string;
    createTime: Date;
    updateBy: string;
    updateTime: Date;
    remark: string;
  };

  export type MenuListParams = {
    menuId?: string;
    menuName?: string;
    parentId?: string;
    orderNum?: string;
    path?: string;
    component?: string;
    isFrame?: string;
    isCache?: string;
    menuType?: string;
    visible?: string;
    status?: string;
    perms?: string;
    icon?: string;
    createBy?: string;
    createTime?: string;
    updateBy?: string;
    updateTime?: string;
    remark?: string;
    pageSize?: string;
    currentPage?: string;
    filter?: string;
    sorter?: string;
  };

  export type DictTypeType = {
    dictId: number;
    dictName: string;
    dictType: string;
    status: string;
    createBy: string;
    createTime: Date;
    updateBy: string;
    updateTime: Date;
    remark: string;
  };

  export type DictTypeListParams = {
    dictId?: string;
    dictName?: string;
    dictType?: string;
    status?: string;
    createBy?: string;
    createTime?: string;
    updateBy?: string;
    updateTime?: string;
    remark?: string;
    pageSize?: string;
    currentPage?: string;
    filter?: string;
    sorter?: string;
  };

  namespace Workflow {
    export interface WorkflowTask {
      taskId?: number;
      taskTitle?: string;
      taskDescription?: string;
      taskType?: string;
      status?: 'pending' | 'reviewing' | 'approved' | 'rejected';
      priority?: 'urgent' | 'normal' | 'low';
      assigneeId?: number;
      assigneeName?: string;
      creatorId?: number;
      creatorName?: string;
      msdsId?: number;
      msdsName?: string;
      dueDate?: string;
      progress?: number;
      attachmentCount?: number;
      commentCount?: number;
      reviewerIds?: string;
      reviewerNames?: string;
      rejectionReason?: string;
      createBy?: string;
      createTime?: string;
      updateBy?: string;
      updateTime?: string;
      remark?: string;
    }

    export interface WorkflowTaskQuery {
      taskTitle?: string;
      status?: string;
      priority?: string;
      assigneeId?: number;
      creatorId?: number;
      msdsId?: number;
      taskType?: string;
      pageNum?: number;
      pageSize?: number;
    }

    export interface WorkflowComment {
      commentId?: number;
      taskId?: number;
      userId?: number;
      userName?: string;
      content?: string;
      parentId?: number;
      createBy?: string;
      createTime?: string;
      updateBy?: string;
      updateTime?: string;
    }

    export interface WorkflowActivity {
      activityId?: number;
      taskId?: number;
      userId?: number;
      userName?: string;
      actionType?: string;
      actionDescription?: string;
      oldValue?: string;
      newValue?: string;
      createTime?: string;
    }

    export interface WorkflowStatistics {
      pending?: number;
      reviewing?: number;
      approved?: number;
      rejected?: number;
    }

    export interface WorkflowTaskDetail {
      task?: WorkflowTask;
      comments?: WorkflowComment[];
      activities?: WorkflowActivity[];
    }

    export interface TableListResponse<T> {
      code?: number;
      msg?: string;
      rows?: T[];
      total?: number;
      data?: T[];
    }
  }
}
