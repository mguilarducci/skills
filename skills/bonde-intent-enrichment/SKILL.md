---
name: bonde-intent-enrichment
description: Use when the person runs /bonde-intent-enrichment with an Entire trail number or URL, to deepen a recorded intent through an interview before brainstorming. Second step of the bonde path to production.
---

# bonde-intent-enrichment

Deepen a trail's intent through a short interview and rewrite the trail body as an enriched intent: the pain or opportunity, a picture of the problem as the user sees it, and success criteria. The result is the input for brainstorming, so it describes the problem, never a solution.

## Steps

Every Entire call and every trail body change follows the `bonde-trail` skill.

1. **Input.** The trail number is the command argument (a URL is mapped to a selector, per `bonde-trail`). If there is none, ask for it, and only for it.

2. **Load the trail** and read its `bonde-stage`, per `bonde-trail`. In every case other than `intent-recorded`, explain the situation and ask the person before continuing:
   - `intent-recorded`: continue.
   - `intent-enriched`: offer to re-enrich, starting from the current body.
   - A later stage: say enrichment is already behind it, show the next command from the `bonde-config` skill, and ask. If the person still wants it, re-enrich and keep the current `bonde-stage`.
   - No `bonde-stage` header: say the trail was not created by `/bonde-intent-create`, and ask. If the person continues, the whole body is the original intent.

3. **Research.** Before the first question, run the `using-entire` skill on the trail's title and description, to learn what is already known (prior sessions, decisions, related code). Use what you find only to ask fewer, better questions; it is not written to the trail.

4. **Interview.** One question per message. The interview is done when these four are clear:
   1. **Who** feels the pain.
   2. **The pain or opportunity**: what happens today and why it is bad, or what could be better.
   3. **Where they want to get**: the outcome the user is after.
   4. **Success criteria**: how the person will know it worked, observable.

   Ask only about what the trail and the research don't already answer. When the research suggests an answer, offer it for confirmation ("From past work it looks like X. Is that right?"). Keep every question about the problem; solutions belong to brainstorming.

5. **Write.** Fill this body, in this order:

   ````
   ---
   bonde-stage: intent-enriched
   ---

   <summary: one short paragraph, rewritten with what the interview learned>

   ## Pain / opportunity

   <who, what happens today and why it is bad or could be better, and where they want to get>

   ## The problem, as the user sees it

   ```mermaid
   <the picture the user would draw on a whiteboard to explain their problem or opportunity, in their words>
   ```

   ## Success criteria

   - <observable criterion>

   ## Original intent

   > The intent as it was before the enrichment interview. Kept for history; the sections above supersede it.

   <original intent, verbatim>
   ````

   - **Original intent** is copied verbatim, never rewritten: the description after the frontmatter of an `intent-recorded` trail; the existing "Original intent" section when re-enriching; the whole body when there was no header.
   - When re-enriching a trail at a later stage, the frontmatter keeps that stage.
   - **The diagram** is the picture the user would draw to explain their problem. Every box is something the person said, in their everyday words: what they do, what they experience, what they want. It can show today, where it hurts, and where they want to get.
   - **Dates**: turn relative dates ("since last week") into absolute ones, counting from when they were written: the trail's creation date for the original intent, today for interview answers.
   - **Title, type and priority**: if the interview shows one of them is wrong, suggest a new value.

6. **Review.** Show the person everything that will be sent:

   ````
   Trail: #<n>
   Title: <title>
   Type: <type>
   Priority: <priority, or (empty)>

   Body:
   ```
   <the full body from step 5>
   ```
   ````

   For a field with a suggested change, show `<current> → <suggested>` instead of the value, e.g. `Priority: (empty) → high`.

   Then ask the person to approve or request changes. On requested changes, continue the interview from what they said, rewrite, and show the whole review again. Repeat until approved.

7. **Update the trail.** Only after approval. Send the body exactly as reviewed, frontmatter included, as the trail's whole body, plus any title, type or priority change the person approved.

8. **Report.** Print the trail URL (from `entire trail show`) and the next step: use the `bonde-config` skill to get the next command after the trail's stage, and print it followed by the trail number:

   ```
   <next command> <trail number>
   ```

## Common mistakes

| Mistake | Instead |
|---|---|
| Asking the first question before researching | Run `using-entire` first |
| Several questions in one message | One question per message |
| Writing research findings or checkpoint ids into the body | Research only guides the interview |
| Sections like Who / Pain / Value, or no diagram | Use exactly the body template in step 5 |
| Original description merged into the summary, or edited | Keep it verbatim under "Original intent", with the disclaimer |
| Diagram with system steps, metrics jargon, or a cause nobody stated | Boxes hold only what the person said, in their words |
| Proposing how to build it | Keep to the problem; brainstorming comes next |
| Updating the trail before the person approves | Wait for explicit approval |
