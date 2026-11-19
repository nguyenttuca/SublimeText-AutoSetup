# 🚀 Bộ Script Tự Động Cài Đặt & Cấu Hình Sublime Text 4 Toàn Diện
> Tự động cài đặt từ đầu: Sublime Text 4, Compiler GCC (C++20), Terminal VS Code-style, Diff Tool, LSP Autocomplete, Linters & Formatters.

---

## 📂 Danh sách các file script

| File | Hệ điều hành | Mô tả |
| :--- | :--- | :--- |
| **`setup-mac.sh`** | **macOS** (Apple Silicon / Intel) | Dùng Homebrew + GCC 16 + Terminus + Clangd C++20 + Pyright |
| **`setup-linux.sh`** | **Linux** (Ubuntu / Debian / Mint) | Dùng APT official Sublime HQ + GCC C++20 + Bash Terminus |
| **`setup-windows.ps1`** | **Windows** (10 / 11) | Dùng Winget + MinGW-w64 C++20 + PowerShell Terminus |

---

## ⚡ Hướng dẫn chạy 1 click

### 1. Trên macOS
Mở **Terminal** và chạy:
```bash
bash /Users/nguyenttuca/SublimeText-AutoSetup/setup-mac.sh
```
*(Hoặc `cd ~/SublimeText-AutoSetup && ./setup-mac.sh`)*

---

### 2. Trên Linux (Ubuntu / Debian / Linux Mint)
Mở **Terminal** và chạy:
```bash
chmod +x setup-linux.sh
./setup-linux.sh
```

---

### 3. Trên Windows (10 / 11)
1. Bấm phím **Start**, tìm **PowerShell**, click chuột phải chọn **Run as Administrator**.
2. Chạy lệnh:
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\setup-windows.ps1
```

---

## 🎁 Những tính năng đã được tự động thiết lập trong Sublime Text:

1. **Terminal tích hợp:** Bấm `Ctrl+T` hoặc `Ctrl+\`` để bật/tắt (hoặc bấm menu `Terminal` trên đỉnh).
2. **So sánh Code (Diff):** 
   - `Cmd+Alt+D` (Mac) / `Ctrl+Alt+D` (Win/Linux) để so sánh tab, clipboard, file.
   - `Cmd+K, Cmd+D` (Mac) / `Ctrl+K, Ctrl+D` (Win/Linux) để so sánh trực quan 2 cột song song.
3. **Competitive Programming C++20 (Nhập xuất trực tiếp từ bàn phím):**
   - Bấm `Cmd+B` (Mac) / `Ctrl+B` (Win/Linux) ➔ Terminal tự mở và focus con trỏ để nhập `cin` từ bàn phím, xuất `cout` tức thì.
   - Snippet: Gõ `cp` + Tab (ra template chuẩn), `dsu` + Tab, `mint` + Tab.
4. **Autocomplete thông minh (LSP):**
   - C++: Apple clangd / native GCC nhận diện trọn vẹn `<bits/stdc++.h>` C++20 STL.
   - Python: Pyright Language Server gợi ý hàm, type, docstring tự động.
   - Web: HTML, CSS, JavaScript, PHP autocomplete đầy đủ.
