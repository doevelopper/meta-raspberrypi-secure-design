---
name: yocto-verify
description: 'Validate changes in this Yocto security layer. Use for metadata edits, kas configuration changes, image composition updates, and pre-merge verification reporting.'
argument-hint: 'Describe changed files and desired verification depth (lint-only, build, or full)'
user-invocable: true
---

# Yocto Verify

Run a practical verification workflow and produce a concise evidence report.

## Use when

- `.bb`, `.bbappend`, `.bbclass`, or `.inc` files changed.
- `kas-rpi-secure.yml`, classes, image recipes, or update flow changed.
- You need a pre-merge verification summary with explicit pass/fail/skip status.

## Inputs to collect first

- List of changed files.
- Requested verification depth:
  - Lint only
  - Lint + representative build
  - Full target build and artifact checks
- Target machine and profile, defaulting to:
  - `KAS_MACHINE=raspberrypi5`
  - `SECURITY_PROFILE=dev`

## Procedure

1. Categorize change impact

- Metadata only
- Build orchestration or kas config
- Security-sensitive paths (secure boot, keys, updates, SELinux/IMA/EVM, partitions)

2. Run lint for metadata impact

- Use:
  - `oelint-adv --exit-zero --rulefile .oelint-rulefile.json --release wrynose $(find . -name '*.bb' -o -name '*.bbappend' -o -name '*.bbclass' -o -name '*.inc' | grep -v /layers/)`

3. Run representative build when needed

- If key fragment exists:
  - `KAS_MACHINE=raspberrypi5 SECURITY_PROFILE=dev kas build kas-rpi-secure.yml:kas-signing-keys.yml`
- For image + update target verification:
  - `KAS_MACHINE=raspberrypi5 KAS_TARGET='rpi-secure-image-base rpi-secure-image-base-update' SECURITY_PROFILE=dev kas build --force-checkout --update kas-rpi-secure.yml:kas-signing-keys.yml`

4. Collect artifact evidence (when build was run)

- Check expected outputs under `build/tmp/deploy/images/<machine>/`.
- Confirm relevant image and update artifacts exist for the selected targets.

5. Report results

- Provide:
  - Commands executed
  - Pass/fail per command
  - Skipped validations and reasons
  - Risk note if security-sensitive areas changed without full validation

## Output template

- Scope: <short summary>
- Validation level: <lint-only | lint+build | full>
- Lint: <pass/fail/skip>
- Build: <pass/fail/skip>
- Artifacts: <pass/fail/skip>
- Security-sensitive impact: <yes/no + notes>
- Gaps and follow-up: <bullets>

## References

- [README.md](../../../README.md)
- [docs/README.md](../../../docs/README.md)
- [AGENTS.md](../../../AGENTS.md)
