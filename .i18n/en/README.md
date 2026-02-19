# Zettelkasten AI Vault

AI-driven Second Brain template based on Zettelkasten + qmd + Claude Code.

## Structure

```
vault/
├── 0-inbox/          # Quick notes, unprocessed
├── 1-literature/     # Book/article/video summaries
├── 2-permanent/      # Refined permanent notes (flat, tag-based)
├── 3-project/        # Project-specific work notes
├── 4-moc/            # Map of Content
├── 5-templates/      # Note templates
├── 6-output/         # Publications, deliverables
└── .claude/
    └── commands/     # Claude Code slash commands
```

## Architecture

```
┌── Obsidian ─────────────────┐    ┌── Claude Code (CLI) ──────┐
│                             │    │                           │
│  [Vault] ← indexed by qmd  │    │  claude (agentic CLI)     │
│   ├── 2-permanent/          │◄──►│  ├── @qmd (MCP → search)  │
│   ├── 1-literature/         │    │  └── /commands (slash)    │
│   └── ...                   │    │                           │
└─────────────────────────────┘    └───────────────────────────┘
```

Claude Code runs as a CLI in the vault directory and performs hybrid search (keyword + vector) across the entire vault via the qmd MCP server. MCP configuration is loaded from `.mcp.json` automatically.

## Setup

### 1. Create a vault from the template

On GitHub, click **Use this template** → **Create a new repository**. Clone locally and open as a vault in Obsidian.

### 2. Set language

The vault ships with English (`en`) as the default. To switch to Korean:

```bash
scripts/switch-lang.sh ko
```

This copies language files from `.i18n/ko/` to their active locations and updates `.language`.
To switch back: `scripts/switch-lang.sh en`.

### 3. Install tools

```bash
# SQLite (required for extension support)
brew install sqlite

# qmd (hybrid search engine)
bun install -g https://github.com/tobi/qmd

# Claude Code (AI agent CLI)
npm install -g @anthropic-ai/claude-code
```

> GGUF models (embeddinggemma, qwen3-reranker, Qwen3) are automatically downloaded on first use and cached in `~/.cache/qmd/models/`. No Ollama needed.

### 4. qmd indexing

```bash
VAULT="/path/to/your/vault"

qmd collection add "$VAULT"
qmd context add "$VAULT/2-permanent" "Refined permanent notes, core knowledge"
qmd context add "$VAULT/1-literature" "Book/article/video summaries"
qmd context add "$VAULT/3-project" "Project-specific work notes"
qmd embed
```

Run `qmd embed` to refresh the index after adding/editing notes.

### 5. Obsidian plugins

#### Dataview

Settings → Community plugins → Browse → search **Dataview** → Install → Enable

#### QuickAdd

1. Settings → Community plugins → Browse → search **QuickAdd** → Install → Enable
2. Settings → QuickAdd → Add Choice → "Inbox Capture" (Template)
   - Template Path: `5-templates/inbox.md`
   - File Name Format: `in-{{DATE:YYYYMMDDHHmm}}`
   - Create in folder: `0-inbox`
3. Lightning icon → Register in command palette → Assign hotkey (e.g., `Cmd+Shift+I`)

#### Templates (core plugin)

1. Settings → Core plugins → Enable **Templates**
2. Template folder location: `5-templates`

## Slash Commands

Commands defined in `.claude/commands/`. Invoke via `/command-name` in Claude Code.

| Command | Description |
|---------|-------------|
| `/inbox-review` | Review inbox notes, suggest classification, search related notes |
| `/weekly-review` | Weekly note summary, discover connections, suggest MOC updates |
| `/find-connections` | Explore notes related to the current note, suggest wikilinks |
| `/lit-to-permanent` | Extract permanent notes from a literature note |

All commands use `@qmd` for hybrid search.

## Workflow

1. **Capture**: `Cmd+Shift+I` → quick note to inbox
2. **Process**: `/inbox-review` to review inbox → move to permanent/literature
3. **Deepen**: `/find-connections` to link with existing notes
4. **Transform**: `/lit-to-permanent` to extract ideas from literature
5. **Review**: `/weekly-review` for weekly wrap-up, update MOCs
6. **Index**: `qmd embed` to refresh the index
