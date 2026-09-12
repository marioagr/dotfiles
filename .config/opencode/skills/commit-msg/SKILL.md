---
name: commit-msg
description: Generates a conventional commit message with a subject line of at most 69 characters. Use when the user asks to commit changes, write a commit message, or run git commit.
---

# Commit Message Generation

When the user asks you to commit changes (e.g., "commit this", "make a commit", "git commit"), follow these rules:

## 1. Review the changes

Inspect the changes with `git status` and `git diff` (or `git diff --staged`) before writing anything.

## 2. Write the subject line

- Use the Conventional Commits format: `type: summary` (e.g., `feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `perf:`, `test:`, `style:`, `build:`, `ci:`).
- Write it in English, imperative mood, lowercase after the colon.
- The subject line must be **at most 69 characters** total.
- Do not end the subject with a period.

## 3. Decide on a description

- If the change is **simple or small** (e.g., a typo fix, a single-line change, a small config tweak), do **not** generate a description. Output only the subject line.
- If the change is complex or non-obvious and a description would add value, draft a short description (a few bullet points or one brief paragraph).

## 4. Ask before adding a description

When a description is warranted:

1. Show the user a **preview** of the full commit message (subject + description).
2. Use the **`question` tool** to ask whether to add the description, with exactly two options (single selection, `multiple: false`):
   - **Yes** → include the description in the commit.
   - **No** → commit with the subject line only.
3. Never ask the question in plain text; always use the `question` tool.
4. If the user replies with anything other than "Yes" or "No" (e.g., a custom answer), treat it as "No" and do not insist.

Never add a description without asking first.