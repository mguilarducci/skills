---
name: bonde-trail
description: Use when a bonde-* skill reads or changes an Entire trail - creating it, reading its body or `bonde-stage`, rewriting its body, setting its stage, or linking a change - so Entire CLI calls and the trail header are handled the same way everywhere.
---

# bonde-trail

How bonde skills talk to Entire trails and keep the trail header.

## Entire CLI

- **Flags come from `entire agent-help <command> [subcommand]`** (e.g. `entire agent-help trail update`). Run it before the first use of a command in a session. It is local and safe to run anywhere. Don't use `--help`, and don't guess flags.
- **`entire trail` commands need network and keyring access.** If a sandbox blocks them (keychain or network error), ask to run unsandboxed. Don't run `entire login`.
- **The repository is auto-detected from origin.** Pass `--repo` only for a different repository, and `--project` when the trail's project is not origin's owner.
- **URLs**: never pass a trail URL to a command; map it to a selector as `agent-help` explains.
- **Report links** with the `url` that `entire trail show` prints.

## Trail header

The trail body starts with YAML frontmatter, the trail header:

```
---
bonde-stage: <stage>
---

<rest of the body>
```

- **Read the stage**: `entire trail show <n> --json`, then the `bonde-stage` line inside the leading `---` block of `body`. No leading `---` block means the trail has no header.
- **The body is replaced whole on update.** `trail update --body` overwrites the entire body, so always start from the full body that `trail show --json` returns right before writing, never from memory or an abridged copy.
- **Set the stage**: change only the `bonde-stage` line inside the leading block and keep everything else byte for byte, including `![image](attachment:<id>)` lines.
- **Send a body** from a file in your scratch directory, to avoid quoting problems: `entire trail update <n> --body="$(cat <file>)"` (with `=`, since the body starts with `---`).
- **Check** with `entire trail show <n> --json` that the body is what you sent. A missing trailing newline is expected (`$(...)` drops it) and is not a mismatch.
