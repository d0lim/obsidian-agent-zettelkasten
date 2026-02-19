Use @qmd to find notes related to the currently open note.

## Steps

1. Analyze the current note's content to extract key concepts
2. Run qmd vector_search for each key concept (semantic search)
3. Find new connections that don't overlap with existing wikilinks

## Output Format

### Key Concepts
- List the core concepts of this note

### Suggested Connections
For each connection:
- **Note**: [[note name]]
- **Reason**: One-line explanation of why it's related
- **Strength**: Strong / Medium / Weak

### Suggested Wikilinks
Propose wikilinks to add to the current note (which sentence, which link).
