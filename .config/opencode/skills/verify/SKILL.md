# Verify Work Package
1. Read SPEC.md and identify all requirements for the specified WP
2. Use parallel Task agents to verify each requirement independently
3. Run `npx tsc --noEmit` to confirm compilation
4. Output a structured checklist: ✅ passing / ❌ failing for each requirement
5. For any ❌, explain what's missing and suggest a fix
