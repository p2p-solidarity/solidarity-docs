@claude Please review and update the documentation for solidarity `${SOURCE_TAG}` using the two-phase process below.

---

## Setup

Clone the source repo and install deps if needed:

```bash
git clone --depth 1 --branch ${SOURCE_TAG} \
  https://github.com/${SOURCE_REPO}.git _source
```

Read these two context files already committed to this branch:
- `_spec-analysis.md` — pre-computed diff stats, PR list, and carry-over items from last cycle
- `_release-notes.md` — official release notes

---

## Phase 1 — Spec & Architecture Validation

Your first job is to validate the pre-computed analysis and produce a structured finding. Do not touch docs yet.

**Step 1 — Verify the automated scan**

Check each file listed in `_spec-analysis.md` and confirm what changed.
This is a Swift project — use the following to extract the public API surface:

```bash
# Package structure (SPM)
cat _source/Package.swift

# Swift public API surface — protocols, structs, classes, enums, typealiases
grep -rn \
  "^public protocol\|^public struct\|^public class\|^public enum\|^public typealias\|^public func\|^public var\|^public let\|^open class\|^open protocol" \
  _source --include="*.swift" | sort > /tmp/swift-api-surface.txt
cat /tmp/swift-api-surface.txt

# Protocol definitions specifically (highest-signal for spec changes)
grep -rn "^public protocol\|^protocol" _source --include="*.swift"

# Codable / Decodable models (data format changes)
grep -rn "Codable\|Decodable\|Encodable" _source --include="*.swift" \
  | grep "struct\|class" | sort

# Symbols with @objc (public interface to other runtimes)
grep -rn "@objc\|@objcMembers" _source --include="*.swift" | sort

# Find .swiftinterface files (compiler-generated stable ABI surface)
find _source -name "*.swiftinterface" 2>/dev/null

# Changelog and README
cat _source/CHANGELOG.md 2>/dev/null || cat _source/CHANGELOG 2>/dev/null || true
cat _source/README.md 2>/dev/null | head -100
```

**Step 2 — Find what the scan missed**

Explore `_source/` beyond the flagged files:

```bash
# Module structure — new or removed Swift files
find _source -name "*.swift" | sort

# Entitlements and capabilities (affects privacy/security docs)
find _source -name "*.entitlements" | xargs cat 2>/dev/null

# Info.plist keys (permissions, URL schemes, capabilities)
find _source -name "Info.plist" | xargs grep -l "NS\|CF\|Privacy" 2>/dev/null | head -5

# swift package describe for full dependency graph
(cd _source && swift package describe --type json 2>/dev/null) || true
```

Also look for:
- New or removed Swift modules / targets in `Package.swift`
- Renamed protocols or restructured type hierarchies
- New `@available` annotations (platform / version gating)
- Removed or deprecated symbols (`@available(*, deprecated)`)

**Step 3 — Produce Phase 1 findings**

For each confirmed change, note:
- File path
- What changed (type signature / protocol field / config key / etc.)
- Which docs section is likely affected
- Impact level: `high` (breaking / user-visible) / `medium` (additive) / `low` (internal)

**Gate decision:** If no meaningful changes are found, skip Phase 2, commit only `_sync-report.md`, and mark this PR ready for review.

---

## Phase 2 — Targeted Docs Review

Based on Phase 1 findings, review each docs file at one of two speeds:

**Deep review** — pages directly tied to confirmed spec changes:
1. Read the full page
2. Cross-reference with the specific changed files in `_source/`
3. Apply minimal, targeted edits — only fix inaccuracies
4. Preserve MDX structure, components, headings, and tone exactly

**Quick scan** — pages not flagged by Phase 1:
1. Skim for direct inaccuracies caused by this release
2. Only edit on clear evidence — no speculative additions

**Pages to review:**

Usage:
- `app/page.mdx`
- `app/usage/page.mdx`
- `app/usage/quick-start/page.mdx`
- `app/usage/features/page.mdx`
- `app/usage/user-guide.mdx`
- `app/usage/sharing-methods/page.mdx`
- `app/usage/privacy-security/page.mdx`
- `app/usage/use-cases/page.mdx`

Architecture:
- `app/architecture/page.mdx`
- `app/architecture/tech-stack/page.mdx`
- `app/architecture/p2p-networking/page.mdx`
- `app/architecture/verification-model/page.mdx`
- `app/architecture/wallet-positioning/page.mdx`
- `app/architecture/pass-signing/page.mdx`
- `app/architecture/zero-knowledge/page.mdx`
- `app/architecture/privacy/page.mdx`
- `app/architecture/advanced-capabilities/page.mdx`
- `app/architecture/data-exchange/page.mdx`

Other:
- `app/contribute/page.mdx`

Also check carry-over items from `_spec-analysis.md` — address any high-priority pending items from the last cycle.

---

## Output

**1. Write `_sync-report.md`** using the fixed format in `.github/scripts/report-format.md`.
Fill in all sections. The Pending section is the most important for continuity — anything you cannot confidently update this cycle goes there with a clear next action.

**2. Commit** all changed docs files and `_sync-report.md`:
```
docs: sync with solidarity ${SOURCE_TAG}
```

**3. Mark this PR ready for review** (remove draft status) once done.
