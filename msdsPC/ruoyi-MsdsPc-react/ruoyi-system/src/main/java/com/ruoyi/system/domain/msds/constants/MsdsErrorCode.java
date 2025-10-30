package com.ruoyi.system.domain.msds.constants;

/**
 * MSDS业务错误码常量类
 * 错误码格式：MSDS + 模块代码(2位) + 错误编号(3位)
 * 
 * @author ruoyi
 * @date 2024-01-01
 */
public class MsdsErrorCode {

    // ========== MSDS主信息模块 (01) ==========
    /** MSDS记录不存在 */
    public static final String MSDS01001 = "MSDS01001";
    /** MSDS记录已存在 */
    public static final String MSDS01002 = "MSDS01002";
    /** 产品名称不能为空 */
    public static final String MSDS01003 = "MSDS01003";
    /** CAS号格式无效 */
    public static final String MSDS01004 = "MSDS01004";
    /** MSDS状态无效 */
    public static final String MSDS01005 = "MSDS01005";
    /** 删除MSDS失败，存在关联数据 */
    public static final String MSDS01006 = "MSDS01006";
    /** 更新MSDS失败 */
    public static final String MSDS01007 = "MSDS01007";
    /** 创建MSDS失败 */
    public static final String MSDS01008 = "MSDS01008";

    // ========== 文件导入模块 (02) ==========
    /** 文件上传失败 */
    public static final String MSDS02001 = "MSDS02001";
    /** 不支持的文件格式 */
    public static final String MSDS02002 = "MSDS02002";
    /** 文件大小超出限制 */
    public static final String MSDS02003 = "MSDS02003";
    /** 文件内容格式错误 */
    public static final String MSDS02004 = "MSDS02004";
    /** 文件解析失败 */
    public static final String MSDS02005 = "MSDS02005";
    /** 文件编码错误 */
    public static final String MSDS02006 = "MSDS02006";
    /** Excel模板格式错误 */
    public static final String MSDS02007 = "MSDS02007";
    /** Word文档解析失败 */
    public static final String MSDS02008 = "MSDS02008";
    /** TXT文件解析失败 */
    public static final String MSDS02009 = "MSDS02009";

    // ========== 数据验证模块 (03) ==========
    /** 数据验证失败 */
    public static final String MSDS03001 = "MSDS03001";
    /** 必填字段缺失 */
    public static final String MSDS03002 = "MSDS03002";
    /** 字段长度超出限制 */
    public static final String MSDS03003 = "MSDS03003";
    /** 字段格式不正确 */
    public static final String MSDS03004 = "MSDS03004";
    /** 枚举值无效 */
    public static final String MSDS03005 = "MSDS03005";
    /** 日期格式不正确 */
    public static final String MSDS03006 = "MSDS03006";
    /** 数字格式不正确 */
    public static final String MSDS03007 = "MSDS03007";

    // ========== 权限控制模块 (04) ==========
    /** 访问被拒绝 */
    public static final String MSDS04001 = "MSDS04001";
    /** 权限不足 */
    public static final String MSDS04002 = "MSDS04002";
    /** 用户未认证 */
    public static final String MSDS04003 = "MSDS04003";
    /** 角色权限不足 */
    public static final String MSDS04004 = "MSDS04004";

    // ========== 业务逻辑模块 (05) ==========
    /** 业务规则违反 */
    public static final String MSDS05001 = "MSDS05001";
    /** 重复条目 */
    public static final String MSDS05002 = "MSDS05002";
    /** 存在引用约束 */
    public static final String MSDS05003 = "MSDS05003";
    /** 工作流状态错误 */
    public static final String MSDS05004 = "MSDS05004";
    /** 审计日志记录失败 */
    public static final String MSDS05005 = "MSDS05005";

    // ========== 系统错误模块 (06) ==========
    /** 数据库操作失败 */
    public static final String MSDS06001 = "MSDS06001";
    /** 网络连接失败 */
    public static final String MSDS06002 = "MSDS06002";
    /** 系统繁忙 */
    public static final String MSDS06003 = "MSDS06003";
    /** 系统配置错误 */
    public static final String MSDS06004 = "MSDS06004";
    /** 缓存操作失败 */
    public static final String MSDS06005 = "MSDS06005";

    // ========== 导入进度模块 (07) ==========
    /** 导入任务不存在 */
    public static final String MSDS07001 = "MSDS07001";
    /** 导入任务正在运行 */
    public static final String MSDS07002 = "MSDS07002";
    /** 导入任务失败 */
    public static final String MSDS07003 = "MSDS07003";
    /** 导入任务已取消 */
    public static final String MSDS07004 = "MSDS07004";
    /** 导入任务超时 */
    public static final String MSDS07005 = "MSDS07005";
    /** 导入模板无效 */
    public static final String MSDS07006 = "MSDS07006";
    /** 导入数据验证失败 */
    public static final String MSDS07007 = "MSDS07007";
    /** 导入进度查询失败 */
    public static final String MSDS07008 = "MSDS07008";
    /** 用户有正在进行的导入任务 */
    public static final String MSDS07009 = "MSDS07009";
    /** 导入任务创建失败 */
    public static final String MSDS07010 = "MSDS07010";

    // ========== 模板管理模块 (08) ==========
    /** 模板不存在 */
    public static final String MSDS08001 = "MSDS08001";
    /** 模板生成失败 */
    public static final String MSDS08002 = "MSDS08002";
    /** 模板下载失败 */
    public static final String MSDS08003 = "MSDS08003";
    /** 模板缓存过期 */
    public static final String MSDS08004 = "MSDS08004";
    /** 模板范围无效 */
    public static final String MSDS08005 = "MSDS08005";
    /** 模板缓存错误 */
    public static final String MSDS08006 = "MSDS08006";

    // ========== 数据导出模块 (09) ==========
    /** 数据导出失败 */
    public static final String MSDS09001 = "MSDS09001";
    /** 不支持的导出格式 */
    public static final String MSDS09002 = "MSDS09002";
    /** 导出数据为空 */
    public static final String MSDS09003 = "MSDS09003";
    /** 导出权限不足 */
    public static final String MSDS09004 = "MSDS09004";

    // ========== 搜索查询模块 (10) ==========
    /** 搜索失败 */
    public static final String MSDS10001 = "MSDS10001";
    /** 搜索条件无效 */
    public static final String MSDS10002 = "MSDS10002";
    /** 搜索结果过多 */
    public static final String MSDS10003 = "MSDS10003";

    // ========== 通用错误 (99) ==========
    /** 未知错误 */
    public static final String MSDS99001 = "MSDS99001";
    /** 参数错误 */
    public static final String MSDS99002 = "MSDS99002";
    /** 操作失败 */
    public static final String MSDS99003 = "MSDS99003";
    /** 服务不可用 */
    public static final String MSDS99004 = "MSDS99004";

    /**
     * 私有构造函数，防止实例化
     */
    private MsdsErrorCode() {
        throw new UnsupportedOperationException("This is a utility class and cannot be instantiated");
    }
}