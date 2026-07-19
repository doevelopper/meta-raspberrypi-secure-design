---
name: Secure Change Checklist
description: "Use when reviewing or preparing security-relevant changes in this Yocto layer. Produces an impact checklist and validation plan before merge."
argument-hint: "Describe the change scope or paste impacted paths"
agent: "agent"
---

Review the provided change scope and produce a concise pre-merge checklist for this repository.

Required output sections:

1. Change summary (2-4 bullets)
2. Security impact
3. Profile impact (`dev` and `prod`)
4. Boot and key-chain impact
5. Update and rollback impact
6. Validation plan (exact commands)
7. Release risk and rollback notes

Checklist rules:

- Always evaluate impacts to secure boot, key handling, SWUpdate, SELinux/IMA/EVM, and partitions when relevant.
- Explicitly say "Not impacted" for each area that does not apply.
- Prefer links to existing docs instead of duplicating long explanations.
- Include an OELint command whenever metadata files are touched.
- If change touches image composition, include at least one representative kas build command.

Reference docs:

- [README.md](../../README.md)
- [docs/README.md](../../docs/README.md)
- [docs/operations.md](../../docs/operations.md)
- [docs/updates.md](../../docs/updates.md)
- [docs/secure-boot.md](../../docs/secure-boot.md)
- [docs/secure-storage.md](../../docs/secure-storage.md)
