# Context Priority

When sources conflict, trust them in this order:

1. Source code
2. Tests
3. API schemas, migrations, generated types
4. CI configuration
5. Official documentation
6. Architecture Decision Records
7. Tickets, pull requests, and commit history
8. `.agent_files/shared`
9. `.agent_files/domains`
10. `.agent_files/local`
11. Agent assumptions

`.agent_files` is a memory layer, not the final source of truth.
