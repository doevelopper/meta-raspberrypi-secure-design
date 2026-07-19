# AGENTS.md

Agent instructions for `meta-raspberrypi-secure`.

## Purpose and Scope

- This repository is a Yocto/OE layer for security-hardened Raspberry Pi images.
- Keep changes minimal, deterministic, and profile-aware (`dev` vs `prod`).
- Prefer linking to existing docs instead of duplicating architecture or runbook content.

## First Read (Link, Do Not Recopy)

- Project overview and baseline commands: [README.md](README.md)
- Documentation index: [docs/README.md](docs/README.md)
- Threat assumptions: [docs/threat-model.md](docs/threat-model.md)
- Architecture and boot/runtime model: [docs/architecture.md](docs/architecture.md)
- Integration and operations guides: [docs/integration.md](docs/integration.md), [docs/operations.md](docs/operations.md)
- Security profile behavior: [docs/profiles.md](docs/profiles.md)
- Key management details: [docs/keys.md](docs/keys.md), [key-usages.md](key-usages.md)

## High-Value Commands

- Generate local signing keys and kas fragment:
  - `./tools/genkey-helper.sh`
- Build with kas (typical local build):
  - `KAS_MACHINE=raspberrypi5 SECURITY_PROFILE=dev kas build kas-rpi-secure.yml:kas-signing-keys.yml`
- Build specific targets (image + update artifact):
  - `KAS_MACHINE=raspberrypi5 KAS_TARGET='rpi-secure-image-base rpi-secure-image-base-update' SECURITY_PROFILE=dev kas build --force-checkout --update kas-rpi-secure.yml:kas-signing-keys.yml`
- Lint recipes/classes similarly to CI:
  - `pip install oelint-adv`
  - `oelint-adv --exit-zero --rulefile .oelint-rulefile.json --release wrynose $(find . -name '*.bb' -o -name '*.bbappend' -o -name '*.bbclass' -o -name '*.inc' | grep -v /layers/)`

## Repository Map for Fast Navigation

- Layer configuration: [conf/layer.conf](conf/layer.conf)
- Global and recipe classes: [classes-global](classes-global), [classes-recipe](classes-recipe)
- Main recipes by domain:
  - Core image/package groups: [recipes-core](recipes-core)
  - Kernel and hardening: [recipes-kernel](recipes-kernel), [recipes-security](recipes-security)
  - Connectivity/network hardening: [recipes-connectivity](recipes-connectivity), [recipes-filter](recipes-filter)
  - BSP and boot artifacts: [recipes-bsp](recipes-bsp)
- Build orchestrations and CI:
  - Kas config: [kas-rpi-secure.yml](kas-rpi-secure.yml)
  - CI pipeline: [Jenkinsfile](Jenkinsfile)
  - Lint workflow: [.github/workflows/oelint.yml](.github/workflows/oelint.yml)

## Editing Conventions for This Layer

- Prefer `.bbappend` or class-level changes over intrusive upstream recipe rewrites.
- Keep variable naming and assignment style consistent with BitBake conventions already used in touched files.
- Do not change `LAYERSERIES_COMPAT`/branch assumptions unless explicitly requested (`wrynose` is current baseline).
- When changing security behavior, verify implications for both `SECURITY_PROFILE=dev` and `SECURITY_PROFILE=prod`.
- Avoid broad refactors in `layers/` vendor mirrors; focus on this layer's authored files.

## Security-Critical Guardrails

- Never commit or print private key material from [rpi-secure-keys](rpi-secure-keys).
- Treat operations involving OTP fuse programming, secure-boot permanence, and device-unique key provisioning as irreversible; document risk in change notes.
- Keep production guidance aligned with [SECURITY.md](SECURITY.md) and [docs/secure-boot.md](docs/secure-boot.md).

## Validation Expectations for Changes

- For metadata edits (`.bb`, `.bbappend`, `.bbclass`, `.inc`): run OELint locally.
- For build flow changes (`kas`, classes, image recipes): run at least one representative kas build command.
- If command execution is not possible, state what was not validated and why.

## Collaboration Notes for Agents

- Prefer small patches with file-scoped intent and explicit rationale.
- Surface operational impact early when edits affect updates, boot chain, keys, SELinux/IMA, or partition layout.
- If repository-specific friction appears over multiple sessions, run `/chronicle improve` to refine this file with evidence from session history.