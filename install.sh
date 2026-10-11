#!/bin/bash
# Install ui-feedback-translator skill and scaffold a project's spec workflow.
#
# Usage:
#   install.sh [--repo URL] [--tag TAG] [--project-dir DIR]
#
#   --repo         public git repo URL of the skill (default: $DEFAULT_REPO)
#   --tag          git tag to install (default: latest tag; pin a tag for reproducibility)
#   --project-dir  project directory to scaffold spec.md into (default: current dir)
#   --skills-dir   where the agent runtime looks for skills
#                  (default: ~/workspace/skills; override for other harnesses)
#
# Steps:
#   1. Clone (or update) the skill into ~/workspace/skills/ui-feedback-translator
#   2. Copy assets/spec-template.md -> <project-dir>/spec.md (never overwrites)
#   3. Ensure the AGENTS.md pointer line exists
#   4. Self-check: byte-compile the validator
set -euo pipefail

DEFAULT_REPO="${UI_FEEDBACK_TRANSLATOR_REPO:-https://github.com/okiewafi/ui-feedback-translator.git}"
REPO="$DEFAULT_REPO"
TAG=""
PROJECT_DIR="."
SKILLS_DIR="$HOME/workspace/skills"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo) REPO="$2"; shift 2 ;;
    --tag) TAG="$2"; shift 2 ;;
    --project-dir) PROJECT_DIR="$2"; shift 2 ;;
    --skills-dir) SKILLS_DIR="$2"; shift 2 ;;
    *) echo "unknown arg: $1" >&2; exit 1 ;;
  esac
done

SKILL_DIR="$SKILLS_DIR/ui-feedback-translator"
POINTER="UI/設計相關工作：先載入 ui-feedback-translator skill；沒 spec 不開工。"

# 1. install / update the skill
if [[ -z "$REPO" ]]; then
  echo "no --repo given and UI_FEEDBACK_TRANSLATOR_REPO unset;" >&2
  echo "installing from local directory: $SKILL_DIR" >&2
  if [[ ! -f "$SKILL_DIR/SKILL.md" ]]; then
    echo "skill not found locally; pass --repo <url>" >&2
    exit 1
  fi
else
  if [[ -z "$TAG" ]]; then
    TAG="$(git ls-remote --tags --sort=-v:refname "$REPO" \
      | grep -o 'refs/tags/[^^{]*' | head -1 | sed 's|refs/tags/||')"
    if [[ -n "$TAG" ]]; then
      echo "no --tag given; using latest tag: $TAG"
    else
      echo "no --tag given and no tags found; using default branch"
    fi
  fi
  if [[ -d "$SKILL_DIR/.git" ]]; then
    if [[ -n "$TAG" ]]; then
      echo "updating existing skill at $SKILL_DIR -> tag $TAG"
      git -C "$SKILL_DIR" fetch --tags --quiet
      git -C "$SKILL_DIR" checkout --quiet "$TAG"
    else
      echo "updating existing skill at $SKILL_DIR -> default branch"
      git -C "$SKILL_DIR" pull --quiet --ff-only
    fi
  elif [[ -n "$TAG" ]]; then
    echo "cloning $REPO@$TAG -> $SKILL_DIR"
    mkdir -p "$SKILLS_DIR"
    git clone --quiet --branch "$TAG" --depth 1 "$REPO" "$SKILL_DIR"
  else
    echo "cloning $REPO (default branch) -> $SKILL_DIR"
    mkdir -p "$SKILLS_DIR"
    git clone --quiet --depth 1 "$REPO" "$SKILL_DIR"
  fi
fi

# 2. scaffold project spec.md (never overwrites an existing one)
mkdir -p "$PROJECT_DIR"
if [[ -f "$PROJECT_DIR/spec.md" ]]; then
  echo "spec.md already exists in $PROJECT_DIR; leaving it alone"
else
  cp "$SKILL_DIR/assets/spec-template.md" "$PROJECT_DIR/spec.md"
  echo "scaffolded $PROJECT_DIR/spec.md from template (edit anchor + tokens next)"
fi

# 3. AGENTS.md pointer line
AGENTS="$HOME/AGENTS.md"
if [[ -f "$AGENTS" ]] && ! grep -qF "ui-feedback-translator" "$AGENTS"; then
  printf '\n- %s\n' "$POINTER" >> "$AGENTS"
  echo "added pointer line to AGENTS.md"
else
  echo "AGENTS.md pointer already present (or AGENTS.md missing)"
fi

# 4. self-check the validator
python3 -m py_compile "$SKILL_DIR/bin/validate.py" \
  && echo "validator compiles OK"

echo "done."
