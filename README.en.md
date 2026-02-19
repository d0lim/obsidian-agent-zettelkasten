# Zettelkasten AI Vault

AI-driven Second Brain template based on Zettelkasten + qmd + Claudian.

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
    └── commands/     # Claudian slash commands
```

## Architecture

```
┌── Obsidian ──────────────────────────────┐
│                                          │
│  [Claudian Plugin]                       │
│   ├── Claude Code (agentic capabilities) │
│   ├── @qmd (MCP server → hybrid search)  │
│   ├── @file (direct vault file reference)│
│   └── Inline Edit (direct note editing)  │
│                                          │
│  [Vault] ← indexed by qmd               │
│   ├── 2-permanent/                       │
│   ├── 1-literature/                      │
│   └── ...                                │
└──────────────────────────────────────────┘
```

Claudian runs Claude Code natively inside Obsidian and performs hybrid search (keyword + vector) across the entire vault via the qmd MCP server. Note creation, search, and editing all happen within a single Obsidian window.

## Setup

### 1. Create a vault from the template

On GitHub, click **Use this template** → **Create a new repository**. Clone locally and open as a vault in Obsidian.

### 2. Install tools

```bash
# Ollama (local embedding/reranking)
brew install ollama

# Ollama models
ollama pull embeddinggemma
ollama pull ExpedientFalcon/qwen3-reranker:0.6b-q8_0
ollama pull qwen3:0.6b

# qmd (hybrid search engine)
bun install -g https://github.com/tobi/qmd
```

### 3. qmd indexing

```bash
VAULT="/path/to/your/vault"

qmd add "$VAULT"
qmd add-context "$VAULT/2-permanent" "Refined permanent notes, core knowledge"
qmd add-context "$VAULT/1-literature" "Book/article/video summaries"
qmd add-context "$VAULT/3-project" "Project-specific work notes"
qmd embed
```

Run `qmd embed` to refresh the index after adding/editing notes.

### 4. Obsidian plugins

#### Claudian (install via BRAT)

1. Settings → Community plugins → Browse → search **BRAT** → Install → Enable
2. Settings → BRAT → Add Beta Plugin → enter `https://github.com/YishenTu/claudian`
3. Settings → Community plugins → Enable **Claudian**

**Claudian MCP configuration:**

Settings → Claudian → Add to MCP Servers:

| Field | Value |
|-------|-------|
| Name | `qmd` |
| Type | `stdio` |
| Command | `qmd` |
| Args | `mcp` |

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

Commands defined in `.claude/commands/`. Invoke via `/command-name` in Claudian chat.

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
