---
description: "propose a commit for the staged git changes"
---

Propose a commit message for the staged git changes:
!`git diff --staged`

- Do not use markdown formatting, just plaintext
- The lines should be 72 characters maximum in length
- All commit messages MUST follow the Conventional Commits specification
  (`type(scope): subject`) and the 50/72 rule.

Example:

  ```text
  feat(dns): Add dual-curve retry logic

  Implement separate exponential backoff strategies for standard
  DNS failures and NXDOMAIN responses to prevent spamming resolvers
  for non-existent domains.
  ```
