<div align="center">
  <h1>Slate</h1>
  <p><strong>由 AI 驱动的现代化代码编辑器，重塑智能编程新体验。</strong></p>

  <p>
    <a href="./README_en.md">English</a> | 简体中文
  </p>
  
  [![GitHub release](https://img.shields.io/github/v/release/Protagonistss/Slate-CI?color=blue&label=最新版本)](https://github.com/Protagonistss/Slate-CI/releases)
  [![Platform](https://img.shields.io/badge/平台-Windows%20%7C%20macOS%20%7C%20Linux-lightgrey)](#-下载与安装)
</div>

## ✨ 核心特性

**Slate** 彻底改变了传统的代码编写方式。通过深度整合大语言模型（LLM）与本地开发环境，Slate 致力于成为您的「全能 AI 结对编程助手」。

### 🤖 平台驱动的智能 Agent 
* **自主规划与执行**：内置全自动 Agent，只需用自然语言描述需求（如 *"帮我实现一个带表单验证的登录页"*），Agent 即可完成分析规划、代码编写、修改执行和验证闭环。
* **交互式状态流转**：通过强大的后端状态机驱动，客户端实时同步任务规划、执行进度与产物。您可以在关键节点进行审批（Approval）介入，确保 AI 行为安全且符合预期。

### 🔌 极致扩展的 MCP 工具链
* **Model Context Protocol (MCP) 原生支持**：遵循 MCP 标准协议，可无缝对接本地终端、文件系统操作、数据库查询及各类第三方工具，极大拓展 AI 助手的操作边界和上下文感知能力。

### 💻 旗舰级编辑器体验
* **Monaco 强劲内核**：集成与 VS Code 同款的 Monaco Editor 引擎，为您提供顶级的语法高亮、代码补全、智能提示，以及丝滑的编码输入体验。
* **现代化 UI/UX 设计**：精心打造的沉浸式交互界面，聚焦代码本身，降低认知负载。

### 🚀 原生级跨平台性能
* **Rust & Tauri 赋能**：前端采用 React + Vite 构建，依托 Tauri 原生 Rust 壳层，为您带来极低的内存占用和闪电般的启动速度。
* **全平台兼容**：完美支持 Windows、macOS 以及 Linux 操作系统。

---

## 📥 下载与安装

我们为您提供了各主流平台的预编译版本。请前往 [Releases 页面](https://github.com/Protagonistss/Slate-CI/releases) 下载最新发行版：

| 操作系统 | 架构支持 | 下载文件 |
| :--- | :--- | :--- |
| **macOS** | Apple Silicon (M1/M2/M3) | [`Slate-<version>-aarch64.dmg`](https://github.com/Protagonistss/Slate-CI/releases/latest) |
| **macOS** | Intel | [`Slate-<version>-x64.dmg`](https://github.com/Protagonistss/Slate-CI/releases/latest) |
| **Windows** | x64 | [`Slate-<version>-setup.exe`](https://github.com/Protagonistss/Slate-CI/releases/latest) |
| **Linux** | x64 | [`Slate-<version>-amd64.deb`](https://github.com/Protagonistss/Slate-CI/releases/latest) <br> [`Slate-<version>-x86_64.AppImage`](https://github.com/Protagonistss/Slate-CI/releases/latest) |

> 💡 **提示**：对于自动构建但未正式发布的预览版本，您可以在 [GitHub Actions](https://github.com/Protagonistss/Slate-CI/actions) 最新的 Run 构建记录中，下载对应的 Artifacts 产物（名称格式为 `slate-editor-bundle-<platform>-<branch>`）。

---

## ⚙️ 运行时配置

Slate 客户端依靠后端的 `agents-api` 提供全面的 AI 代理能力。您可以通过本地配置文件指定或覆盖服务端地址：

* **项目级配置（优先）**：`<项目根目录>/.slate/client/env.json`
* **全局配置（兜底）**：`~/.slate/client/env.json`

**配置示例**：
```json
{
  "agentsApiBaseUrl": "http://127.0.0.1:8000/api/v1"
}
```
*(注：远程服务端请务必配置 HTTPS 证书；明文 HTTP 仅限开发时的 `127.0.0.1` 场景使用。)*

---

## 🏗️ 关于本仓库 (Slate-CI)

本仓库作为 Slate 的公开主页、发行渠道及社区互动中心，主要包含以下内容：

1. **版本分发中心**：所有正式发行版的安装包均通过本仓库的 Releases 提供下载。
2. **自动化构建 CI/CD**：存放跨平台构建流水线的配置文件与构建产物。
3. **自动更新清单**：正式 Release 会附带 `latest.json` 与 updater 更新包，供 Slate 客户端检查更新。
4. **社区支持与问题追踪**：欢迎通过 [Issues](https://github.com/Protagonistss/Slate-CI/issues) 提交使用反馈、报告 Bug 或提出新功能的宝贵建议。

### Release Secrets（自动更新）

在 GitHub Actions Secrets 中配置：

| Secret | 说明 |
| :--- | :--- |
| `TAURI_SIGNING_PRIVATE_KEY` | Tauri updater 私钥内容（`tauri signer generate` 生成） |
| `TAURI_SIGNING_PRIVATE_KEY_PASSWORD` | 私钥密码（若生成时设置了密码） |

未配置时仍可产出安装包，但 updater 包无法被客户端验签，自动更新链路不完整。

---

## 📄 License

本项目基于相关协议开源，详细信息请参阅 [LICENSE](./LICENSE) 文件。
