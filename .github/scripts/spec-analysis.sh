#!/usr/bin/env bash
# spec-analysis.sh
# Produces _spec-analysis.md for Claude and writes the Actions job summary.
#
# Inputs (env): SOURCE_TAG, SOURCE_REPO, GH_TOKEN, GITHUB_REPOSITORY
# Outputs: _spec-analysis.md, $GITHUB_OUTPUT, $GITHUB_STEP_SUMMARY
set -euo pipefail

AUTH=(-H "Authorization: Bearer $GH_TOKEN")

# ── 1. Find previous synced tag from merged PRs ───────────────────────────────
PREV_TAG=$(gh pr list \
  --repo "$GITHUB_REPOSITORY" \
  --search "docs: sync with solidarity in:title" \
  --state merged --limit 1 \
  --json title \
  --jq '.[0].title | capture("solidarity (?P<tag>[^ ]+$)").tag' \
  2>/dev/null || echo "")

# ── 2. Compare API — diff stats + file list ───────────────────────────────────
if [ -n "$PREV_TAG" ]; then
  COMPARE_BASE="$PREV_TAG"
  COMPARE=$(curl -fsSL "${AUTH[@]}" \
    "https://api.github.com/repos/${SOURCE_REPO}/compare/${PREV_TAG}...${SOURCE_TAG}?per_page=100")
  TOTAL_COMMITS=$(echo "$COMPARE" | jq -r '.total_commits')
  TOTAL_FILES=$(echo "$COMPARE"  | jq -r '.files | length')
  TOTAL_ADD=$(echo "$COMPARE"    | jq -r '[.files[].additions] | add // 0')
  TOTAL_DEL=$(echo "$COMPARE"    | jq -r '[.files[].deletions] | add // 0')
else
  COMPARE_BASE="(initial sync)"
  TOTAL_COMMITS="N/A"; TOTAL_FILES="N/A"; TOTAL_ADD="N/A"; TOTAL_DEL="N/A"
  COMPARE='{"files":[]}'
fi

# ── 3. Fetch merged PRs between release dates ─────────────────────────────────
PR_TABLE=""; PR_COUNT="N/A"
if [ -n "$PREV_TAG" ]; then
  PREV_DATE=$(curl -fsSL "${AUTH[@]}" \
    "https://api.github.com/repos/${SOURCE_REPO}/releases/tags/${PREV_TAG}" \
    | jq -r '.published_at // empty' | cut -c1-10)
  NEW_DATE=$(curl -fsSL "${AUTH[@]}" \
    "https://api.github.com/repos/${SOURCE_REPO}/releases/tags/${SOURCE_TAG}" \
    | jq -r '.published_at // empty' | cut -c1-10)

  if [ -n "$PREV_DATE" ] && [ -n "$NEW_DATE" ]; then
    PRS=$(curl -fsSL "${AUTH[@]}" \
      "https://api.github.com/search/issues?q=repo:${SOURCE_REPO}+is:pr+is:merged+merged:${PREV_DATE}..${NEW_DATE}&per_page=100&sort=created")
    PR_COUNT=$(echo "$PRS" | jq -r '.total_count')
    PR_TABLE=$(echo "$PRS" | jq -r --arg repo "$SOURCE_REPO" \
      '.items[] | "| [#\(.number)](https://github.com/\($repo)/pull/\(.number)) | \(.title | gsub("\\|";"｜")) | \(if (.labels | map(.name) | any(test("break";"i"))) then "⚠️ breaking" else (.labels | map(.name) | join(", ") | if . == "" then "—" else . end) end) |"')
  fi
fi

# ── 4. Classify changed files with per-file line stats ───────────────────────
classify() {
  echo "$COMPARE" | jq -r --arg p "$1" \
    '.files[]
     | select(.filename | test($p; "i"))
     | select(.filename | test("node_modules|\\.test\\.|\\.spec\\.|__test__"; "i") | not)
     | "- `\(.filename)` (+\(.additions)/−\(.deletions))"' \
  | head -30 || echo ""
}

SPEC=$(classify 'readme|changelog|Package\.swift|\.xcconfig|\.swiftinterface|/protocols?/|/models?/|/schemas?/|/specs?/')
ARCH=$(classify '/(core|protocol|crypto|network|wallet|identity|auth|zk|pass|signing|verification)/')
CONF=$(classify 'Package\.swift|Package\.resolved|\.xcconfig|Podfile|Cartfile|Info\.plist')

HAS_SPEC=$([ -n "$SPEC" ] && echo true || echo false)
HAS_ARCH=$([ -n "$ARCH" ] && echo true || echo false)
if [ "$HAS_SPEC" = true ] || [ "$HAS_ARCH" = true ]; then HAS_CHANGES=true; else HAS_CHANGES=false; fi

# ── 5. Carry-over pending items from last sync ────────────────────────────────
PENDING=$(gh api \
  "repos/${GITHUB_REPOSITORY}/contents/_sync-report.md?ref=main" \
  --jq '.content' 2>/dev/null \
  | base64 -d 2>/dev/null \
  | awk '/^### ⚠️ Pending/,/^---/' \
  | grep -v '^---' | head -30 \
  || echo "")

# ── 6. Helpers ────────────────────────────────────────────────────────────────
section() { [ -n "$2" ] && printf '%s\n%s\n\n' "$1" "$2" || printf '%s\n_None detected_\n\n' "$1"; }
badge()   { [ -n "$1" ] && echo "⚠️  Detected" || echo "✅  None"; }

# ── 7. Write _spec-analysis.md ────────────────────────────────────────────────
{
cat << HEADER
# Spec Analysis — solidarity ${SOURCE_TAG}

## Release Overview

| Metric | Value |
|--------|-------|
| **Release** | \`${SOURCE_TAG}\` |
| **Compared against** | \`${COMPARE_BASE}\` |
| **Commits** | ${TOTAL_COMMITS} |
| **PRs merged** | ${PR_COUNT} |
| **Files changed** | ${TOTAL_FILES} |
| **Lines** | +${TOTAL_ADD} / −${TOTAL_DEL} |

HEADER

if [ -n "$PR_TABLE" ]; then
cat << PRTABLE
## Merged PRs

| PR | Title | Labels / Breaking |
|----|-------|-------------------|
${PR_TABLE}

PRTABLE
fi

echo "## File Change Classification"
echo ""
section "### Spec / Interface / Schema  (+adds/−dels)" "$SPEC"
section "### Architecture-Critical" "$ARCH"
section "### Config / Dependencies" "$CONF"

if [ -n "$PENDING" ]; then
cat << CARRY

## Carry-Over from Last Cycle

${PENDING}

CARRY
fi

cat << FOOTER
---
_Pre-computed by the sync workflow. Claude validates and enriches in Phase 1._
FOOTER
} > _spec-analysis.md

# ── 8. Write Actions job summary ─────────────────────────────────────────────
{
cat << SUMMARY
## Spec Analysis — solidarity \`${SOURCE_TAG}\`

| | |
|---|---|
| **Source tag** | \`${SOURCE_TAG}\` |
| **Compared against** | \`${COMPARE_BASE}\` |
| **Commits** | ${TOTAL_COMMITS} |
| **PRs merged** | ${PR_COUNT} |
| **Files changed** | ${TOTAL_FILES} |
| **Lines** | +${TOTAL_ADD} / −${TOTAL_DEL} |
| **Spec changes** | $(badge "$SPEC") |
| **Arch changes** | $(badge "$ARCH") |

SUMMARY
[ -n "$SPEC" ] && printf '### Spec Files\n%s\n\n' "$SPEC"
[ -n "$ARCH" ] && printf '### Architecture Files\n%s\n\n' "$ARCH"
echo "---"
echo "Claude review triggered. Draft PR will update when complete."
} >> "$GITHUB_STEP_SUMMARY"

# ── 9. Export outputs ─────────────────────────────────────────────────────────
{ echo "prev_tag=$PREV_TAG"; echo "has_changes=$HAS_CHANGES"; } >> "$GITHUB_OUTPUT"
