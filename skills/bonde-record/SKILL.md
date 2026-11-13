---
name: bonde-record
description: Use when a brainstorm design doc or an implementation plan for an Entire trail must be recorded in the specs repository - when the person runs /bonde-record, or when a hook blocks superpowers:writing-plans (or what follows it) until the record is done.
---

# bonde-record

Record a spec file (a brainstorm or a plan) for a trail in the specs repository, as a change of that same trail, and move the trail to the matching stage.

Arguments: `<kind> <trail number>`, where kind is `brainstorm` or `plan`. If either is missing, ask for it.

| Kind | File to record | Folder | Stage it sets |
|---|---|---|---|
| `brainstorm` | the design doc `superpowers:brainstorming` wrote in this session | `brainstorms` | `brainstormed` |
| `plan` | the plan `superpowers:writing-plans` wrote in this session | `plans` | `planned` |

Every Entire call and every trail body change follows the `bonde-trail` skill.

## Steps

1. **Specs repository.** Get the config from the `bonde-config` skill. If it has no `specs` key, stop: say the specs repository is not configured and show how to set it in the repository's `.bonde/config.yaml` (`specs: <forge>/<owner>/<repo>`).

2. **File.** Find the file for this kind. If there is none, or more than one candidate, ask which one. Record it exactly as it is, keeping its file name.

3. **Trail.** Read the trail (`trail show --json`): its number, title, project, and changes.

4. **Destination path** in the specs repository, fixed:

   ```
   <project>/trails/<trail number>-<title slug>/<repo name>/<folder>/<file name>
   ```

   - `<project>`: the trail's project name (the owner part of the trail's project, e.g. `acme` for `gh/acme`).
   - `<title slug>`: the trail title in lowercase, with every run of other characters than letters and digits replaced by `-`, trimmed of `-`.
   - `<repo name>`: the name of the current repository (from origin), e.g. `reports`.

5. **The trail's specs change.** A trail has at most one change in the specs repository; brainstorm and plan are commits on its branch, and it is merged at the end with the rest of the trail.
   - If the trail's changes include one in the specs repository, use its branch.
   - Otherwise create it with `entire trail link`, in the specs repository, creating a new branch from the specs repository's default branch (flags from `entire agent-help trail link`).

6. **Commit.** Shallow-clone the specs repository into your scratch directory on the change's branch (`gh/<owner>/<repo>` is `https://github.com/<owner>/<repo>.git`), copy the file to the destination path, commit (`Record <kind> for trail #<n>: <title>`), and push. Never commit to the default branch.

7. **Clean up.** For `brainstorm`, keep the local design doc: writing-plans reads it next. For `plan`, delete the local plan and design doc of this trail that git doesn't track in the current repository; leave tracked ones and say so.

8. **Stage.** If the trail's current `bonde-stage` comes before the kind's stage in the flow (`bonde-config`), set it to the kind's stage (per `bonde-trail`). Otherwise leave it. Add nothing else to the header.

9. **Report.** The destination path, the change's URL, and the trail's stage. Then the next step, by kind:
   - `brainstorm`: if a hook sent you here, say the record is done and call the skill the hook blocked again. Otherwise print the next command after the new stage (`bonde-config`) followed by the trail number.
   - `plan`: the recorded plan ends the planning phase, and your turn ends with this report, whether or not a hook sent you here. The last line is the next command after `planned` (`bonde-config`) followed by the trail number, or, when the flow has none, "The flow defines no next step yet." Executing the plan belongs to a later phase that the person starts.

## Common mistakes

| Mistake | Instead |
|---|---|
| Committing to the specs repository's default branch | Commit to the trail's specs change branch |
| A second specs change for the same trail | Reuse the existing one |
| Another path or file name (`trails/12/brainstorm.md`) | The fixed layout and the original file name |
| Adding keys to the trail header (links, file paths) | Only `bonde-stage` changes |
| Guessing the specs repository when `specs` is missing | Stop and show how to configure it |
| Executing the plan after recording it, because a hook blocked execution | End the turn with the report; execution is a later phase |
