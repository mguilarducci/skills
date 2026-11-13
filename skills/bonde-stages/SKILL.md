---
name: bonde-stages
description: Use when a bonde-* skill needs the path-to-production order of phases and stages, the phase a `bonde-stage` belongs to, or the next command to suggest after a trail reaches a stage.
---

# bonde-stages

The path to production is a list of ordered phases, each with ordered stages. A stage is a `bonde-stage` value in a trail header. The flow is defined in a YAML file; this skill tells you how to get it and read it.

## Get the flow

Run the script bundled with this skill:

```
bash <this skill's directory>/scripts/flow.sh
```

It prints `# source: <path>` and then the flow that applies: the `.bonde/flow.yaml` at the repository root if it exists (found from any subdirectory), otherwise the default bundled with this skill. Always use the script; don't read either file directly.

## Read the flow

```yaml
phases:
  - name: <phase>
    stages:
      - name: <bonde-stage value>
        command: <command that starts the step ending in this stage>
```

- **Order** is the list order: phases in order, stages in order within each phase. There is no order field.
- **Phase of a stage**: the phase whose `stages` list contains it.
- **Next command after stage S**: the `command` of the stage right after S. If S is the last stage of its phase, take the first stage of the next phase that has stages. If no stage follows S, there is no next command: say the flow defines no next step yet.
- **Unknown stage**: if S is not in the flow, say so and show the `# source:` path. Don't guess.

## Customizing

A repository replaces the default by adding `.bonde/flow.yaml` at its root, with the same shape. It replaces the default entirely; the two are never merged.
