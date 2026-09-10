# Architecture

Status: design decisions, not implemented behavior.

## Boundaries

- `ContextLensCore`: pure Swift domain models, provider protocols, privacy routing, structured-result normalization, retrieval ranking, cache policy, and tool policy. It must avoid Apple UI, persistence, hardware, and networking dependencies where practical.
- `ContextLensApp`: SwiftUI feature state and navigation; dependency injection for Apple adapters, persistence, and providers. Features are Home, Capture, Analyze, Library, SemanticSearch, and Settings.
- `ContextLensApp/Native`: Vision OCR, photo/file/camera ingestion, and later capability-gated speech or model adapters. Hardware is abstracted for deterministic simulator fixtures.
- `ContextLensApp/Intelligence`: provider implementations and orchestration. Product actions live in `Tools/`. Model output is untrusted; actions require schema validation, an allow-list, policy enforcement, and confirmation for external changes.
- `backend`: Python/FastAPI with typed payloads and an official OpenAI SDK adapter. Only this service reads `OPENAI_API_KEY`. Requests need size/type limits, timeouts, safe error mapping, and structured-response validation. Tests inject a fake upstream provider.
- `Fixtures`, `ContextLensTests`, and `ContextLensUITests`: synthetic inputs, Apple adapter tests, and deterministic end-to-end UI assertions with screenshot artifacts.

## Decisions

1. Use declarative XcodeGen configuration, generated and validated on macOS CI, so all source and project configuration can be maintained on Windows. Select and record an actually available Xcode/SDK during CI foundation work before using version-specific APIs.
2. Prefer Swift 6 concurrency, typed state, and cancellation. Keep SwiftData persistence and Keychain/CryptoKit state protection behind adapters; confirm availability through compilation and tests.
3. Start with deterministic local and mock providers. Add Apple on-device model support only when real SDK and runtime capability checks support it. Report unavailable capabilities truthfully.
4. Cloud processing goes through a policy boundary and `CloudIntelligenceProvider` to the backend over HTTPS outside local development. Local-only mode prohibits transmission. Results retain processing provenance.
5. Search uses a local embedding abstraction, deterministic test embeddings, similarity ranking, filters, and snippets. Choose a real local embedding implementation only after feasibility and quality validation. No external vector database is required.
6. Use the backend default `gpt-5.4-mini-2026-03-17` when `OPENAI_MODEL` is missing or blank; preserve explicit overrides. See [model selection](model-selection.md) for official sources and the evaluation rationale. Account access and live quality are not established by configuration tests.
7. The gateway deployment boundary must include an intentional client-access and abuse-control strategy before public exposure; the provider API key is never a client credential.

## Evidence gates

Backend and pure-domain changes require their relevant test and static checks. Apple-dependent changes require successful macOS simulator builds and appropriate XCTest/XCUITest for the exact pushed commit before the next implementation unit begins. UI tests must assert meaningful state and upload screenshots plus `.xcresult` evidence. Normal tests use no live OpenAI key.

Security CI will scan secrets and repository hygiene, with dependency audits where practical. Every release requires green milestone checks, a clean synchronized tree, an updated changelog, an annotated tag, and meaningful release notes.
