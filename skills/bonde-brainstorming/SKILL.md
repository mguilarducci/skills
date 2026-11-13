---
name: bonde-brainstorming
description: Use when the person runs /bonde-brainstorming with an Entire trail number or URL, to brainstorm the design and write the plan for an enriched intent. Covers the planning phase of the bonde path to production.
hooks:
  PreToolUse:
    - matcher: "Skill"
      hooks:
        - type: command
          command: 'bash "${CLAUDE_SKILL_DIR}/scripts/gate.sh" brainstorm "This trail is in the bonde flow. Before planning, run the bonde-record skill with kind brainstorm for the trail being brainstormed. Call superpowers:writing-plans again only after the record succeeded. If it is already recorded (in this session, or the trail was already brainstormed when this session started), just call writing-plans again." superpowers:writing-plans'
        - type: command
          command: 'bash "${CLAUDE_SKILL_DIR}/scripts/gate.sh" plan "This trail is in the bonde flow, where planning ends at the recorded plan. Run the bonde-record skill with kind plan for the trail being planned, then end your turn with its report. Do not execute the plan: execution is a later phase the person starts." superpowers:executing-plans superpowers:subagent-driven-development'
---

# bonde-brainstorming

Run the planning phase on a trail's enriched intent: `superpowers:brainstorming` for the design, then `superpowers:writing-plans` for the plan. Both files are recorded in the specs repository by `bonde-record`, not committed here. The phase ends when the plan is recorded; executing it is a later phase.

Every Entire call follows the `bonde-trail` skill.

## Steps

1. **Input.** The trail number is the command argument (a URL is mapped to a selector, per `bonde-trail`). If there is none, ask for it, and only for it.

2. **Load the trail** and read its `bonde-stage`, per `bonde-trail`. In every case other than `intent-enriched` and `brainstormed`, explain the situation and ask the person before continuing:
   - `intent-enriched`: continue.
   - `brainstormed`: the design is already recorded; resume at planning. Say so and get the design doc: the local one, if it exists; otherwise shallow-clone the branch of the trail's specs change into your scratch directory and read the file in its `brainstorms/` folder (`bonde-record` step 4 gives the folder). If there is no specs change or no such file, explain and ask. Then call `superpowers:writing-plans` with step 4's instructions, without recording again. Its hook blocks that first call once: call it again.
   - `intent-recorded`: say the intent is not enriched yet and suggest `/bonde-intent-enrichment <n>` first.
   - A later stage: say brainstorming is already behind it and show the next command from `bonde-config`.
   - No `bonde-stage` header: say the trail is not in the bonde flow.

3. **Brainstorm.** Invoke `superpowers:brainstorming`. The person's request is the trail's title and body (without the frontmatter): treat it as a spec they already wrote. Tell it that the design doc goes to its default path and is **not committed**: `bonde-record` records it in the specs repository.

4. **Record before planning.** When the design doc is approved and brainstorming hands off to `superpowers:writing-plans`, first run `bonde-record brainstorm <trail number>`. Continue to `superpowers:writing-plans` only after the record succeeded. Tell writing-plans that the plan is **not committed** (`bonde-record` records it) and that, in this flow, it ends once the plan is saved, without offering execution options.

5. **Record the plan and stop.** When writing-plans has saved the plan, run `bonde-record plan <trail number>`, even if writing-plans asked how to execute and the person already picked an option. Its report ends your turn: the trail is `planned` and the planning phase is done. If the person picked an execution option, add one line saying that execution is a later phase they start, and that their choice is noted for it.

In Claude Code, this skill's hooks enforce steps 4 and 5 by blocking, once per session, the first call to writing-plans (record, then call it again) and the first call to `superpowers:executing-plans` or `superpowers:subagent-driven-development` (record, then end the turn).

## Common mistakes

| Mistake | Instead |
|---|---|
| Committing the design doc or the plan, here or in the specs repository | Leave them uncommitted; `bonde-record` records them |
| Going straight to writing-plans after approval | `bonde-record brainstorm <n>` first |
| Executing the plan because the person picked an execution option | `bonde-record plan <n>`, then end the turn with its report |
| Re-asking what the enriched intent already answers | Treat the trail body as the person's spec |
