---
name: BitBake Metadata Rules
description: "Use when editing Yocto metadata files (.bb, .bbappend, .bbclass, .inc). Enforces safe, minimal changes, profile awareness, and validation steps for this layer."
applyTo: "**/*.{bb,bbappend,bbclass,inc}"
---

# BitBake Metadata Rules

Use these rules whenever you edit metadata in this repository.

## Scope and intent

- Keep changes minimal and local to the requested behavior.
- Prefer layer-owned recipes and classes over edits in mirrored vendor layer trees.
- Preserve existing formatting, assignment style, and variable naming in touched files.

## Safety checks before editing

- Verify if behavior differs by security profile and keep both paths correct:
  - `SECURITY_PROFILE=dev`
  - `SECURITY_PROFILE=prod`
- For boot, update, key, SELinux, IMA/EVM, partition, or crypto changes, call out operational impact in the final summary.

## Editing conventions

- Prefer `.bbappend` and class-based extension over invasive rewrites.
- Avoid unrelated refactors in the same patch.
- Do not change branch/compat assumptions (`wrynose`) unless explicitly requested.
- Avoid introducing defaults that weaken production hardening.

## Validation expectations

- Run OELint for metadata updates:
  - `oelint-adv --exit-zero --rulefile .oelint-rulefile.json --release wrynose $(find . -name '*.bb' -o -name '*.bbappend' -o -name '*.bbclass' -o -name '*.inc' | grep -v /layers/)`
- If kas or image composition was affected, run a representative build command and report exact coverage.
- If validation cannot be run, clearly state what was skipped and why.

## Documentation behavior

- Link to existing docs instead of copying long content:
  - [docs/README.md](../../docs/README.md)
  - [docs/profiles.md](../../docs/profiles.md)
  - [docs/secure-boot.md](../../docs/secure-boot.md)
  - [docs/secure-storage.md](../../docs/secure-storage.md)
