---
name: dev-team-workflow
description: 软件开发团队多 Subagent 串行工作流。当用户提到"多角色开发"、"多角色团队"、"前后端分离"、"subagent 团队"、"软件开发流程"，或者希望按阶段分工完成一个软件项目时，必须使用此 skill。即使用户只是说"帮我把这个需求跑完整个开发流程"，也要立即触发。
---

# 软件开发团队 Subagent 工作流

将一个用户需求拆分为 9 个串行步骤，由 8 种角色的 subagent 依次接力完成，从需求分析到部署上线全链路覆盖。

---

## 目录约定

项目启动前，确保以下路径存在（可由 orchestrator 预先 `mkdir -p` 创建）：

```
docs/
├── product-manager/
├── ux-ui-designer/
├── software-architect/
├── security-engineer/
├── backend-engineer/
├── frontend-engineer/
├── test-engineer/
└── devops-engineer/

src/
├── backend/
└── frontend/
```

---

## 工作流总览

| 阶段 | Step | 角色 | 关键输出 |
|------|------|------|----------|
| 需求 | 1 | 产品经理 | PRD + 任务拆解 |
| 设计 | 2 | UX/UI 设计师 | 设计规范 |
| 设计 | 3 | 软件架构师 | 架构图 + API 规范 |
| 安全前置 | 4 | 安全工程师 | 安全需求 |
| 开发 | 5 | 后端工程师 | 后端代码 + 笔记 |
| 开发 | 6 | 前端工程师 | 前端代码 |
| 安全审计 | 7 | 安全工程师 | 安全报告 |
| 测试 | 8 | 测试工程师 | 测试报告（含 bug 列表）|
| 部署 | 9 | 运维工程师 | 部署日志 |

> **循环逻辑**：Step 8 若发现 bug，写入 `docs/test-engineer/bug-list.md`，然后**回到 Step 5** 重新开发，直至测试通过再继续 Step 9。

---

## 各步骤详细说明

### Step 1 — 产品经理

**触发**：收到用户的原始需求（自然语言描述）。

**输入**
- 用户需求（自然语言）

**任务**
1. 整理功能需求、非功能需求、用户故事
2. 定义 MVP 范围与优先级
3. 将需求拆解为可执行任务

**输出**
- `docs/product-manager/PRD.md` — 产品需求文档
- `docs/product-manager/task-breakdown.md` — 任务拆解清单

---

### Step 2 — UX/UI 设计师

**输入**
- `docs/product-manager/PRD.md`
- `docs/product-manager/task-breakdown.md`

**任务**
1. 设计用户流程图（User Flow）
2. 描述页面布局、交互逻辑、组件规范
3. 定义设计系统（色彩、字体、间距）

**输出**
- `docs/ux-ui-designer/design-spec.md` — 设计规范文档
- `docs/ux-ui-designer/wireframes/user-flow.excalidraw` - 用户流程图
- `docs/ux-ui-designer/wireframes/[page-name].excalidraw` - 页面线框图
---

### Step 3 — 软件架构师

**输入**
- `docs/product-manager/PRD.md`
- `docs/ux-ui-designer/design-spec.md`

**任务**
1. 选择技术栈，绘制系统架构图
2. 定义模块划分与数据流
3. 设计 RESTful / GraphQL API 接口规范

**输出**
- `docs/software-architect/architecture.md` — 系统架构文档
- `docs/software-architect/api-spec.md` — API 接口规范

---

### Step 4 — 安全工程师（威胁建模）

**输入**
- `docs/software-architect/architecture.md`
- `docs/software-architect/api-spec.md`

**任务**
1. 执行 STRIDE 威胁建模
2. 识别高风险接口与数据敏感点
3. 输出安全加固要求（认证、鉴权、输入校验等）

**输出**
- `docs/security-engineer/security-requirements.md` — 安全需求清单

---

### Step 5 — 后端工程师

**输入**
- `docs/software-architect/api-spec.md`
- `docs/security-engineer/security-requirements.md`
- （若为 bug 修复轮次）`docs/test-engineer/bug-list.md`

**任务**
1. 实现 API 接口与业务逻辑
2. 集成数据库、缓存、消息队列等
3. 落实安全需求中的后端措施

**输出**
- `src/backend/` — 后端源代码
- `docs/backend-engineer/backend-notes.md` — 开发说明（环境、依赖、启动命令）

---

### Step 6 — 前端工程师

**输入**
- `docs/ux-ui-designer/design-spec.md`
- `docs/architect/api-spec.md`
- `src/backend/`（了解真实接口）

**任务**
1. 按设计规范实现 UI 页面与组件
2. 对接后端 API，处理状态管理
3. 保证响应式与无障碍基准

**输出**
- `src/frontend/` — 前端源代码
- `docs/frontend-engineer/frontend-notes.md` — 开发说明（环境、依赖、启动命令）

---

### Step 7 — 安全工程师（代码审计）

**输入**
- `src/backend/`
- `src/frontend/`
- `docs/security-engineer/security-requirements.md`

**任务**
1. 审计代码是否满足安全需求
2. 检测 OWASP Top 10 常见漏洞
3. 输出风险等级与修复建议

**输出**
- `docs/security-engineer/security-report.md` — 安全审计报告

---

### Step 8 — 测试工程师

**输入**
- `src/`（全量源码）
- `docs/software-architect/api-spec.md`
- `docs/security-engineer/security-report.md`

**任务**
1. 编写并执行单元测试、集成测试、E2E 测试
2. 验证 API 契约与安全报告中的修复项
3. 汇总测试结果

**输出**
- `docs/test-engineer/test-report.md` — 测试报告（通过率、覆盖率）
- 若存在 bug：`docs/test-engineer/bug-list.md` → **返回 Step 5**

> **循环退出条件**：所有 P0/P1 bug 已修复，测试报告无阻塞项。

---

### Step 9 — 运维工程师

**输入**
- `src/`
- `docs/test-engineer/test-report.md`

**任务**
1. 编写 Dockerfile / docker-compose / CI 配置
2. 配置环境变量、密钥管理、监控告警
3. 执行部署并记录结果

**输出**
- `docs/devops-engineer/deploy-log.md` — 部署日志（版本、环境、时间戳、状态）

---

## Orchestrator 调度指南

作为 orchestrator，按以下伪逻辑驱动整个流程：

```
run step1(用户需求)
run step2()
run step3()
run step4()

loop:
  run step5()
  run step6()
  run step7()
  run step8()
  if bug-list.md exists and not empty:
    continue loop   # 回到 step5
  else:
    break

run step9()
```

- 每个 step 作为独立 subagent 调用，**严格串行**，不得并行（后步骤依赖前步骤产物）。
- 每个 step 完成之后，用户必须确认之后再进入下一步骤。
- 每次调用 subagent 时，在 prompt 中明确指定其**角色**、**输入文件路径**和**输出文件路径**。
- 循环轮次建议设置上限（如 3 次），超出则暂停并向用户报告。
- 每次新增需求，输出产物以时间戳或者版本号命名，避免覆盖。
