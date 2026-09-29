#!/usr/bin/env bash
set -euo pipefail

SKILLS=(
  "superpowers"
  "ponytail"
  "ui-ux-pro-max-skill"
  "graphify"
  "caveman"
  "agent-skills"
  "Understand-Anything"
  "awesome-claude-skills"
  "archify"
  "impeccable"
)

detect_harness() {
  if command -v opencode &>/dev/null || [[ -d ~/.config/opencode ]]; then
    echo "opencode"
  elif command -v claude &>/dev/null || [[ -d ~/.claude ]]; then
    echo "claude"
  elif command -v codex &>/dev/null || [[ -d ~/.codex ]]; then
    echo "codex"
  elif command -v cursor &>/dev/null || [[ -d ~/.cursor ]]; then
    echo "cursor"
  elif command -v gemini &>/dev/null || [[ -d ~/.gemini ]]; then
    echo "gemini"
  elif command -v copilot &>/dev/null || [[ -d ~/.copilot ]]; then
    echo "copilot"
  else
    echo "opencode"
  fi
}

main() {
  local harness="${1:-}"
  if [[ -z "$harness" ]]; then
    harness=$(detect_harness)
  fi

  local skills_dir
  case "$harness" in
    opencode) skills_dir="~/.config/opencode/skills" ;;
    claude)   skills_dir="~/.claude/skills" ;;
    codex)    skills_dir="~/.codex/skills" ;;
    cursor)   skills_dir="~/.cursor/skills" ;;
    gemini)   skills_dir="~/.gemini/skills" ;;
    copilot)  skills_dir="~/.copilot/skills" ;;
    *)        skills_dir="~/.config/opencode/skills" ;;
  esac
  skills_dir=$(eval echo "$skills_dir")

  echo "Uninstalling from: $harness ($skills_dir)"
  for name in "${SKILLS[@]}"; do
    target="$skills_dir/$name"
    if [[ -d "$target" ]]; then
      rm -rf "$target"
      echo "  Removed $name"
    fi
  done
  echo "Done!"
}

main "$@"
