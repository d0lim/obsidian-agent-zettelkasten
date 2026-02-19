# Zettelkasten AI Vault

Zettelkasten + qmd + Claudian 기반 AI-driven Second Brain 템플릿.

## 구조

```
vault/
├── 0-inbox/          # 빠른 메모, 미정리 노트
├── 1-literature/     # 책/아티클/영상 요약
├── 2-permanent/      # 정제된 영구 노트 (플랫, 태그 분류)
├── 3-project/        # 프로젝트별 작업 노트
├── 4-moc/            # Map of Content
├── 5-templates/      # 노트 템플릿
├── 6-output/         # 발행물, 산출물
└── .claude/
    └── commands/     # Claudian slash commands
```

## 아키텍처

```
┌── Obsidian ──────────────────────────────┐
│                                          │
│  [Claudian Plugin]                       │
│   ├── Claude Code (에이전틱 기능)         │
│   ├── @qmd (MCP 서버 → 하이브리드 검색)  │
│   ├── @file (vault 파일 직접 참조)       │
│   └── Inline Edit (노트 직접 수정)       │
│                                          │
│  [Vault] ← qmd가 인덱싱                 │
│   ├── 2-permanent/                       │
│   ├── 1-literature/                      │
│   └── ...                                │
└──────────────────────────────────────────┘
```

Claudian이 Obsidian 안에서 Claude Code를 네이티브로 실행하고, qmd MCP 서버를 통해 vault 전체를 하이브리드 검색(키워드 + 벡터)한다. 노트 작성, 검색, 편집이 Obsidian 한 화면에서 가능.

## 셋업

### 1. 템플릿에서 vault 생성

GitHub에서 **Use this template** → **Create a new repository** 클릭. 로컬에 clone한 뒤 Obsidian에서 vault로 열기.

### 2. 언어 설정

기본 언어는 영어(`en`). 한국어로 전환하려면:

```bash
scripts/switch-lang.sh ko
```

모든 `*.ko.md` 소스 파일을 활성 `*.md` 경로로 복사하고, 현재 언어를 `.language` 파일에 기록한다. 영어로 되돌리려면: `scripts/switch-lang.sh en`.

### 3. 도구 설치

```bash
# SQLite (확장 기능 지원에 필요)
brew install sqlite

# qmd (하이브리드 검색 엔진)
bun install -g https://github.com/tobi/qmd
```

> GGUF 모델(embeddinggemma, qwen3-reranker, Qwen3)은 첫 사용 시 자동 다운로드되어 `~/.cache/qmd/models/`에 캐시됩니다. Ollama 불필요.

### 4. qmd 인덱싱

```bash
VAULT="/path/to/your/vault"

qmd collection add "$VAULT"
qmd context add "$VAULT/2-permanent" "정제된 영구 노트, 핵심 지식"
qmd context add "$VAULT/1-literature" "책/아티클/영상 요약"
qmd context add "$VAULT/3-project" "프로젝트별 작업 노트"
qmd embed
```

노트 추가/수정 후 `qmd embed`로 인덱스 갱신.

### 5. Obsidian 플러그인

#### Claudian (BRAT으로 설치)

1. Settings → Community plugins → Browse → **BRAT** 검색 → 설치 → 활성화
2. Settings → BRAT → Add Beta Plugin → `https://github.com/YishenTu/claudian` 입력
3. Settings → Community plugins → **Claudian** 활성화

**Claudian MCP 설정:**

Settings → Claudian → MCP Servers에 추가:

| 항목 | 값 |
|------|-----|
| Name | `qmd` |
| Type | `stdio` |
| Command | `qmd` |
| Args | `mcp` |

#### Dataview

Settings → Community plugins → Browse → **Dataview** 검색 → 설치 → 활성화

#### QuickAdd

1. Settings → Community plugins → Browse → **QuickAdd** 검색 → 설치 → 활성화
2. Settings → QuickAdd → Add Choice → "Inbox 캡처" (Template)
   - Template Path: `5-templates/inbox.md`
   - File Name Format: `in-{{DATE:YYYYMMDDHHmm}}`
   - Create in folder: `0-inbox`
3. 번개 아이콘 → 명령 팔레트에 등록 → 단축키 지정 (예: `Cmd+Shift+I`)

#### Templates (코어 플러그인)

1. Settings → Core plugins → **Templates** 활성화
2. Template folder location: `5-templates`

## Slash Commands

`.claude/commands/`에 정의된 커맨드들. Claudian 채팅에서 `/command-name`으로 호출.

| 커맨드 | 설명 |
|--------|------|
| `/inbox-review` | inbox 노트 검토, 분류 추천, 관련 노트 검색 |
| `/weekly-review` | 주간 노트 요약, 연결 발견, MOC 업데이트 제안 |
| `/find-connections` | 현재 노트와 관련된 노트 탐색, 위키링크 추천 |
| `/lit-to-permanent` | literature 노트에서 permanent 노트 추출 |

모든 커맨드는 `@qmd`를 사용해 하이브리드 검색을 수행한다.

## 워크플로우

1. **캡처**: `Cmd+Shift+I` → inbox에 메모
2. **정리**: `/inbox-review`로 inbox 검토 → permanent/literature로 이동
3. **심화**: `/find-connections`로 기존 노트와 연결
4. **변환**: `/lit-to-permanent`로 literature에서 아이디어 추출
5. **리뷰**: `/weekly-review`로 주간 정리, MOC 갱신
6. **인덱싱**: `qmd embed`로 인덱스 갱신
