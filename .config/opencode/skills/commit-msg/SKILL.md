---
name: commit-msg
description: Generates a conventional commit message (subject preferably 69 characters) using the conversation history when available, falling back to the git changes. Use when the user asks to commit changes, write a commit message, or run git commit.
---

# Commit Message Generation

When the user asks you to commit changes (e.g., "commit this", "make a commit", "git commit"), follow these rules:

## 1. Gather context

Use the conversation history first, then the git changes:

1. **Conversation history** - the current session's conversation is the best source of intent: what the user asked for, requirements, decisions, trade-offs, and problems solved. Use only what is relevant to the changes being committed; do not dump the whole conversation.
2. **Git changes** - inspect `git status` and `git diff` (or `git diff --staged`).

If the conversation history is unavailable or contains nothing relevant (e.g., a fresh session, changes made elsewhere), fall back to the git changes alone. Never invent intent that is not supported by either source.

## 2. Write the subject line

- Use the Conventional Commits format: `type: summary` (e.g., `feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `perf:`, `test:`, `style:`, `build:`, `ci:`).
- Write it in English, imperative mood, lowercase after the colon.
- Aim for **69 characters** total; it is a preference, not a hard limit - exceed it only when needed to keep the summary clear.
- Do not end the subject with a period.

## 3. Decide on a description

- If the change is **simple or small** (e.g., a typo fix, a single-line change, a small config tweak), do **not** generate a description. Output only the subject line.
- If the change is complex or non-obvious and a description would add value, draft a short description (a few bullet points or one brief paragraph).
- When the conversation history is available, use it to explain the *why*: requirements, decisions, and alternatives not visible in the diff. Otherwise, base the description on the git changes alone.

## 4. Ask before adding a description

When a description is warranted:

1. Show the user a **preview** of the full commit message (subject + description).
2. Use the **`question` tool** to ask whether to add the description, with exactly two options (single selection, `multiple: false`):
   - **Yes** → include the description in the commit.
   - **No** → commit with the subject line only.
3. Never ask the question in plain text; always use the `question` tool.
4. If the user replies with anything other than "Yes" or "No" (e.g., a custom answer), treat it as "No" and do not insist.

Never add a description without asking first.
