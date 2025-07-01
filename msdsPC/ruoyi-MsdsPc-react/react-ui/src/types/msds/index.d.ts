declare namespace API {
  namespace Msds {
    /** MSDS主信息类型 */
    type MsdsMain = {
      id?: number;
      productName: string;
      productAlias?: string;
      productEnglishName?: string;
      companyName: string;
      companyAddress?: string;
      zipCode?: string;
      faxNumber?: string;
      contactPhone: string;
      email?: string;
      emergencyPhone?: string;
      recommendedUsage?: string;
      restrictedUsage?: string;
      version?: string;
      isActive?: number;
      createBy?: string;
      createTime?: string;
      updateBy?: string;
      updateTime?: string;
      remark?: string;
    };

    /** MSDS列表查询参数 */
    type MsdsMainListParams = {
      pageNum?: number;
      pageSize?: number;
      productName?: string;
      companyName?: string;
      isActive?: number;
    };

    /** MSDS分页结果 */
    type MsdsMainPageResult = {
      code: number;
      msg: string;
      total: number;
      rows: MsdsMain[];
    };

    /** MSDS详情结果 */
    type MsdsMainInfoResult = {
      code: number;
      msg: string;
      data: MsdsMain;
    };

    /** MSDS状态枚举 */
    type MsdsStatus = {
      label: string;
      value: string;
    };
  }
} 