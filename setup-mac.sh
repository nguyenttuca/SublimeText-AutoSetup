#!/usr/bin/env bash
# ==============================================================================
# 🚀 TỰ ĐỘNG CÀI ĐẶT & CẤU HÌNH TOÀN DIỆN SUBLIME TEXT 4 TRÊN MACOS
# Hỗ trợ: Web Dev (PHP/JS/HTML/CSS), Competitive Programming (C++20), Pentest (Python/Bash)
# ==============================================================================

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}======================================================${NC}"
echo -e "${GREEN}   BẮT ĐẦU CÀI ĐẶT SUBLIME TEXT 4 TOÀN DIỆN (MACOS)   ${NC}"
echo -e "${BLUE}======================================================${NC}"

# 1. Kiểm tra Homebrew
if ! command -v brew &>/dev/null; then
    echo -e "${YELLOW}>> Đang cài đặt Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [[ -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    echo -e "${GREEN}✓ Homebrew đã có sẵn.${NC}"
fi

# 2. Cài đặt Sublime Text 4 qua Homebrew Cask nếu chưa có
if [[ ! -d "/Applications/Sublime Text.app" ]]; then
    echo -e "${YELLOW}>> Đang tải & cài đặt Sublime Text 4...${NC}"
    brew install --cask sublime-text
else
    echo -e "${GREEN}✓ Sublime Text 4 đã được cài đặt.${NC}"
fi

# Tạo symlink subl vào PATH
if [[ -f "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" ]]; then
    sudo ln -sf "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/subl 2>/dev/null || true
fi

# 3. Cài đặt các công cụ CLI, Linter, Formatter & Compiler
echo -e "${YELLOW}>> Đang cài đặt công cụ lập trình qua Homebrew...${NC}"
brew install gcc php node shellcheck gnu-time prettier php-cs-fixer pipx git curl

# Thêm pipx vào PATH
pipx ensurepath 2>/dev/null || true
export PATH="$HOME/.local/bin:$PATH"

# Cài linter Python
pipx install flake8 2>/dev/null || pipx upgrade flake8 2>/dev/null || true
pipx install black 2>/dev/null || pipx upgrade black 2>/dev/null || true

# Cài đặt Language Server & Linters toàn cục qua npm
echo -e "${YELLOW}>> Đang cài đặt Language Servers (Pyright, ESLint)...${NC}"
npm install -g pyright eslint 2>/dev/null || true

# 4. Xác định đường dẫn thư mục Sublime Text
ST_DIR="$HOME/Library/Application Support/Sublime Text"
USER_DIR="$ST_DIR/Packages/User"
INSTALLED_PKGS_DIR="$ST_DIR/Installed Packages"
LIB314_DIR="$ST_DIR/Lib/python314"
PACKAGES_DIR="$ST_DIR/Packages"

mkdir -p "$USER_DIR"
mkdir -p "$INSTALLED_PKGS_DIR"
mkdir -p "$LIB314_DIR"

# 5. Cài đặt Package Control
echo -e "${YELLOW}>> Đang tải & nạp Package Control...${NC}"
PC_URL="https://packagecontrol.io/Package%20Control.sublime-package"
curl -fsSL "$PC_URL" -o "$INSTALLED_PKGS_DIR/Package Control.sublime-package"

# 6. Cấu hình danh sách 32+ Packages tự động tải
cat << 'EOF' > "$USER_DIR/Package Control.sublime-settings"
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
EOF

# 7. Cài đặt các thư viện lõi cho Python 3.14 nội bộ của Sublime Text 4 (khắc phục lỗi Terminus & LSP)
echo -e "${YELLOW}>> Đang tối ưu môi trường Python 3.14 nội bộ cho ST4...${NC}"
python3 -m pip install --break-system-packages --target "$LIB314_DIR" \
    wcwidth ptyprocess pyte bracex wcmatch jinja2 pygments markdown jmespath more-itertools typing_extensions 2>/dev/null || true

# Nạp trực tiếp thư viện mdpopups vào Lib/python314
if [[ ! -d "$LIB314_DIR/mdpopups" ]]; then
    TEMP_DIR=$(mktemp -d)
    git clone --depth 1 https://github.com/facelessuser/sublime-markdown-popups.git "$TEMP_DIR" 2>/dev/null || true
    if [[ -d "$TEMP_DIR/mdpopups" ]]; then
        cp -r "$TEMP_DIR/mdpopups" "$LIB314_DIR/"
    fi
    rm -rf "$TEMP_DIR"
fi

# Cài FileDiffs và Diffy trực tiếp vào Packages
if [[ ! -d "$PACKAGES_DIR/FileDiffs" ]]; then
    git clone --depth 1 https://github.com/colinta/SublimeFileDiffs.git "$PACKAGES_DIR/FileDiffs" 2>/dev/null || true
fi
if [[ ! -d "$PACKAGES_DIR/Diffy" ]]; then
    git clone --depth 1 https://github.com/zsong/diffy.git "$PACKAGES_DIR/Diffy" 2>/dev/null || true
fi
if [[ ! -d "$PACKAGES_DIR/lsp_utils" ]]; then
    git clone --depth 1 https://github.com/sublimelsp/lsp_utils.git "$PACKAGES_DIR/lsp_utils" 2>/dev/null || true
fi
if [[ ! -d "$PACKAGES_DIR/sublime_lib" ]]; then
    git clone --depth 1 https://github.com/SublimeText/sublime_lib.git "$PACKAGES_DIR/sublime_lib" 2>/dev/null || true
fi

# 8. Cấu hình C++20 Header <bits/stdc++.h> cho Apple clangd (Competitive Programming)
echo -e "${YELLOW}>> Đang thiết lập <bits/stdc++.h> cho Clangd...${NC}"
mkdir -p "$HOME/.local/include/bits"
cat << 'EOF' > "$HOME/.local/include/bits/stdc++.h"
#pragma once
#include <cassert>
#include <cctype>
#include <cerrno>
#include <cfloat>
#include <climits>
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <ctime>
#include <algorithm>
#include <bitset>
#include <complex>
#include <deque>
#include <fstream>
#include <functional>
#include <iomanip>
#include <iostream>
#include <limits>
#include <list>
#include <map>
#include <memory>
#include <numeric>
#include <queue>
#include <set>
#include <sstream>
#include <stack>
#include <string>
#include <tuple>
#include <type_traits>
#include <unordered_map>
#include <unordered_set>
#include <vector>
#include <array>
#include <chrono>
#include <random>
#include <span>
#include <ranges>
#include <concepts>
#include <compare>
#include <numbers>
EOF

mkdir -p "$HOME/Library/Preferences/clangd"
mkdir -p "$HOME/.config/clangd"
cat << EOF > "$HOME/Library/Preferences/clangd/config.yaml"
CompileFlags:
  Add:
    - -std=c++20
    - -isystem$HOME/.local/include
    - -DLOCAL
Diagnostics:
  ClangTidy:
    Remove:
      - "*"
  UnusedIncludes: None
  Suppress:
    - "-W*"
EOF
cp "$HOME/Library/Preferences/clangd/config.yaml" "$HOME/.config/clangd/config.yaml"

# 9. Ghi đè Preferences.sublime-settings (Tối ưu tốc độ gõ & giao diện)
echo -e "${YELLOW}>> Đang ghi cấu hình Preferences...${NC}"
cat << 'EOF' > "$USER_DIR/Preferences.sublime-settings"
{
    // === Font & Hiển thị ===
    "font_face": "Monaco",
    "font_size": 16,
    "line_padding_top": 2,
    "line_padding_bottom": 2,
    "highlight_line": true,
    "caret_style": "phase",
    "caret_extra_width": 2,
    "margin": 0,

    // === Theme ===
    "theme": "Adaptive.sublime-theme",
    "color_scheme": "Mariana.sublime-color-scheme",
    "dark_theme": "Adaptive.sublime-theme",
    "light_theme": "Adaptive.sublime-theme",

    // === Tab & Indent ===
    "tab_size": 4,
    "translate_tabs_to_spaces": true,
    "detect_indentation": true,
    "trim_trailing_white_space_on_save": "not_on_caret",
    "ensure_newline_at_eof_on_save": true,

    // === Minimap & Sidebar ===
    "show_minimap": false,
    "bold_folder_labels": true,
    "highlight_modified_tabs": true,

    // === Word Wrap ===
    "word_wrap": false,
    "wrap_width": 120,

    // === Autocomplete Tối Ưu Tốc Độ ===
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

    // === Indexing & Definitions ===
    "index_files": true,
    "index_workers": 0,
    "show_definitions": true,
    "show_encoding": true,
    "show_line_endings": true,

    // === Lưu file ===
    "save_on_focus_lost": true,
    "atomic_save": true,
    "hot_exit": "disabled",
    "remember_open_files": true,
    "rulers": [],

    "file_exclude_patterns": ["*.pyc", "*.pyo", "*.exe", "*.dll", "*.o", "*.obj", ".DS_Store", "*.class"],
    "folder_exclude_patterns": [".svn", ".git", ".hg", "CVS", "__pycache__", "node_modules", ".sass-cache"],
    "ignored_packages": ["Vintage"]
}
EOF

# 10. Ghi cấu hình Keymap (Phím tắt VS Code, Terminal, Diff, LSP)
echo -e "${YELLOW}>> Đang ghi Key Bindings...${NC}"
cat << 'EOF' > "$USER_DIR/Default (OSX).sublime-keymap"
[
    // === TERMINAL TÍCH HỢP (GIỐNG VS CODE) ===
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
        "keys": ["super+alt+t"],
        "command": "toggle_terminus_panel",
        "args": { "cwd": "${file_path:${folder}}" }
    },
    {
        "keys": ["super+shift+t"],
        "command": "terminus_open",
        "args": { "cwd": "${file_path:${folder}}" }
    },

    // === SO SÁNH CODE (DIFF) ===
    {
        "keys": ["super+alt+d"],
        "command": "file_diff_menu"
    },
    {
        "keys": ["super+k", "super+d"],
        "command": "diffy"
    },
    {
        "keys": ["super+k", "super+c"],
        "command": "diffy",
        "args": { "action": "clear" }
    },

    // === FORMAT CODE ===
    { "keys": ["super+shift+h"], "command": "html_beautify" },
    { "keys": ["super+shift+j"], "command": "pretty_json" },
    { "keys": ["super+shift+m"], "command": "un_pretty_json" },
    { "keys": ["ctrl+super+a"], "command": "alignment" },
    { "keys": ["ctrl+0"], "command": "focus_side_bar" },
    { "keys": ["super+shift+c"], "command": "copy_path" },

    // === CHẠY PYTHON NHANH ===
    {
        "keys": ["ctrl+r"],
        "command": "build",
        "args": { "build_system": "Packages/User/build_python3.sublime-build" },
        "context": [{ "key": "selector", "operator": "equal", "operand": "source.python" }]
    },

    // === LSP SYMBOLS ===
    { "keys": ["f2"], "command": "lsp_symbol_rename" },
    { "keys": ["f12"], "command": "lsp_symbol_definition" },
    { "keys": ["shift+f12"], "command": "lsp_symbol_references" },
    { "keys": ["super+."], "command": "lsp_code_actions" }
]
EOF

# 11. Ghi cấu hình Menu đỉnh macOS (Thêm menu Terminal & Diff)
cat << 'EOF' > "$USER_DIR/Main.sublime-menu"
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
                "caption": "New Terminal in Tab (Cmd+Shift+T)",
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
            { "caption": "Compare with Another Tab... (Cmd+Alt+D)", "command": "file_diff_tab" },
            { "caption": "Compare with Clipboard", "command": "file_diff_clipboard" },
            { "caption": "Compare with Saved File", "command": "file_diff_saved" },
            { "caption": "Compare with File in Project...", "command": "file_diff_file" },
            { "caption": "-" },
            { "caption": "Diff 2 Columns Side-by-Side (Cmd+K, Cmd+D)", "command": "diffy" },
            { "caption": "Clear Side-by-Side Diff (Cmd+K, Cmd+C)", "command": "diffy", "args": {"action": "clear"} }
        ]
    }
]
EOF

# 12. Ghi cấu hình Terminus & LSP
cat << 'EOF' > "$USER_DIR/Terminus.sublime-settings"
{
    "default_config": {
        "osx": "Zsh",
        "linux": "Bash",
        "windows": "Command Prompt"
    },
    "shell_configs": [
        {
            "name": "Zsh",
            "cmd": ["/bin/zsh", "-i", "-l"],
            "env": {
                "TERM": "xterm-256color",
                "PATH": "/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.local/bin"
            },
            "enable": true,
            "platforms": ["osx"]
        }
    ],
    "theme": "adaptive",
    "view_settings": {
        "font_face": "Monaco",
        "font_size": 13,
        "line_padding_top": 1,
        "line_padding_bottom": 1
    },
    "reactivate_terminals": true,
    "debug": false
}
EOF

cat << 'EOF' > "$USER_DIR/LSP.sublime-settings"
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
            "command": ["/opt/homebrew/bin/pyright-langserver", "--stdio"],
            "selector": "source.python",
            "initializationOptions": {
                "python": {
                    "pythonPath": "/opt/homebrew/bin/python3",
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
EOF

cat << EOF > "$USER_DIR/LSP-clangd.sublime-settings"
{
    "binary": "system",
    "system_binary": "/usr/bin/clangd",
    "initialization_options": {
        "fallbackFlags": [
            "-std=c++20",
            "-isystem$HOME/.local/include",
            "-DLOCAL"
        ],
        "clangd.enable-config": true,
        "clangd.completion-style": "detailed",
        "clangd.header-insertion": "never"
    }
}
EOF

# 13. Ghi cấu hình Build Systems (C++20 Interactive, Python, PHP, Shell)
echo -e "${YELLOW}>> Đang cài đặt Build Systems...${NC}"

# Tìm binary GCC mới nhất của Homebrew
GCC_BIN=$(find /opt/homebrew/bin -name "g++-*" 2>/dev/null | sort -V | tail -n 1)
if [[ -z "$GCC_BIN" ]]; then
    GCC_BIN="/opt/homebrew/bin/g++"
fi

cat << EOF > "$USER_DIR/CP_build_cpp.sublime-build"
{
    "target": "terminus_exec",
    "cancel": "terminus_cancel_build",
    "focus": true,
    "shell_cmd": "$GCC_BIN \\"\$file\\" -std=c++20 -O2 -o \\"\$file_path/\${file_base_name}\\" && \\"\$file_path/\${file_base_name}\\"",
    "selector": "source.c++, source.cpp, source.cc",
    "working_dir": "\$file_path",
    "file_regex": "^(.+):([0-9]+):([0-9]+):\\\\s+(.+)\$",
    "variants": [
        {
            "name": "Debug (Sanitizer + Đo thời gian / Bộ nhớ)",
            "target": "terminus_exec",
            "cancel": "terminus_cancel_build",
            "focus": true,
            "shell_cmd": "$GCC_BIN \\"\$file\\" -std=c++20 -Wall -Wextra -Wshadow -O2 -g -fsanitize=address,undefined -o \\"\$file_path/\${file_base_name}\\" && /opt/homebrew/bin/gtime -f '\\\\n══════ Stats ══════\\\\nTime: %es | Memory: %MkB' \\"\$file_path/\${file_base_name}\\""
        },
        {
            "name": "Tối ưu tối đa (-O3 Fast)",
            "target": "terminus_exec",
            "cancel": "terminus_cancel_build",
            "focus": true,
            "shell_cmd": "$GCC_BIN \\"\$file\\" -std=c++20 -O3 -march=native -flto -DNDEBUG -o \\"\$file_path/\${file_base_name}\\" && \\"\$file_path/\${file_base_name}\\""
        },
        {
            "name": "File I/O (input.txt -> output.txt)",
            "shell_cmd": "$GCC_BIN \\"\$file\\" -std=c++20 -O2 -DLOCAL -o \\"\$file_path/\${file_base_name}\\" && cd \\"\$file_path\\" && \\"\$file_path/\${file_base_name}\\" < input.txt > output.txt && echo '══════ Output (output.txt) ══════' && cat output.txt"
        }
    ]
}
EOF

cat << 'EOF' > "$USER_DIR/build_python3.sublime-build"
{
    "cmd": ["/opt/homebrew/bin/python3", "-u", "$file"],
    "selector": "source.python",
    "working_dir": "$file_path",
    "file_regex": "^\\s*File \"(...*?)\", line ([0-9]*)",
    "variants": [
        {
            "name": "Interactive (Terminus Terminal)",
            "target": "terminus_exec",
            "cancel": "terminus_cancel_build",
            "focus": true,
            "cmd": ["/opt/homebrew/bin/python3", "-u", "$file"]
        }
    ]
}
EOF

cat << 'EOF' > "$USER_DIR/build_php.sublime-build"
{
    "cmd": ["php", "$file"],
    "selector": "source.php, embedding.php",
    "working_dir": "$file_path",
    "file_regex": "^.*?:\\s+(.+?) in (.+?) on line (\\d+)",
    "variants": [
        {
            "name": "Local Web Server (localhost:8000)",
            "shell_cmd": "echo '══════ PHP Server http://localhost:8000 (Ctrl+C to stop) ══════' && php -S localhost:8000 -t \"$file_path\"",
            "cancel": {"kill": true}
        },
        {
            "name": "Syntax Check (Lint)",
            "cmd": ["php", "-l", "$file"]
        }
    ]
}
EOF

cat << 'EOF' > "$USER_DIR/build_shell.sublime-build"
{
    "cmd": ["bash", "$file"],
    "selector": "source.shell.bash",
    "working_dir": "$file_path",
    "variants": [
        {
            "name": "Interactive (Terminus Terminal)",
            "target": "terminus_exec",
            "cancel": "terminus_cancel_build",
            "focus": true,
            "cmd": ["bash", "$file"]
        },
        {
            "name": "ShellCheck Linter",
            "cmd": ["shellcheck", "-x", "$file"]
        }
    ]
}
EOF

# 14. Ghi các Snippets C++ Competitive Programming
cat << 'EOF' > "$USER_DIR/cp_template.sublime-snippet"
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
EOF

cat << 'EOF' > "$USER_DIR/cp_dsu.sublime-snippet"
<snippet>
    <content><![CDATA[
struct DSU {
    vector<int> par, sz;
    int components;
    DSU(int n) : par(n + 1), sz(n + 1, 1), components(n) {
        iota(par.begin(), par.end(), 0);
    }
    int find(int u) {
        return par[u] == u ? u : par[u] = find(par[u]);
    }
    bool unite(int u, int v) {
        u = find(u); v = find(v);
        if (u == v) return false;
        if (sz[u] < sz[v]) swap(u, v);
        par[v] = u;
        sz[u] += sz[v];
        components--;
        return true;
    }
    bool same(int u, int v) { return find(u) == find(v); }
    int size(int u) { return sz[find(u)]; }
};
$0
]]></content>
    <tabTrigger>dsu</tabTrigger>
    <scope>source.c++</scope>
    <description>Disjoint Set Union (DSU)</description>
</snippet>
EOF

cat << 'EOF' > "$USER_DIR/cp_mint.sublime-snippet"
<snippet>
    <content><![CDATA[
const int MOD = ${1:1000000007};

long long power(long long a, long long b, long long mod = MOD) {
    long long res = 1; a %= mod;
    for (; b > 0; b >>= 1) {
        if (b & 1) res = res * a % mod;
        a = a * a % mod;
    }
    return res;
}
long long inv(long long a) { return power(a, MOD - 2); }

struct Mint {
    long long v;
    Mint(long long v = 0) : v((v % MOD + MOD) % MOD) {}
    Mint operator+(Mint o) { return v + o.v; }
    Mint operator-(Mint o) { return v - o.v; }
    Mint operator*(Mint o) { return v * o.v; }
    Mint operator/(Mint o) { return v * inv(o.v); }
    Mint& operator+=(Mint o) { return *this = *this + o; }
    Mint& operator-=(Mint o) { return *this = *this - o; }
    Mint& operator*=(Mint o) { return *this = *this * o; }
    friend ostream& operator<<(ostream& os, Mint m) { return os << m.v; }
};
$0
]]></content>
    <tabTrigger>mint</tabTrigger>
    <scope>source.c++</scope>
    <description>Modular Arithmetic Struct (Mint)</description>
</snippet>
EOF

# 15. Hoàn tất & Khởi động Sublime Text
echo -e "${YELLOW}>> Đang khởi động lại Sublime Text để cập nhật...${NC}"
osascript -e 'tell application "Sublime Text" to quit' 2>/dev/null || true
sleep 2
open -a "Sublime Text"

echo -e "${BLUE}======================================================${NC}"
echo -e "${GREEN}   ✓ HOÀN TẤT CÀI ĐẶT & CẤU HÌNH TRÊN MACOS!          ${NC}"
echo -e "${BLUE}======================================================${NC}"
echo -e "• Phím tắt Terminal tích hợp:  ${YELLOW}Ctrl+T${NC} hoặc ${YELLOW}Ctrl+\`${NC}"
echo -e "• Phím tắt So sánh Code (Diff): ${YELLOW}Cmd+Alt+D${NC} hoặc ${YELLOW}Cmd+K, Cmd+D${NC}"
echo -e "• Biên dịch C++20 (stdin):     ${YELLOW}Cmd+B${NC}"
echo -e "• Snippet code nhanh:          ${YELLOW}cp${NC} + Tab, ${YELLOW}dsu${NC} + Tab, ${YELLOW}mint${NC} + Tab"
EOF
