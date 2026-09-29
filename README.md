# Skill Vault

One-command installer for the top 10 OpenCode/Claude/Codex skill repos. Auto-detects your coding harness and installs everything.

## One-Command Install

```bash
curl -fsSL https://raw.githubusercontent.com/IamFILINT/skill-vault/main/install.sh | bash
```

## Supported Harnesses

| Harness | Skills Dir | Auto-Detected |
|---------|-----------|-------------|
| OpenCode | `~/.config/opencode/skills` | Yes |
| Claude Code | `~/.claude/skills` | Yes |
| Codex | `~/.codex/skills` | Yes |
| Cursor | `~/.cursor/skills` | Yes |
| Gemini CLI | `~/.gemini/skills` | Yes |
| Copilot | `~/.copilot/skills` | Yes |

## Manual Harness Selection

```bash
curl -fsSL https://raw.githubusercontent.com/IamFILINT/skill-vault/main/install.sh | bash -s -- claude
```

## What's Installed

1. **obra/superpowers** — Agentic dev methodology (spec → plan → TDD → subagent-driven)
2. **DietrichGebert/ponytail** — Minimal code, ~54% less tokens
3. **nextlevelbuilder/ui-ux-pro-max-skill** — Professional UI/UX design intelligence
4. **Graphify-Labs/graphify** — Knowledge graph generator for codebases
5. **JuliusBrussee/caveman** — Ultra-compressed agent communication, up to 75% token savings
6. **addyosmani/agent-skills** — Full lifecycle engineering skills (spec/plan/build/test/review/ship)
7. **Egonex-AI/Understand-Anything** — Interactive knowledge graphs from any codebase
8. **ComposioHQ/awesome-claude-skills** — 1000+ production-ready skills collection
9. **tt-a1i/archify** — Interactive HTML diagrams from ideas and systems
10. **pbakaus/impeccable** — Design guidance with 61 deterministic detector rules

## Update

```bash
curl -fsSL https://raw.githubusercontent.com/IamFILINT/skill-vault/main/install.sh | bash
```

## Uninstall

```bash
curl -fsSL https://raw.githubusercontent.com/IamFILINT/skill-vault/main/uninstall.sh | bash
```

## License

MIT
