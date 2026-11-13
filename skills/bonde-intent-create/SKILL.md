---
name: bonde-intent-create
description: Use when the person runs /bonde-intent-create with a brief description of something they want built or fixed, to record that intent as a new Entire trail. First step of the bonde path to production.
---

# bonde-intent-create

Turn a brief description into a short, clear intent and record it as an intent-only Entire trail. This is the first step of the path to production. Deeper detail (pain, value, success criteria) belongs to `/bonde-intent-enrichment`, the next step, not here.

## Steps

1. **Input.** The brief description is the command argument. If there is none, ask for it, and only for it.

2. **Draft.** Write the draft right away, even when the brief is vague. Don't ask clarifying questions before drafting. The draft is:
   - **Title**: one short line.
   - **Description**: one plain paragraph, at most five sentences. It holds only what the brief says: what is wanted and why. Its length follows the brief: a one-line brief gives a one- or two-sentence description. Gaps in the brief go on the review's "Missing from the brief" line, never in the description. No headings, no sections (Scope, Out of scope, Open questions…), no proposed solutions, no guessed causes.
   - **Type**: `bug`, `feature` or `task`, inferred from the brief.
   - **Priority**: `urgent`, `high`, `medium`, `low` or `none`, inferred from the brief. If the brief says nothing about urgency, leave it empty: show `Priority: (empty)` and don't pass a priority when creating the trail.

3. **Review.** Show the person the draft in this shape:

   ````
   Repository: <current repo, as auto-detected by Entire>
   Title: <title>
   Type: <type> (suggested)
   Priority: <priority> (suggested) | (empty)

   Body:
   ```
   ---
   bonde-stage: intent-recorded
   ---

   <description>
   ```

   Missing from the brief: <one line on what is unclear, e.g. the "why"; omit this line if nothing is>
   ````

   Then ask the person to approve or request changes. The repository is shown, not asked about. On requested changes, apply them and show the whole review again. Repeat until approved.

4. **Create the trail.** Only after approval, following the `bonde-trail` skill.
   - Create an intent-only trail (no branch) in the current repository, with the approved title, type, priority, and body.
   - The body is sent exactly as reviewed. It starts with the frontmatter block, including both `---` lines, then a blank line, then the description.

5. **Report.** Print the trail number and URL (from the create output, or `entire trail show`), and the next step: use the `bonde-config` skill to get the next command after `intent-recorded`, and print it followed by the trail number:

   ```
   <next command> <trail number>
   ```

## Common mistakes

| Mistake | Instead |
|---|---|
| Asking questions before showing a draft | Draft first; list what's missing in the review |
| Asking which repository to use | Use the current one and show it in the review |
| `bonde-stage: intent-recorded` as a plain first line | Wrap it in `---` lines so it is YAML frontmatter |
| Body with Scope / Open questions sections or guessed causes | One plain paragraph; enrichment comes later |
| Description saying "the brief doesn't specify…", or stating facts the brief doesn't | Put gaps on the "Missing from the brief" line; describe only what the brief says |
| Padding a short brief into several sentences | A short brief gets a short description; the review fills the gaps |
| Creating the trail before the person approves | Wait for explicit approval |
