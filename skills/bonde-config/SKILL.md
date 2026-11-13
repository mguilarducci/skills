---
name: bonde-config
description: Use when a bonde-* skill needs the bonde configuration - the path-to-production order of phases and stages, the phase a `bonde-stage` belongs to, the next command to suggest after a trail reaches a stage, or the specs repository.
---

# bonde-config

The bonde configuration is a YAML file with one top-level key per setting. This skill tells you how to get it and read it.

## Get the config

Run the script bundled with this skill:

```
bash <this skill's directory>/scripts/config.sh
```

It prints the configuration that applies: the default bundled with this skill, with the `.bonde/config.yaml` at the repository root (found from any subdirectory) applied over it. Each top-level key is preceded by `# <key>: from <path>`, saying which file it came from. Always use the script; don't read either file directly.

## Keys

### `flow`

The path to production: ordered phases, each with ordered stages. A stage is a `bonde-stage` value in a trail header.

```yaml
flow:
  phases:
    - name: <phase>
      stages:
        - name: <bonde-stage value>
          command: <command that starts the step ending in this stage>  # optional
```

- **Order** is the list order: phases in order, stages in order within each phase. There is no order field.
- **Phase of a stage**: the phase whose `stages` list contains it.
- **Next command after stage S**: the `command` of the stage right after S. S's own `command` is the one that led to S, never the next one. If S is the last stage of its phase, take the first stage of the next phase that has stages. If no stage follows S, there is no next command: say the flow defines no next step yet.
- **Stage without `command`**: it is reached inside the step that led to the stage before it, with no command of its own. So the command that led to it is that previous stage's `command`. When the stage right after S has no `command`, the next command is S's own `command`: that step continues to the next stage (if it is still running in this session, just continue it; otherwise running it again resumes it).
- **Unknown stage**: if S is not in the flow, say so and show the `# flow: from` path. Don't guess.

### `specs`

The repository where specs (brainstorms, plans) are recorded, as `forge/owner/repo`, e.g. `specs: gh/acme/planning-files`. It has no default. If the output has no `specs` key, say it is not configured and show how to set it in the repository's `.bonde/config.yaml`.

## Customizing

A repository customizes the configuration by adding `.bonde/config.yaml` at its root, with the same shape. The override is per top-level key: a key the repository defines replaces the default's whole key (a repository `flow` replaces the whole default flow); keys it doesn't define come from the default.
