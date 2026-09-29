#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/IamFILINT/skill-vault"
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

detect_harnesses() {
  local found=()
  command -v opencode &>/dev/null || [[ -d ~/.config/opencode ]] && found+=("opencode")
  command -v claude &>/dev/null || [[ -d ~/.claude ]] && found+=("claude")
  command -v codex &>/dev/null || [[ -d ~/.codex ]] && found+=("codex")
  command -v cursor &>/dev/null || [[ -d ~/.cursor ]] && found+=("cursor")
  command -v gemini &>/dev/null || [[ -d ~/.gemini ]] && found+=("gemini")
  command -v copilot &>/dev/null || [[ -d ~/.copilot ]] && found+=("copilot")
  echo "${found[@]}"
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

show_menu() {
  local harnesses=("$@")
  echo ""
  echo "=============================="
  echo "  Skill Vault Installer"
  echo "=============================="
  echo ""
  echo "Detected harnesses:"
  local i=1
  for h in "${harnesses[@]}"; do
    echo "  $i) $h"
    ((i++))
  done
  echo "  A) Install for all"
  echo "  Q) Quit"
  echo ""
  read -rp "Choose harness [1-${#harnesses[@]}/A/Q]: " choice
  echo "$choice"
}

install_for_harness() {
  local harness="$1"
  local skills_dir
  skills_dir=$(eval echo "$(get_skills_dir "$harness")")

  echo ""
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

  if [[ -n "$harness" ]]; then
    install_for_harness "$harness"
    return
  fi

  local detected
  detected=$(detect_harnesses)
  read -ra harnesses <<< "$detected"

  if [[ ${#harnesses[@]} -eq 0 ]]; then
    echo "No harness detected. Defaulting to opencode."
    install_for_harness "opencode"
    return
  fi

  if [[ ${#harnesses[@]} -eq 1 ]]; then
    echo "Auto-detected: ${harnesses[0]}"
    install_for_harness "${harnesses[0]}"
    return
  fi

  local choice
  choice=$(show_menu "${harnesses[@]}")

  if [[ "$choice" == "Q" || "$choice" == "q" ]]; then
    echo "Aborted."
    return
  fi

  if [[ "$choice" == "A" || "$choice" == "a" ]]; then
    for h in "${harnesses[@]}"; do
      install_for_harness "$h"
    done
    return
  fi

  if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#harnesses[@]} )); then
    install_for_harness "${harnesses[$((choice-1))]}"
  else
    echo "Invalid choice."
  fi
}

main "$@"
