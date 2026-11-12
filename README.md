# Ashco

An **Ash-orchestrated company model**: an executable task tree that models how a software company operates, driven by the `ash` scripting language.

The `cycles/` directory defines nested operating cycles (strategic, product, development, launch/marketing, and so on). `teams/` turns those cycles into runnable `.ash` scripts and agent-prompt markdown files.

## Idea

- Each cycle becomes a numbered directory.
- Each phase becomes a numbered file.
- `.ash` scripts handle orchestration such as parallelism and conditionals.
- `.md` files are prompts for the agents that execute each phase.

## Running

This project is orchestration content rather than a standalone application. It is intended to be run with the `ash` CLI:

```bash
ash teams/
```

Install and learn about `ash` from the [ash-lang](https://github.com/kenny1125nz/ash-lang) project.

## Repository layout

- `cycles/` — the operating-cycle definitions
- `teams/` — executable Ash task tree
- `board/`, `refinery/`, `strategic-cycle/` — supporting orchestration artifacts
- `plan.md` — design and structure notes

## Status

Experimental / exploratory.
