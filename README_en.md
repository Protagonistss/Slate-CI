<div align="center">
  <h1>Slate</h1>
  <p><strong>An AI-driven modern code editor that reshapes the intelligent programming experience.</strong></p>

  <p>
    English | <a href="./README.md">简体中文</a>
  </p>
  
  [![GitHub release](https://img.shields.io/github/v/release/Protagonistss/Slate-CI?color=blue&label=Latest%20Release)](https://github.com/Protagonistss/Slate-CI/releases)
  [![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20macOS%20%7C%20Linux-lightgrey)](#-download--installation)
</div>

## ✨ Core Features

**Slate** completely changes the traditional way of writing code. By deeply integrating Large Language Models (LLMs) with local development environments, Slate aims to be your "All-around AI Pair Programming Assistant".

### 🤖 Platform-Driven Intelligent Agents
* **Autonomous Planning & Execution**: Built-in fully automatic Agents. Simply describe your requirements in natural language (e.g., *"Help me implement a login page with form validation"*), and the Agent will complete the closed loop of analysis, planning, coding, execution, and verification.
* **Interactive State Flow**: Driven by a powerful backend state machine, the client synchronizes task planning, execution progress, and artifacts in real-time. You can intervene at critical nodes for Approvals, ensuring AI behavior is safe and meets expectations.

### 🔌 Ultimate Extensible MCP Toolchain
* **Native Model Context Protocol (MCP) Support**: Adheres to the MCP standard protocol, seamlessly connecting to local terminals, file system operations, database queries, and various third-party tools, greatly expanding the operational boundaries and context awareness of the AI assistant.

### 💻 Flagship Editor Experience
* **Powerful Monaco Core**: Integrates the same Monaco Editor engine as VS Code, providing top-tier syntax highlighting, code completion, intelligent suggestions, and a silky-smooth coding experience.
* **Modern UI/UX Design**: Carefully crafted immersive interactive interface, focusing on the code itself and reducing cognitive load.

### 🚀 Native-Level Cross-Platform Performance
* **Powered by Rust & Tauri**: The frontend is built with React + Vite, relying on Tauri's native Rust shell to bring you extremely low memory usage and lightning-fast startup speeds.
* **Full Platform Compatibility**: Perfectly supports Windows, macOS, and Linux operating systems.

---

## 📥 Download & Installation

We provide pre-compiled versions for all major platforms. Please visit the [Releases page](https://github.com/Protagonistss/Slate-CI/releases) to download the latest release:

| Operating System | Architecture | Download File |
| :--- | :--- | :--- |
| **macOS** | Apple Silicon (M1/M2/M3) | [`-aarch64.dmg`](https://github.com/Protagonistss/Slate-CI/releases/latest) |
| **macOS** | Intel | [`-x64.dmg`](https://github.com/Protagonistss/Slate-CI/releases/latest) |
| **Windows** | x64 | [`-setup.exe`](https://github.com/Protagonistss/Slate-CI/releases/latest) |
| **Linux** | x64 | [`.deb` / `.AppImage`](https://github.com/Protagonistss/Slate-CI/releases/latest) |

> 💡 **Tip**: For automatically built but unreleased preview versions, you can download the corresponding Artifacts from the latest Run in [GitHub Actions](https://github.com/Protagonistss/Slate-CI/actions).

---

## ⚙️ Runtime Configuration

The Slate client relies on the backend `agents-api` to provide comprehensive AI agent capabilities. You can specify or override the server address via local configuration files:

* **Project-level configuration (Priority)**: `<Project Root>/.slate/client/env.json`
* **Global configuration (Fallback)**: `~/.slate/client/env.json`

**Configuration Example**:
```json
{
  "agentsApiBaseUrl": "http://127.0.0.1:8000/api/v1"
}
```
*(Note: Please ensure the remote server is configured with HTTPS certificates; plain text HTTP is strictly for the `127.0.0.1` local development scenario.)*

---

## 🏗️ About This Repository (Slate-CI)

This repository serves as the public homepage, distribution channel, and community interaction center for Slate. It mainly includes:

1. **Version Distribution Center**: Installation packages for all official releases are available for download through the Releases of this repository.
2. **Automated CI/CD**: Hosts configuration files and build artifacts for cross-platform build pipelines.
3. **Community Support & Issue Tracking**: Welcome to submit feedback, report bugs, or propose valuable new features via [Issues](https://github.com/Protagonistss/Slate-CI/issues).

---

## 📄 License

This project is open-sourced under the relevant agreement. For details, please refer to the [LICENSE](./LICENSE) file.
