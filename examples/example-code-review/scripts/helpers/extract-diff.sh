#!/usr/bin/env bash
# extract-diff.sh
#
# 用途：从当前 git 仓库提取一段适合喂给 code-review-assistant 的 diff
# 输出：写入 stdout，可以重定向到文件再粘贴给 Skill
#
# 用法：
#   ./extract-diff.sh                       # 当前未提交改动 vs HEAD
#   ./extract-diff.sh HEAD~3                # 最近 3 次提交合并 diff
#   ./extract-diff.sh main feature/x        # 两个 ref 之间的 diff
#   ./extract-diff.sh --pr 123              # 占位：交由用户接 GitHub CLI
#
# 行为约束（与 Skill 输入规范配套）：
#   - 自动加上 ±5 行上下文，便于审查
#   - 自动忽略 lock / generated / vendor / node_modules
#   - 超过 500 行时打印警告并返回退出码 2，让用户先拆分
#
# 兼容性：bash 4+, git 2.20+; 在 macOS / Linux 上可用。

set -euo pipefail

CONTEXT_LINES=5
MAX_LINES=500

# 排除明显不该审查的路径
EXCLUDE_PATHS=(
  ':(exclude)*.lock'
  ':(exclude)*.sum'
  ':(exclude)package-lock.json'
  ':(exclude)yarn.lock'
  ':(exclude)pnpm-lock.yaml'
  ':(exclude)go.sum'
  ':(exclude)Cargo.lock'
  ':(exclude)*_pb.go'
  ':(exclude)*.pb.go'
  ':(exclude)*_generated.go'
  ':(exclude)vendor/'
  ':(exclude)node_modules/'
  ':(exclude)dist/'
  ':(exclude)build/'
)

usage() {
  sed -n '2,18p' "$0" | sed 's/^# \{0,1\}//'
  exit 1
}

ensure_git_repo() {
  if ! git rev-parse --git-dir >/dev/null 2>&1; then
    echo "error: not in a git repository" >&2
    exit 1
  fi
}

build_diff() {
  local args=("$@")
  if [[ ${#args[@]} -eq 0 ]]; then
    # 默认：暂存 + 未暂存
    git diff -U"$CONTEXT_LINES" HEAD -- "${EXCLUDE_PATHS[@]}"
  elif [[ ${#args[@]} -eq 1 ]]; then
    git diff -U"$CONTEXT_LINES" "${args[0]}" -- "${EXCLUDE_PATHS[@]}"
  else
    git diff -U"$CONTEXT_LINES" "${args[0]}" "${args[1]}" -- "${EXCLUDE_PATHS[@]}"
  fi
}

guard_size() {
  local diff_content="$1"
  local line_count
  line_count=$(printf '%s\n' "$diff_content" | wc -l | tr -d ' ')
  if [[ "$line_count" -gt "$MAX_LINES" ]]; then
    {
      echo "# ⚠️  diff 共 ${line_count} 行，超过 Skill 单次审查上限 ${MAX_LINES} 行。"
      echo "# 建议：按目录或文件拆分后再审，例如："
      echo "#   git diff -U${CONTEXT_LINES} HEAD -- path/to/module"
    } >&2
    return 2
  fi
  return 0
}

print_header() {
  cat <<EOF
# ====== code-review-assistant input ======
# generated_by: scripts/helpers/extract-diff.sh
# generated_at: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
# repo:         $(git rev-parse --show-toplevel)
# branch:       $(git rev-parse --abbrev-ref HEAD)
# args:         $*
# context:      ±${CONTEXT_LINES} lines
# =========================================

EOF
}

main() {
  case "${1:-}" in
    -h|--help) usage ;;
  esac

  ensure_git_repo

  local diff_content
  diff_content=$(build_diff "$@")

  if [[ -z "$diff_content" ]]; then
    echo "# (空 diff：没有改动需要审查)" >&2
    exit 0
  fi

  print_header "$@"
  printf '%s\n' "$diff_content"

  guard_size "$diff_content" || exit $?
}

main "$@"
