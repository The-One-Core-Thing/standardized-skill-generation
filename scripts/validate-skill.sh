#!/usr/bin/env bash
# ============================================================================
# validate-skill.sh
# ----------------------------------------------------------------------------
# 校验 SKILL.md 文件是否符合 standardized-skill-generation 的基本规范。
#
# 用法:
#   ./validate-skill.sh path/to/SKILL.md
#
# 校验项:
#   1. 文件是否存在
#   2. 是否有 YAML frontmatter（首行 --- 且有结束 ---）
#   3. frontmatter 是否包含 name
#   4. frontmatter 是否包含 description
#   5. frontmatter 是否包含 version
#   6. 正文是否包含约束/限制相关内容
#   7. 文件行数是否合理（>= 30 行）
#
# 退出码:
#   0 全部通过
#   1 至少一项失败
#   2 用法错误
#
# 平台兼容: macOS / Linux（仅依赖 POSIX + grep / sed / awk / tput）
# ============================================================================

set -u

# ---------------------------- 颜色配置 ---------------------------------------
if [ -t 1 ] && command -v tput >/dev/null 2>&1 && [ "$(tput colors 2>/dev/null || echo 0)" -ge 8 ]; then
    C_GREEN="$(tput setaf 2)"
    C_RED="$(tput setaf 1)"
    C_YELLOW="$(tput setaf 3)"
    C_BOLD="$(tput bold)"
    C_RESET="$(tput sgr0)"
else
    C_GREEN=""; C_RED=""; C_YELLOW=""; C_BOLD=""; C_RESET=""
fi

# ---------------------------- 用法 -------------------------------------------
usage() {
    cat <<EOF
用法: $0 <path-to-SKILL.md>

示例:
  $0 examples/example-code-review/SKILL.md
EOF
}

if [ "$#" -ne 1 ]; then
    usage
    exit 2
fi

case "$1" in
    -h|--help)
        usage
        exit 0
        ;;
esac

FILE="$1"
PASS_COUNT=0
TOTAL_COUNT=0

# ---------------------------- 工具函数 ---------------------------------------
pass() {
    PASS_COUNT=$((PASS_COUNT + 1))
    TOTAL_COUNT=$((TOTAL_COUNT + 1))
    printf "%s✅ PASS%s: %s\n" "$C_GREEN" "$C_RESET" "$1"
}

fail() {
    TOTAL_COUNT=$((TOTAL_COUNT + 1))
    printf "%s❌ FAIL%s: %s\n" "$C_RED" "$C_RESET" "$1"
}

warn() {
    printf "%s⚠️  WARN%s: %s\n" "$C_YELLOW" "$C_RESET" "$1"
}

# 提取 frontmatter（首段 --- ... --- 之间的内容）
extract_frontmatter() {
    awk '
        BEGIN { in_fm = 0; started = 0 }
        NR == 1 && /^---[[:space:]]*$/ { in_fm = 1; started = 1; next }
        started && in_fm && /^---[[:space:]]*$/ { exit }
        in_fm { print }
        !started { exit }
    ' "$1"
}

printf "%s== 校验文件: %s ==%s\n\n" "$C_BOLD" "$FILE" "$C_RESET"

# ---------------------------- 1. 文件存在 -------------------------------------
if [ -f "$FILE" ]; then
    pass "文件存在"
else
    fail "文件不存在: $FILE"
    printf "\n%s总结%s: %d/%d 项通过\n" "$C_BOLD" "$C_RESET" "$PASS_COUNT" "$TOTAL_COUNT"
    exit 1
fi

# ---------------------------- 2. YAML Frontmatter 格式 -----------------------
FIRST_LINE="$(sed -n '1p' "$FILE" | tr -d '\r')"
if [ "$FIRST_LINE" = "---" ]; then
    # 查找第二个 ---
    SECOND_DELIM_LINE="$(awk 'NR==1 && /^---[[:space:]]*$/ {next} /^---[[:space:]]*$/ {print NR; exit}' "$FILE")"
    if [ -n "$SECOND_DELIM_LINE" ]; then
        pass "YAML frontmatter 格式正确"
        FM_OK=1
    else
        fail "YAML frontmatter 缺少结束标记 ---"
        FM_OK=0
    fi
else
    fail "首行不是 ---，缺少 YAML frontmatter"
    FM_OK=0
fi

# ---------------------------- 3-5. 必填字段 ----------------------------------
if [ "${FM_OK:-0}" -eq 1 ]; then
    FM_CONTENT="$(extract_frontmatter "$FILE")"

    if printf "%s\n" "$FM_CONTENT" | grep -Eq '^[[:space:]]*name[[:space:]]*:[[:space:]]*[^[:space:]]'; then
        pass "name 字段存在"
    else
        fail "缺少 name 字段（或 name 值为空）"
    fi

    if printf "%s\n" "$FM_CONTENT" | grep -Eq '^[[:space:]]*description[[:space:]]*:'; then
        pass "description 字段存在"
    else
        fail "缺少 description 字段"
    fi

    if printf "%s\n" "$FM_CONTENT" | grep -Eq '^[[:space:]]*version[[:space:]]*:[[:space:]]*[^[:space:]]'; then
        pass "version 字段存在"
    else
        fail "缺少 version 字段（或 version 值为空）"
    fi
else
    fail "name 字段检查跳过（frontmatter 不合法）"
    fail "description 字段检查跳过（frontmatter 不合法）"
    fail "version 字段检查跳过（frontmatter 不合法）"
fi

# ---------------------------- 6. 约束/限制内容 -------------------------------
if grep -Eqi '约束|限制|护栏|边界|禁止|不要|不会|constraint|limitation|guardrail' "$FILE"; then
    pass "正文包含约束/限制相关内容"
else
    fail "正文未发现约束/限制相关关键词（建议补充「约束」「限制」「禁止」等）"
fi

# ---------------------------- 7. 行数合理性 ----------------------------------
LINE_COUNT="$(awk 'END { print NR }' "$FILE")"
MIN_LINES=30
if [ "$LINE_COUNT" -ge "$MIN_LINES" ]; then
    pass "文件行数合理（${LINE_COUNT} 行 ≥ ${MIN_LINES}）"
else
    fail "文件行数过少（${LINE_COUNT} 行 < ${MIN_LINES}），内容可能不足"
fi

# ---------------------------- 总结 -------------------------------------------
echo
if [ "$PASS_COUNT" -eq "$TOTAL_COUNT" ]; then
    printf "%s总结%s: %s%d/%d 项通过%s 🎉\n" \
        "$C_BOLD" "$C_RESET" "$C_GREEN" "$PASS_COUNT" "$TOTAL_COUNT" "$C_RESET"
    exit 0
else
    printf "%s总结%s: %s%d/%d 项通过%s\n" \
        "$C_BOLD" "$C_RESET" "$C_RED" "$PASS_COUNT" "$TOTAL_COUNT" "$C_RESET"
    exit 1
fi
