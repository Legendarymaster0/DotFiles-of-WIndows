<p align="center">
  <img src="https://raw.githubusercontent.com/Legendarymaster0/DotFiles-of-WIndows/main/Wallpaper/Hyprpaper.png" width="100%" alt="Hyprlands HUD Banner">
</p>

<h1 align="center">❄️ Hyprlands OS</h1>

<p align="center">
  <b>Windows performance. Linux braincells.</b><br>
  A custom-tailored desktop environment combining Komorebi tiling, YASB status bars, and advanced AutoHotkey v2 logic layers.
</p>

<p align="center">
  <a href="#-features">Features</a> •
  <a href="#-components">Components</a> •
  <a href="#-dependencies">Dependencies</a> •
  <a href="#-installation">Installation</a> •
  <a href="#-keybindings">Keybindings</a> •
  <a href="#-the-illusion">The Illusion</a> •
  <a href="#-socials">Socials</a>
</p>

---

## 🖼️ Gallery

<p align="center">
  <i>The custom JetBrains Mono HUD providing real-time keybinding references.</i>
</p>

---

## ✨ Features

<details>
<summary><b>🚀 Performance & Logic</b></summary>
<br>

* **Resolution-Independent Mouse Resize:** Direct Windows API hooks via `PostMessage` for frame-perfect window scaling.
* **High-Speed Auto-Clicker:** Custom `SetTimer` interrupt logic capable of **64.6 CPS** (10ms stable interval).
* **Fluid Line Selectors:** Native keyboard remapping for ultra-fast code manipulation and navigation.
* **Title-Bar Kill Zone:** Middle-click logic to instantly terminate unresponsive processes.
</details>

<details>
<summary><b>🎨 Aesthetics & UI</b></summary>
<br>

* **Hyprland HUD:** Low-latency `Gui()` canvas using JetBrains Mono for clean system overlays.
* **Dynamic Centering:** Logic-based window snapping for floating workspaces.
* **Hyprland Design Language:** Custom-built aesthetics utilizing the `00d1ff` (Cyan) and `11111b` (Night) color palettes.
</details>

---

## 🔍 Components

* **Komorebi** | *The Tiling Engine* — Manages window layouts, dynamic positioning, and tiling behaviors.
* **YASB (Yet Another Sidebar)** | *The Status Bar* — Provides a highly customizable Linux-style top bar for workspaces and system telemetry.
* **Hyprlands OS (AHK)** | *The Logic Layer* — Custom AutoHotkey v2 scripts driving the HUD, auto-clicker, and advanced shortcuts.
* **Zen Browser** | *The Web Portal* — A Firefox-based engine optimized for minimalist, keyboard-driven tiling layouts.

---

## 📦 Dependencies

| Tool | Purpose | Status | Source |
| :--- | :--- | :--- | :--- |
| **Komorebi** | Tiling Manager | ![Required](https://img.shields.io/badge/Required-ff4655?style=flat-square) | [GitHub](https://github.com/LGUG2Z/komorebi) |
| **YASB** | Status Bar | ![Interface](https://img.shields.io/badge/Interface-ffb86c?style=flat-square) | [GitHub](https://github.com/amnweb/yasb) |
| **Zen Browser** | Web Browser | ![Recommended](https://img.shields.io/badge/Recommended-8be9fd?style=flat-square) | [Website](https://www.zen-browser.app/) |
| **AutoHotkey v2**| Scripting Engine | ![Core](https://img.shields.io/badge/Core-50fa7b?style=flat-square) | [Website](https://www.autohotkey.com/v2/) |
| **Fastfetch** | System Info | ![Visual](https://img.shields.io/badge/Visual-bd93f9?style=flat-square) | [GitHub](https://github.com/fastfetch-cli/fastfetch) |

---

## 🛠️ Installation

### 1. Environment Setup
Ensure **Komorebi** and **YASB** are installed on your machine and properly added to your system's Environment Variables (`PATH`).

### 2. Deploy Configurations
Clone this repository and place the configuration files into their respective user directories:
* Move `komorebi.json` to your `%USERPROFILE%` directory (e.g., `C:\Users\YourName\`).
* Place the `fastfetch` and `yasb` folders inside your configurations directory (typically `%USERPROFILE%\.config\`).

### 3. Execution
> ⚠️ **Note:** For security and flexibility, it is recommended to run the raw script via AutoHotkey v2, though a pre-compiled binary is available in the repository.

* Navigate to the `autohotkey scripts` directory.
* Run `hyprland.ahk` directly (or compile it yourself into an executable).
* Press `Shift + \` at any time to toggle the live HUD overlay.

---

## ⌨️ Keybindings

<details>
<summary><b>🪟 Tiling & Workspaces</b></summary>
<br>

| Hotkey | Action |
| :--- | :--- |
| `Alt` + `1-8` | Switch Active Workspace |
| `Alt` + `Shift` + `1-8` | Move Active Window to Workspace |
| `Alt` + `Arrow Keys` | Shift Window Focus Directionally |
| `Alt` + `F` | Toggle Window Float & Trigger Auto-Centering |
</details>

<details>
<summary><b>📝 Fluid Editing & Utilities</b></summary>
<br>

| Hotkey | Action |
| :--- | :--- |
| `Shift` + `Left/Right` | Instantly select entire current text line |
| `Alt` + `D` | Duplicate active text line downward |
| `F9` | Toggle 10ms High-Speed Auto-Clicker |
| `Middle-Click` (Title Bar) | Instantly terminate target application process |
</details>

---

## 🐧 The Illusion (Fastfetch)

Hyprlands OS includes a custom-tuned Fastfetch configuration that replaces standard Windows telemetry visuals with a clean, Linux-inspired environment layout.

* **Custom ASCII:** A hand-crafted terminal logo built utilizing solid block characters (`█`).
* **Spoofed Environment:** Reports system environment data as **Arch Linux / Hyprland** for clean aesthetic parity.
* **OS Age Tracking:** Integrated backend PowerShell logic to track and display installation longevity dynamically.

---

## 🔗 Socials

<p align="left">
  <a href="https://linktr.ee/Hyprlands"><img src="https://img.shields.io/badge/Linktree-313131?style=for-the-badge&logo=linktree&logoColor=white" alt="Linktree"></a>
  <a href="https://www.youtube.com/@DhruvjoshiInfinityVoidoxTs-b8h"><img src="https://img.shields.io/badge/YouTube-FF0000?style=for-the-badge&logo=youtube&logoColor=white" alt="YouTube"></a>
  <a href="https://www.twitch.tv/legendary_master0"><img src="https://img.shields.io/badge/Twitch-9146FF?style=for-the-badge&logo=twitch&logoColor=white" alt="Twitch"></a>
  <a href="https://www.reddit.com/user/Apprehensive_Bell760/"><img src="https://img.shields.io/badge/Reddit-FF4500?style=for-the-badge&logo=reddit&logoColor=white" alt="Reddit"></a>
</p>

---
<p align="center">Made with ❄️ by Legendarymaster0</p>
