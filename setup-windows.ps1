# ==============================================================================
# 🚀 TỰ ĐỘNG CÀI ĐẶT & CẤU HÌNH TOÀN DIỆN SUBLIME TEXT 4 TRÊN WINDOWS
# Chạy với quyền Administrator trong Windows PowerShell (PowerShell 5.1 hoặc 7+)
# Hỗ trợ: Web Dev (PHP/JS/HTML/CSS), Competitive Programming (C++20), Pentest (Python)
# ==============================================================================

#Requires -RunAsAdministrator
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$ErrorActionPreference = "SilentlyContinue"

Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "   BẮT ĐẦU CÀI ĐẶT SUBLIME TEXT 4 TOÀN DIỆN (WINDOWS)   " -ForegroundColor Green
Write-Host "========================================================" -ForegroundColor Cyan

# 1. Cài đặt các công cụ lập trình qua Winget
Write-Host ">> Đang kiểm tra và cài đặt công cụ qua Winget..." -ForegroundColor Yellow

$tools = @(
    "SublimeHQ.SublimeText.4",
    "BrechtSanders.winlibs-llvm-ucrt", # GCC MinGW-w64 C++20 + stdc++.h
    "Python.Python.3.12",
    "OpenJS.NodeJS.LTS",
    "Git.Git"
)

foreach ($tool in $tools) {
    Write-Host ">> Đang cài $tool..." -ForegroundColor Gray
    winget install --id $tool -e --accept-source-agreements --accept-package-agreements --silent 2>$null
}

# Cập nhật PATH trong phiên làm việc hiện tại
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Cài đặt Pyright & ESLint qua NPM
Write-Host ">> Đang cài đặt Language Server (Pyright, ESLint)..." -ForegroundColor Yellow
npm install -g pyright eslint prettier 2>$null
pip install flake8 black 2>$null

# 2. Xác định thư mục dữ liệu Sublime Text
$ST_DIR = "$env:APPDATA\Sublime Text"
$USER_DIR = "$ST_DIR\Packages\User"
$INSTALLED_PKGS_DIR = "$ST_DIR\Installed Packages"
$LIB314_DIR = "$ST_DIR\Lib\python314"
$PACKAGES_DIR = "$ST_DIR\Packages"

New-Item -ItemType Directory -Force -Path $USER_DIR | Out-Null
New-Item -ItemType Directory -Force -Path $INSTALLED_PKGS_DIR | Out-Null
New-Item -ItemType Directory -Force -Path $LIB314_DIR | Out-Null
New-Item -ItemType Directory -Force -Path $PACKAGES_DIR | Out-Null

# 3. Tải Package Control
Write-Host ">> Đang nạp Package Control..." -ForegroundColor Yellow
$pcUrl = "https://packagecontrol.io/Package%20Control.sublime-package"
Invoke-WebRequest -Uri $pcUrl -OutFile "$INSTALLED_PKGS_DIR\Package Control.sublime-package"

# 4. Danh sách 32+ Packages tự động tải
$pcSettings = @'
{
	"bootstrapped": true,
	"in_process_packages": [],
	"installed_packages":
	[
		"A File Icon",
		"Alignment",
		"ApplySyntax",
		"AutoFileName",
		"BracketHighlighter",
		"ColorHelper",
		"Diffy",
		"Emmet",
		"FileDiffs",
		"GitGutter",
		"Hex Viewer",
		"HTMLBeautify",
		"LSP",
		"LSP-clangd",
		"LSP-css",
		"LSP-html",
		"LSP-intelephense",
		"LSP-json",
		"LSP-pyright",
		"LSP-typescript",
		"MarkdownPreview",
		"Monokai++",
		"Package Control",
		"Pretty JSON",
		"SideBarEnhancements",
		"SublimeLinter",
		"SublimeLinter-eslint",
		"SublimeLinter-flake8",
		"SublimeLinter-php",
		"SublimeLinter-shellcheck",
		"Terminus",
		"Theme - DAneo",
		"Theme - Monokai Pro",
		"Theme - Seti Monokai",
		"TrailingSpaces"
	]
}
'@
Set-Content -Path "$USER_DIR\Package Control.sublime-settings" -Value $pcSettings -Encoding UTF8

# 5. Cài đặt thư viện Python 3.14 nội bộ cho ST4 (Terminus & LSP)
Write-Host ">> Đang chuẩn bị môi trường thư viện cho Terminus & LSP..." -ForegroundColor Yellow
python -m pip install --target "$LIB314_DIR" wcwidth ptyprocess pyte bracex wcmatch jinja2 pygments markdown jmespath more-itertools typing_extensions 2>$null

# Clone FileDiffs và Diffy
if (-not (Test-Path "$PACKAGES_DIR\FileDiffs")) {
    git clone --depth 1 https://github.com/colinta/SublimeFileDiffs.git "$PACKAGES_DIR\FileDiffs" 2>$null
}
if (-not (Test-Path "$PACKAGES_DIR\Diffy")) {
    git clone --depth 1 https://github.com/zsong/diffy.git "$PACKAGES_DIR\Diffy" 2>$null
}
if (-not (Test-Path "$PACKAGES_DIR\lsp_utils")) {
    git clone --depth 1 https://github.com/sublimelsp/lsp_utils.git "$PACKAGES_DIR\lsp_utils" 2>$null
}
if (-not (Test-Path "$PACKAGES_DIR\sublime_lib")) {
    git clone --depth 1 https://github.com/SublimeText/sublime_lib.git "$PACKAGES_DIR\sublime_lib" 2>$null
}

# 6. Ghi Preferences.sublime-settings
$prefSettings = @'
{
    "font_size": 13,
    "line_padding_top": 2,
    "line_padding_bottom": 2,
    "highlight_line": true,
    "caret_style": "phase",
    "caret_extra_width": 2,
    "margin": 0,
    "theme": "Adaptive.sublime-theme",
    "color_scheme": "Mariana.sublime-color-scheme",
    "tab_size": 4,
    "translate_tabs_to_spaces": true,
    "detect_indentation": true,
    "trim_trailing_white_space_on_save": "not_on_caret",
    "ensure_newline_at_eof_on_save": true,
    "show_minimap": false,
    "bold_folder_labels": true,
    "highlight_modified_tabs": true,
    "word_wrap": false,
    "wrap_width": 120,

    // Autocomplete tức thì
    "auto_complete": true,
    "auto_complete_delay": 0,
    "auto_complete_selector": "source, text, meta.tag",
    "auto_complete_triggers":
    [
        {"selector": "source",          "characters": "."},
        {"selector": "source.c++",      "characters": ".:>"},
        {"selector": "source.python",   "characters": "."},
        {"selector": "source.php",      "characters": ".$>\\"},
        {"selector": "source.js",       "characters": "."},
        {"selector": "source.css",      "characters": ".:"},
        {"selector": "text.html",       "characters": "<. "},
        {"selector": "text.html meta.tag", "characters": " "}
    ],
    "auto_complete_min_chars": 1,
    "auto_complete_preserve_order": "none",
    "auto_complete_commit_on_tab": true,
    "auto_complete_with_fields": true,
    "auto_complete_include_snippets": true,
    "auto_complete_include_snippets_when_typing": true,
    "auto_match_enabled": true,
    "auto_complete_cycle": true,
    "index_files": true,
    "index_workers": 0,
    "show_definitions": true,
    "show_encoding": true,
    "show_line_endings": true,
    "save_on_focus_lost": true,
    "atomic_save": true,
    "hot_exit": "disabled",
    "remember_open_files": true,
    "rulers": [],
    "file_exclude_patterns": ["*.pyc", "*.pyo", "*.exe", "*.dll", "*.o", "*.obj", ".DS_Store", "*.class"],
    "folder_exclude_patterns": [".svn", ".git", ".hg", "CVS", "__pycache__", "node_modules", ".sass-cache"],
    "ignored_packages": ["Vintage"]
}
'@
Set-Content -Path "$USER_DIR\Preferences.sublime-settings" -Value $prefSettings -Encoding UTF8

# 7. Ghi Keymap (Windows)
$keymap = @'
[
    // === TERMINAL TÍCH HỢP (VS CODE STYLE) ===
    {
        "keys": ["ctrl+backquote"],
        "command": "toggle_terminus_panel",
        "args": { "cwd": "${file_path:${folder}}" }
    },
    {
        "keys": ["ctrl+t"],
        "command": "toggle_terminus_panel",
        "args": { "cwd": "${file_path:${folder}}" }
    },
    {
        "keys": ["ctrl+alt+t"],
        "command": "toggle_terminus_panel",
        "args": { "cwd": "${file_path:${folder}}" }
    },
    {
        "keys": ["ctrl+shift+t"],
        "command": "terminus_open",
        "args": { "cwd": "${file_path:${folder}}" }
    },

    // === SO SÁNH CODE (DIFF) ===
    {
        "keys": ["ctrl+alt+d"],
        "command": "file_diff_menu"
    },
    {
        "keys": ["ctrl+k", "ctrl+d"],
        "command": "diffy"
    },
    {
        "keys": ["ctrl+k", "ctrl+c"],
        "command": "diffy",
        "args": { "action": "clear" }
    },

    // === FORMAT CODE ===
    { "keys": ["ctrl+shift+h"], "command": "html_beautify" },
    { "keys": ["ctrl+shift+j"], "command": "pretty_json" },
    { "keys": ["ctrl+shift+m"], "command": "un_pretty_json" },
    { "keys": ["ctrl+alt+a"], "command": "alignment" },
    { "keys": ["ctrl+0"], "command": "focus_side_bar" },
    { "keys": ["ctrl+shift+c"], "command": "copy_path" },

    // === CHẠY PYTHON ===
    {
        "keys": ["ctrl+r"],
        "command": "build",
        "args": { "build_system": "Packages/User/build_python3.sublime-build" },
        "context": [{ "key": "selector", "operator": "equal", "operand": "source.python" }]
    },

    // === LSP ===
    { "keys": ["f2"], "command": "lsp_symbol_rename" },
    { "keys": ["f12"], "command": "lsp_symbol_definition" },
    { "keys": ["shift+f12"], "command": "lsp_symbol_references" },
    { "keys": ["alt+enter"], "command": "lsp_code_actions" }
]
'@
Set-Content -Path "$USER_DIR\Default (Windows).sublime-keymap" -Value $keymap -Encoding UTF8

# 8. Ghi Menu đỉnh
$mainMenu = @'
[
    {
        "id": "terminal",
        "caption": "Terminal",
        "children": [
            {
                "caption": "Toggle Terminal Panel (Ctrl+T hoặc Ctrl+`)",
                "command": "toggle_terminus_panel",
                "args": {"cwd": "${file_path:${folder}}"}
            },
            {
                "caption": "New Terminal in Tab (Ctrl+Shift+T)",
                "command": "terminus_open",
                "args": {"cwd": "${file_path:${folder}}"}
            },
            { "caption": "-" },
            { "caption": "Close Active Terminal", "command": "terminus_close" },
            { "caption": "Close All Terminals", "command": "terminus_close_all" }
        ]
    },
    {
        "id": "diff_tools",
        "caption": "Diff",
        "children": [
            { "caption": "Compare with Another Tab... (Ctrl+Alt+D)", "command": "file_diff_tab" },
            { "caption": "Compare with Clipboard", "command": "file_diff_clipboard" },
            { "caption": "Compare with Saved File", "command": "file_diff_saved" },
            { "caption": "Compare with File in Project...", "command": "file_diff_file" },
            { "caption": "-" },
            { "caption": "Diff 2 Columns Side-by-Side (Ctrl+K, Ctrl+D)", "command": "diffy" },
            { "caption": "Clear Side-by-Side Diff (Ctrl+K, Ctrl+C)", "command": "diffy", "args": {"action": "clear"} }
        ]
    }
]
'@
Set-Content -Path "$USER_DIR\Main.sublime-menu" -Value $mainMenu -Encoding UTF8

# 9. Ghi Terminus & LSP Settings
$terminusSettings = @'
{
    "default_config": {
        "windows": "PowerShell"
    },
    "shell_configs": [
        {
            "name": "PowerShell",
            "cmd": "powershell.exe",
            "env": { "TERM": "xterm-256color" },
            "enable": true,
            "platforms": ["windows"]
        },
        {
            "name": "Command Prompt",
            "cmd": "cmd.exe",
            "enable": true,
            "platforms": ["windows"]
        }
    ],
    "theme": "adaptive",
    "view_settings": {
        "font_size": 12,
        "line_padding_top": 1,
        "line_padding_bottom": 1
    },
    "reactivate_terminals": true,
    "debug": false
}
'@
Set-Content -Path "$USER_DIR\Terminus.sublime-settings" -Value $terminusSettings -Encoding UTF8

$lspSettings = @'
{
    "inhibit_snippet_completions": false,
    "inhibit_word_completions": false,
    "completion_debounce": 0,
    "show_signature_help": true,
    "show_signature_help_after_completion": true,
    "show_hover_doc": true,
    "show_diagnostics_severity_level": 2,
    "diagnostics_panel_include_severity_level": 2,
    "show_diagnostics_count_in_view_status": true,
    "show_diagnostics_highlights": true,
    "show_diagnostics_panel_on_save": 0,
    "show_inlay_hints": true,
    "lsp_format_on_save": false,
    "show_code_lens": true,
    "log_debug": false,
    "clients": {
        "pyright": {
            "enabled": true,
            "command": ["pyright-langserver.cmd", "--stdio"],
            "selector": "source.python",
            "initializationOptions": {
                "python": {
                    "pythonPath": "python",
                    "analysis": {
                        "autoSearchPaths": true,
                        "useLibraryCodeForTypes": true,
                        "diagnosticMode": "openFilesOnly"
                    }
                }
            }
        }
    }
}
'@
Set-Content -Path "$USER_DIR\LSP.sublime-settings" -Value $lspSettings -Encoding UTF8

# 10. Ghi C++20 Build System (Windows)
$cppBuild = @'
{
    "target": "terminus_exec",
    "cancel": "terminus_cancel_build",
    "focus": true,
    "shell_cmd": "g++ \"$file\" -std=c++20 -O2 -o \"$file_path\\${file_base_name}.exe\" && \"$file_path\\${file_base_name}.exe\"",
    "selector": "source.c++, source.cpp, source.cc",
    "working_dir": "$file_path",
    "file_regex": "^(..[^:]*):([0-9]+):?([0-9]+)?:? (.*)$",
    "variants": [
        {
            "name": "Tối ưu tối đa (-O3 Fast)",
            "target": "terminus_exec",
            "cancel": "terminus_cancel_build",
            "focus": true,
            "shell_cmd": "g++ \"$file\" -std=c++20 -O3 -march=native -flto -DNDEBUG -o \"$file_path\\${file_base_name}.exe\" && \"$file_path\\${file_base_name}.exe\""
        },
        {
            "name": "File I/O (input.txt -> output.txt)",
            "shell_cmd": "g++ \"$file\" -std=c++20 -O2 -DLOCAL -o \"$file_path\\${file_base_name}.exe\" && cd /d \"$file_path\" && \"$file_path\\${file_base_name}.exe\" < input.txt > output.txt && type output.txt"
        }
    ]
}
'@
Set-Content -Path "$USER_DIR\CP_build_cpp.sublime-build" -Value $cppBuild -Encoding UTF8

# 11. Ghi Snippets C++
$cpSnippet = @'
<snippet>
    <content><![CDATA[
#include <bits/stdc++.h>
using namespace std;

#define int long long
#define pii pair<int, int>
#define ALL(x) (x).begin(), (x).end()
#define SZ(x) (int)(x).size()

void solve() {
    $0
}

signed main() {
    ios_base::sync_with_stdio(false);
    cin.tie(nullptr);

    // freopen("input.txt", "r", stdin);
    // freopen("output.txt", "w", stdout);

    int t = 1;
    // cin >> t;
    while (t--) {
        solve();
    }

    return 0;
}
]]></content>
    <tabTrigger>cp</tabTrigger>
    <scope>source.c++</scope>
    <description>CP Template chuẩn (stdin/stdout trực tiếp)</description>
</snippet>
'@
Set-Content -Path "$USER_DIR\cp_template.sublime-snippet" -Value $cpSnippet -Encoding UTF8

Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "   ✓ HOÀN TẤT CÀI ĐẶT & CẤU HÌNH TRÊN WINDOWS!          " -ForegroundColor Green
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "• Phím tắt Terminal tích hợp:  Ctrl+T hoặc Ctrl+`" -ForegroundColor Yellow
Write-Host "• Phím tắt So sánh Code (Diff): Ctrl+Alt+D hoặc Ctrl+K, Ctrl+D" -ForegroundColor Yellow
Write-Host "• Biên dịch C++20 (stdin):     Ctrl+B" -ForegroundColor Yellow
Write-Host "• Snippet code nhanh:          cp + Tab" -ForegroundColor Yellow
