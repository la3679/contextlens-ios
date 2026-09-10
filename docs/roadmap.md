# Release roadmap

All milestones are planned. Each row represents several focused implementation and test commits, followed by a validated annotated tag and GitHub Release.

| Phase | Release | Scope and evidence |
| --- | --- | --- |
| 0–2 | v0.1.0 Foundation | Audit and safe configuration; core/backend scaffolds; declarative iOS project; macOS build, app shell, deterministic UI smoke test and screenshots. |
| 3 | v0.2.0 Intelligence Core | Typed models, providers, privacy routing and fallback; core tests. |
| 4 | v0.3.0 Context Capture & OCR | Text/photo/file import, Vision OCR, normalization, classification baseline and synthetic fixtures; Apple adapter/UI tests and screenshots. |
| 5 | v0.4.0 Cloud Intelligence | Secure OpenAI gateway, structured responses, cloud provider, privacy and provenance; mocked backend/core/iOS tests and controlled live smoke test when possible. |
| 6 | v0.5.0 Local Library & Semantic Search | Persistence, embedding abstraction, local ranking and filters; offline retrieval tests. |
| 7 | v0.6.0 Safe AI Tools | Schemas, allow-list, policy checks and confirmation flows; deterministic policy/UI tests. |
| 8 | v0.7.0 Privacy & Security Hardening | Keychain/CryptoKit as appropriate, cloud enforcement, redaction review, threat model and secret scan. |
| 9 | v0.8.0 UX & Accessibility | Dynamic Type, VoiceOver, light/dark mode, Reduce Motion, loading/error/empty states; asserted UI flows and screenshots. |
| 10 | v0.9.0 Release Candidate | Full regression, measured performance review, dependency/security audit, documentation accuracy and CI stabilization. |
| 11 | v1.0.0 Portfolio Release | All applicable acceptance gates green, final secret/hygiene audit, accurate demo and documentation, full changelog and prior milestone releases. |

CI failures block advancement. Releases must reflect delivered, tested behavior; written code or generated screenshots alone do not establish completion. Audio and newer Apple model capabilities remain conditional on real SDK support and reliable testing.
