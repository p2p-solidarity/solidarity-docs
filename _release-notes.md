## What's Changed

1.2.2: fix crash bugs and update circuit infra by @kidneyweakx in #10

### Commits

- fc17c87 feat: implement nonce endpoint handling and enhance proof submission flow in OIDC services
- e474e9b feat: enhance OIDC services with async request parsing and improved transaction code handling
- 26bf158 feat: enhance OIDC services with improved request validation and error handling
- 2ac47b5 feat: impl DIDKeyResolver for did:key resolution
- 942fe04 fix: update OpenPassport circuit resource handling to support both .acir and .json formats
- 0b3d071 fix: rename OpenPassport circuit to .acir and stop Cloud CI from overwriting it
- e8e44a4 feat: implement auto-reset for crash sentinel in MoproProofService based on build identifier changes
- 74338d5 feat: enhance MoproProofService logging and error handling for OpenPassport proof generation
- 20b9271 feat: add Face ID usage description to enhance security for identity key management
- f6585bf feat: prefer biometrics-only auth with passcode fallback for unenrolled devices
- a1d5806 feat: refine MoproProofService crash handling with snapshot-at-launch semantics
- 70e79c8 refactor: replace Array<String> properties with Data? in IdentityEntities to resolve CoreData materialization issues; update IdentityDataStore migration marker to v4
- a964a94 ci: add release workflow triggered by version branch merge

**Full Changelog**: https://github.com/p2p-solidarity/solidarity/compare/1.2.1...1.2.2

