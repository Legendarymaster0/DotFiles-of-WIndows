<div align="center">

# ❄️ Hyprland OS

<div align="center">
  <strong>Windows performance. Linux braincells.</strong>
</div>

<p align="center">
  A premium, custom-tailored desktop environment combining Komorebi tiling, YASB status bars, and advanced AutoHotkey v2 logic layers to bring the ultimate Linux tiling aesthetic straight to Windows.
</p>

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square)](https://opensource.org/licenses/MIT)
[![Platform: Windows](https://img.shields.io/badge/Platform-Windows-0078d7.svg?style=flat-square&logo=windows)](https://www.microsoft.com/windows)
[![Engine: AHK v2](https://img.shields.io/badge/Engine-AHK%20v2-green.svg?style=flat-square)](https://www.autohotkey.com/)

---

[🖼️ Gallery](#%EF%B8%8F-gallery) • 
[✨ Features](#-features) • 
[🔍 Components](#-components--ecosystem) • 
[📦 Dependencies](#-dependencies) • 
[🛠️ Installation](#%EF%B8%8F-installation--setup)

</div>

---

## 🖼️ Gallery

<div align="center">
  <img src="https://github.com/Legendarymaster0/DotFiles-of-WIndows/blob/base/Config/Wallpaper/Hyprpaper.png" width="100%" style="border-radius: 8px; border: 1px solid #313244; box-shadow: 0 4px 20px rgba(0,0,0,0.3);">
</div>

---

## ✨ Features

### 🚀 Performance & Logic
* **Resolution-Independent Mouse Resize:** Direct Windows API hooks via `PostMessage` for frame-perfect window scaling.
* **High-Speed Auto-Clicker:** Custom `SetTimer` interrupt logic capable of **64.6 CPS** (10ms stable interval).
* **Fluid Line Selectors:** Native keyboard remapping for ultra-fast code manipulation and text navigation.
* **Title-Bar Kill Zone:** Middle-click logic to instantly terminate unresponsive processes.

### 🎨 Aesthetics & UI
* **Hyprland HUD:** Low-latency `Gui()` canvas using JetBrains Mono for clean, modern system overlays.
* **Dynamic Centering:** Logic-based window snapping for floating workspaces.
* **Hyprland Design Language:** Custom-built aesthetics utilizing the `00d1ff` (Cyan) and `11111b` (Night/Catppuccin Mocha) color palettes.

---

## 🔍 Components & Ecosystem

| Component | Role | Description |
| :--- | :--- | :--- |
| 🧩 **Komorebi** | `The Tiling WM` | Manages window layouts, dynamic positioning, and tiling behaviors. |
| 📊 **YASB** | `The Status Bar` | Provides a highly customizable, widget-driven top bar for workspaces and system telemetry. |
| ⚡ **Hyprland OS** | `The Logic Layer` | Custom AutoHotkey v2 scripts driving the HUD, auto-clicker, and advanced shortcuts. |
| 🌐 **Zen Browser** | `The Web Portal` | A Firefox-based browser optimized for minimalist, keyboard-driven tiling layouts. |

---

## 📦 Dependencies

> [!IMPORTANT]
> Make sure all core dependencies are added to your system's Environment Variables (`PATH`) for seamless execution.

| Tool | Purpose | Status | Source |
| :--- | :--- | :--- | :--- |
| **Komorebi** | Tiling Manager| `Required` | [GitHub](https://github.com/LGUG2Z/komorebi) |
| **YASB** | Status Bar | `Interface` | [GitHub](https://github.com/amnweb/yasb) |
| **Zen Browser** | Web Browser | `Recommended` | [Website](https://www.zen-browser.app/) |
| **AutoHotkey v2** | Scripting Engine | `Core` | [Website](https://www.autohotkey.com/v2/) |
| **Fastfetch** | System Info | `Visual` | [GitHub](https://github.com/fastfetch-cli/fastfetch) |

---

## 🛠️ Installation & Setup

### 1️⃣ Environment Setup
Ensure **Komorebi** and **YASB** are installed on your machine and properly registered in your system environment variables (`PATH`).

### 2️⃣ Deploy Configurations
Clone this repository and place the configuration files into your respective user directories:

```bash
# Clone the repository
git clone [https://github.com/Legendarymaster0/DotFiles-of-WIndows.git](https://github.com/Legendarymaster0/DotFiles-of-WIndows.git)

# Navigate to the setup directory
cd DotFiles-of-WIndows
