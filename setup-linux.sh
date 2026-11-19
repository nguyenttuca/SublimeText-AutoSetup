#!/usr/bin/env bash
# ==============================================================================
# 🚀 TỰ ĐỘNG CÀI ĐẶT & CẤU HÌNH TOÀN DIỆN SUBLIME TEXT 4 TRÊN LINUX (UBUNTU / DEBIAN)
# Hỗ trợ: Web Dev (PHP/JS/HTML/CSS), Competitive Programming (C++20), Pentest (Python/Bash)
# ==============================================================================

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================================${NC}"
echo -e "${GREEN}   BẮT ĐẦU CÀI ĐẶT SUBLIME TEXT 4 TOÀN DIỆN (LINUX)     ${NC}"
echo -e "${BLUE}========================================================${NC}"

# 1. Cài đặt kho phần mềm Sublime Text chính thức
echo -e "${YELLOW}>> Đang thêm repository Sublime Text...${NC}"
sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates curl wget gpg git

wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

# 2. Cài đặt Sublime Text & các công cụ lập trình cần thiết
echo -e "${YELLOW}>> Đang cài đặt Sublime Text 4, GCC (C++20), PHP, Node.js, ShellCheck...${NC}"
sudo apt-get update -y
sudo apt-get install -y sublime-text g++ gcc php-cli nodejs npm shellcheck time python3 python3-pip python3-venv

# Cài đặt Language Server & Linters toàn cục
echo -e "${YELLOW}>> Đang cài đặt Pyright, ESLint, Flake8, Black...${NC}"
sudo npm install -g pyright eslint prettier 2>/dev/null || true
python3 -m pip install --break-system-packages flake8 black 2>/dev/null || pip3 install flake8 black 2>/dev/null || true

# 3. Đường dẫn thư mục Sublime Text trên Linux
ST_DIR="$HOME/.config/sublime-text"
USER_DIR="$ST_DIR/Packages/User"
INSTALLED_PKGS_DIR="$ST_DIR/Installed Packages"
LIB314_DIR="$ST_DIR/Lib/python314"
PACKAGES_DIR="$ST_DIR/Packages"

mkdir -p "$USER_DIR"
mkdir -p "$INSTALLED_PKGS_DIR"
mkdir -p "$LIB314_DIR"

# 4. Tải Package Control
echo -e "${YELLOW}>> Đang tải Package Control...${NC}"
PC_URL="https://packagecontrol.io/Package%20Control.sublime-package"
curl -fsSL "$PC_URL" -o "$INSTALLED_PKGS_DIR/Package Control.sublime-package"

# 5. Cấu hình danh sách 32+ Packages tự động tải
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

# 6. Tối ưu môi trường Python nội bộ ST4 cho Terminus & LSP
echo -e "${YELLOW}>> Đang chuẩn bị thư viện lõi cho Terminus & LSP...${NC}"
python3 -m pip install --break-system-packages --target "$LIB314_DIR" \
    wcwidth ptyprocess pyte bracex wcmatch jinja2 pygments markdown jmespath more-itertools typing_extensions 2>/dev/null || true

if [[ ! -d "$LIB314_DIR/mdpopups" ]]; then
    TEMP_DIR=$(mktemp -d)
    git clone --depth 1 https://github.com/facelessuser/sublime-markdown-popups.git "$TEMP_DIR" 2>/dev/null || true
    if [[ -d "$TEMP_DIR/mdpopups" ]]; then
        cp -r "$TEMP_DIR/mdpopups" "$LIB314_DIR/"
    fi
    rm -rf "$TEMP_DIR"
fi

# Clone Diffy & FileDiffs
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

# 7. Ghi cấu hình Preferences.sublime-settings
cat << 'EOF' > "$USER_DIR/Preferences.sublime-settings"
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

    // Autocomplete tối ưu tức thì
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
EOF

# 8. Ghi cấu hình Keymap (Linux)
cat << 'EOF' > "$USER_DIR/Default (Linux).sublime-keymap"
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
EOF

# 9. Ghi cấu hình Menu đỉnh
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
EOF

# 10. Ghi cấu hình Terminus & LSP
cat << 'EOF' > "$USER_DIR/Terminus.sublime-settings"
{
    "default_config": {
        "linux": "Bash"
    },
    "shell_configs": [
        {
            "name": "Bash",
            "cmd": ["/bin/bash", "-i", "-l"],
            "env": { "TERM": "xterm-256color" },
            "enable": true,
            "platforms": ["linux"]
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
            "command": ["pyright-langserver", "--stdio"],
            "selector": "source.python",
            "initializationOptions": {
                "python": {
                    "pythonPath": "/usr/bin/python3",
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

# 11. Ghi cấu hình Build Systems (C++20 Interactive qua Terminus, Python, PHP, Shell)
cat << 'EOF' > "$USER_DIR/CP_build_cpp.sublime-build"
{
    "target": "terminus_exec",
    "cancel": "terminus_cancel_build",
    "focus": true,
    "shell_cmd": "g++ \"$file\" -std=c++20 -O2 -o \"$file_path/${file_base_name}\" && \"$file_path/${file_base_name}\"",
    "selector": "source.c++, source.cpp, source.cc",
    "working_dir": "$file_path",
    "file_regex": "^(.+):([0-9]+):([0-9]+):\\s+(.+)$",
    "variants": [
        {
            "name": "Debug (Sanitizer + Đo thời gian / Bộ nhớ)",
            "target": "terminus_exec",
            "cancel": "terminus_cancel_build",
            "focus": true,
            "shell_cmd": "g++ \"$file\" -std=c++20 -Wall -Wextra -Wshadow -O2 -g -fsanitize=address,undefined -o \"$file_path/${file_base_name}\" && /usr/bin/time -v \"$file_path/${file_base_name}\""
        },
        {
            "name": "Tối ưu tối đa (-O3 Fast)",
            "target": "terminus_exec",
            "cancel": "terminus_cancel_build",
            "focus": true,
            "shell_cmd": "g++ \"$file\" -std=c++20 -O3 -march=native -flto -DNDEBUG -o \"$file_path/${file_base_name}\" && \"$file_path/${file_base_name}\""
        },
        {
            "name": "File I/O (input.txt -> output.txt)",
            "shell_cmd": "g++ \"$file\" -std=c++20 -O2 -DLOCAL -o \"$file_path/${file_base_name}\" && cd \"$file_path\" && \"$file_path/${file_base_name}\" < input.txt > output.txt && echo '══════ Output (output.txt) ══════' && cat output.txt"
        }
    ]
}
EOF

cat << 'EOF' > "$USER_DIR/build_python3.sublime-build"
{
    "cmd": ["python3", "-u", "$file"],
    "selector": "source.python",
    "working_dir": "$file_path",
    "file_regex": "^\\s*File \"(...*?)\", line ([0-9]*)",
    "variants": [
        {
            "name": "Interactive (Terminus Terminal)",
            "target": "terminus_exec",
            "cancel": "terminus_cancel_build",
            "focus": true,
            "cmd": ["python3", "-u", "$file"]
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

# 12. Ghi Snippets C++
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

# 13. Khởi động Sublime Text
echo -e "${BLUE}========================================================${NC}"
echo -e "${GREEN}   ✓ HOÀN TẤT CÀI ĐẶT & CẤU HÌNH TRÊN LINUX!           ${NC}"
echo -e "${BLUE}========================================================${NC}"
echo -e "• Phím tắt Terminal tích hợp:  ${YELLOW}Ctrl+T${NC} hoặc ${YELLOW}Ctrl+\`${NC}"
echo -e "• Phím tắt So sánh Code (Diff): ${YELLOW}Ctrl+Alt+D${NC} hoặc ${YELLOW}Ctrl+K, Ctrl+D${NC}"
echo -e "• Biên dịch C++20 (stdin):     ${YELLOW}Ctrl+B${NC}"
echo -e "• Snippet code nhanh:          ${YELLOW}cp${NC} + Tab, ${YELLOW}dsu${NC} + Tab"
EOF
