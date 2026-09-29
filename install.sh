#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/yourusername/skill-vault"
SKILLS=(
  "obra/superpowers"
  "DietrichGebert/ponytail"
  "nextlevelbuilder/ui-ux-pro-max-skill"
  "Graphify-Labs/graphify"
  "JuliusBrussee/caveman"
  "addyosmani/agent-skills"
  "Egonex-AI/Understand-Anything"
  "ComposioHQ/awesome-claude-skills"
  "tt-a1i/archify"
  "pbakaus/impeccable"
)

detect_harness() {
  local harness=""
  if command -v opencode &>/dev/null || [[ -d ~/.config/opencode ]]; then
    harness="opencode"
  elif command -v claude &>/dev/null || [[ -d ~/.claude ]]; then
    harness="claude"
  elif command -v codex &>/dev/null || [[ -d ~/.codex ]]; then
    harness="codex"
  elif command -v cursor &>/dev/null || [[ -d ~/.cursor ]]; then
    harness="cursor"
  elif command -v gemini &>/dev/null || [[ -d ~/.gemini ]]; then
    harness="gemini"
  elif command -v copilot &>/dev/null || [[ -d ~/.copilot ]]; then
    harness="copilot"
  else
    harness="opencode"
  fi
  echo "$harness"
}

get_skills_dir() {
  local harness="$1"
  case "$harness" in
    opencode) echo "~/.config/opencode/skills" ;;
    claude)   echo "~/.claude/skills" ;;
    codex)    echo "~/.codex/skills" ;;
    cursor)   echo "~/.cursor/skills" ;;
    gemini)   echo "~/.gemini/skills" ;;
    copilot)  echo "~/.copilot/skills" ;;
    *)        echo "~/.config/opencode/skills" ;;
  esac
}

install_for_harness() {
  local harness="$1"
  local skills_dir
  skills_dir=$(eval echo "$(get_skills_dir "$harness")")

  echo "Installing for: $harness"
  echo "Skills dir: $skills_dir"
  mkdir -p "$skills_dir"

  for repo in "${SKILLS[@]}"; do
    name=$(basename "$repo")
    target="$skills_dir/$name"
    if [[ -d "$target/.git" ]]; then
      echo "  Updating $name..."
      git -C "$target" pull --quiet 2>/dev/null || true
    else
      echo "  Cloning $name..."
      git clone --depth=1 "https://github.com/$repo.git" "$target" 2>/dev/null || echo "  WARN: $repo not found, skipping"
    fi
  done

  if [[ "$harness" == "opencode" ]]; then
    local config_dir
    skills_dir=$(eval echo "$skills_dir")
    config_dir="$(dirname "$skills_dir")"
    local config_file="$config_dir/opencode.jsonc"
    if [[ ! -f "$config_file" ]]; then
      cat > "$config_file" <<EOF
{
  "\$schema": "https://opencode.ai/config.json",
  "skills": {
    "paths": ["~/.config/opencode/skills"]
  }
}
EOF
      echo "  Created opencode.jsonc"
    fi
  fi

  echo "Done! Restart $harness to load skills."
}

main() {
  local harness="${1:-}"
  if [[ -z "$harness" ]]; then
    harness=$(detect_harness)
    echo "Auto-detected harness: $harness"
  fi
  install_for_harness "$harness"
}

main "$@"
