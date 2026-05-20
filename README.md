<p align="center">
  <img src="https://raw.githubusercontent.com/Legendarymaster0/DotFiles-of-WIndows/main/Wallpaper/Hyprpaper.png" width="100%" alt="Hyprland HUD Banner">
</p>

<h1 align="center">❄️ Hyprland OS</h1>
<p align="center"><b>Windows performance. Linux braincells.</b></p>

<p align="center">
  A custom-tailored desktop environment combining Komorebi tiling, YASB status bars, and advanced AutoHotkey v2 logic layers to bring the ultimate Linux tiling aesthetic straight to Windows.
</p>

<p align="center">
  <a href="#-gallery">Gallery</a> •
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
  <img src="https://raw.githubusercontent.com/Legendarymaster0/DotFiles-of-WIndows/main/Wallpaper/Hyprpaper.png" width="90%" alt="HUD Screenshot Preview">
  <br>
  <i>The custom JetBrains Mono HUD providing real-time keybinding references.</i>
</p>

---

## ✨ Features

<details>
<summary><b>🚀 Performance & Logic</b></summary>
<br>

* **Resolution-Independent Mouse Resize:** Direct Windows API hooks via `PostMessage` for frame-perfect window scaling.
* **High-Speed Auto-Clicker:** Custom `SetTimer` interrupt logic capable of **64.6 CPS** (10ms stable interval).
* **Fluid Line Selectors:** Native keyboard remapping for ultra-fast code manipulation and text navigation.
* **Title-Bar Kill Zone:** Middle-click logic to instantly terminate unresponsive processes.
</details>

<details>
<summary><b>🎨 Aesthetics & UI</b></summary>
<br>

* **Hyprland HUD:** Low-latency `Gui()` canvas using JetBrains Mono for clean, modern system overlays.
* **Dynamic Centering:** Logic-based window snapping for floating workspaces.
* **Hyprland Design Language:** Custom-built aesthetics utilizing the `00d1ff` (Cyan) and `11111b` (Night/Catppuccin Mocha) color palettes.
</details>

---

## 🔍 Components & Ecosystem

* 🧩 **Komorebi** (`The Tiling Engine`) — Manages window layouts, dynamic positioning, and tiling behaviors.
* 📊 **YASB (Yet Another Sidebar)** (`The Status Bar`) — Provides a highly customizable, widget-driven top bar for workspaces and system telemetry.
* ⚡ **Hyprland OS (AHK)** (`The Logic Layer`) — Custom AutoHotkey v2 scripts driving the HUD, auto-clicker, and advanced navigation shortcuts.
* 🌐 **Zen Browser** (`The Web Portal`) — A Firefox-based browser optimized for minimalist, keyboard-driven tiling layouts.

---

## 📦 Dependencies

| Tool | Purpose | Status | Source |
| :--- | :--- | :--- | :--- |
| **Komorebi** | Tiling Manager | `Required` | [GitHub](https://github.com/LGUG2Z/komorebi) |
| **YASB** | Status Bar | `Interface` | [GitHub](https://github.com/amnweb/yasb) |
| **Zen Browser** | Web Browser | `Recommended` | [Website](https://www.zen-browser.app/) |
| **AutoHotkey v2**| Scripting Engine | `Core` | [Website](https://www.autohotkey.com/v2/) |
| **Fastfetch** | System Info | `Visual` | [GitHub](https://github.com/fastfetch-cli/fastfetch) |

---

## 🛠️ Installation & Setup

### 1. Environment Setup
Ensure **Komorebi** and **YASB** are installed on your machine and properly added to your system's Environment Variables (`PATH`).

### 2. Deploy Configurations
Clone this repository and place the configuration files into their respective user directories:

```bash
# Clone the repository
git clone [https://github.com/Legendarymaster0/DotFiles-of-WIndows.git](https://github.com/Legendarymaster0/DotFiles-of-WIndows.git)
