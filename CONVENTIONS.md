## Delegation

- Worker agents run in isolated environments and may not share the same context as the main thread. If a worker fails due to environment mismatch, execute directly.
- Worker outputs are untrusted. Always verify with an independent command before reporting to the user.
- Max 1 delegation retry per task. After that, execute directly without asking.

## Skill Execution

**SKILL = Contract. Non-compliance = Breach.**

- **Before**: Extract output format requirements as checklist
- **During**: Execute ALL steps in order, no skipping, no substitution
- **After**: Validate every checklist item before delivery; if any fails, fix first
- **Delegating**: Pass complete output format requirements to workers; include acceptance criteria

Prohibited:
- Executing only "useful" parts of a SKILL
- Replacing SKILL-defined format with "better" alternatives
- Delivering without validation
- Assuming "user will correct me"

## Git

- Each PR contains exactly **1 commit** — squash before submitting
- Rebase onto latest target branch before PR
- No merge commits
