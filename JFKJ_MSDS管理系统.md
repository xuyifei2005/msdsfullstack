---
type: project
status: active
area: "[[ABS 安备思业务]]"
path: "D:/XUYIFEI/XUPROJECTS/AbsLabSys"
tags: [ #type/project, #status/active ]
created: 2026-06-02
---

# 🛡️ JFKJ_MSDS 管理系统

> [!abstract] 项目目标
> 为实验室提供危化品安全说明书 (MSDS) 的快速查询、管理与合规性审计功能。

---

## 🎯 Context (背景与目标)
*   **愿景**: 实现实验室危化品管理的自动化与数字化。
*   **核心功能**: SDS 速查、库存管理、安全预警。

---

## 🛰️ 分端战报 (Platform Progress)
```dataview
TABLE WITHOUT ID
    platform as "端/平台",
    choice(length(file.tasks) > 0, 
        "<progress value='" + length(filter(file.tasks, (t) => t.completed)) + "' max='" + length(file.tasks) + "'></progress> " + 
        round(length(filter(file.tasks, (t) => t.completed)) / length(file.tasks) * 100) + "%", 
        "⏳ 待初始化") as "开发进度",
    link(file.link, "点击进入控制页") as "操作"
FROM "20_项目"
WHERE parent = [[JFKJ_MSDS管理系统]]
```

---

## 📈 Progress
- **2026-06-02**: 创建 OrbitOS 数字孪生项目笔记，开始同步进度。
