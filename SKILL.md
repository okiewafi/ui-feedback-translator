---
name: ui-feedback-translator
description: UI design spec contract and feedback translation for AI-assisted app UI work. Confirm spec before starting, self-validate outputs against the spec, restate intent as a spec diff before redrawing, and offer variants for taste feedback. Trigger on: designing app screens, wireframes, mockups, UI generation, design review, 設計稿, 線框圖, 畫面, 切圖, 對稿.
---

# UI Feedback Translator（回饋翻譯器）

## Purpose

Make AI-generated app UI precise and stable. Natural language is a wish;
numbers are the contract. This skill replaces verbal guesswork with a spec
contract (`spec.md`, per project) and a feedback protocol, plus a validator
that enforces the contract mechanically.

Scope: generic rules only. Project-specific values (brand colors, taste
choices) live in each project's `spec.md`, passed in as input — never in
this skill.

## Workflow

1. **Before starting: confirm the spec. No spec, no work.**
   Read the project's `spec.md`. If none exists, follow
   `references/refining-guide.md` to draft one and get the design owner's approval first.
   Then reply with a start-confirmation (anchor size, tokens in use, page
   list, edge-state checklist) and start only after approval.

2. **While generating: self-validate.**
   Run `bin/validate.py` against every output before presenting it. Fix
   failures yourself; never present failing output. Actively declare any
   deviation from the spec and why — do not wait to be caught.

3. **On feedback: restate intent.**
   Translate feedback into a spec diff and repeat it back for confirmation
   *before* redrawing. See `references/feedback-protocol.md` for the diff
   format and the mechanical/taste language split.

4. **On taste questions: offer variants.**
   Always produce 2–3 variants for taste feedback. Never bet on a single
   answer; the design owner picks.

## Operating Rules

- The spec is a living document. v1 needs anchor + core tokens + checklist
  only; extend as new components or states appear, via the refining process.
- Specs live in project directories, never in this skill.
- Never reverse-engineer a spec from undisciplined artifacts. Specs come
  from Apple HIG + the design owner's taste decisions. Old mockups may inspire; never
  copy numbers from them.
- Canonical anchors are fixed: iOS 390×844 pt, Watch 198×242 pt
  (see `references/apple-platform.md`). The validator checks the anchor
  declared in the project's spec.
- A wireframe constrains layout logic, never pixels. Precision lives in
  tokens, not in the wireframe image.
