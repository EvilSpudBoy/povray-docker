# Agent Guide

This repository builds a Docker image that packages POV-Ray 3.7. Agents should use this file as a quick orientation when picking up tasks.

## Repo layout
- `Dockerfile` builds POV-Ray from source using the upstream `3.7-stable` branch.
- `examples/render.sh` is a helper for running renders from the host filesystem.
- `test/test.sh` builds the image (tag `povray:test`) and renders `test/sample.pov` through stdin/stdout.

## Development workflow
1. Inspect `README.md` for build arguments and usage snippets.
2. Build the image with `docker build -t povray:3.7 .` (override build args as needed).
3. Run renders with `docker run --rm -v "$PWD":/scenes -w /scenes povray:3.7 +Imyscene.pov ...`.
4. Validate changes by executing `./test/test.sh`; it should exit cleanly and leave `test/output.png` behind.

## Notes for automation
- Keep edits ASCII unless the existing file already uses non-ASCII characters.
- Prefer `rg` for searches; avoid reinstalling dependencies inside the container unless a task explicitly requires it.
- Use `examples/render.sh` when you need a minimal reproduction outside CI.
- Mention relevant file paths and exact commands when reporting results to the user.
