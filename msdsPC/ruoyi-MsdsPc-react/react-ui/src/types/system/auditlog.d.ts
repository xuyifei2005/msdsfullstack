declare namespace API {
  namespace System {
    /** MSDS 操作审计日志 */
    type MsdsAuditLog = {
      logId?: number;
      msdsId?: number;
      operationType?: string;
      operationDesc?: string;
      operator?: string;
      operatorId?: number;
      operationTime?: string;
      ipAddress?: string;
      userAgent?: string;
      beforeData?: string;
      afterData?: string;
      operationResult?: string;
      errorMessage?: string;
      remark?: string;
    };

    /** 列表查询参数 */
    type MsdsAuditLogListParams = {
      pageNum?: number;
      pageSize?: number;
      msdsId?: number;
      operationType?: string;
      operator?: string;
      beginTime?: string;
      endTime?: string;
      ipAddress?: string;
      operationResult?: string;
    };

    /** 分页返回结果 */
    type MsdsAuditLogPageResult = {
      code: number;
      msg: string;
      total: number;
      rows: MsdsAuditLog[];
    };

    /** 详情返回结果 */
    type MsdsAuditLogInfoResult = {
      code: number;
      msg: string;
      data: MsdsAuditLog;
    };
  }
}