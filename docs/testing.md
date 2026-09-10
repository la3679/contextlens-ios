# Testing and evidence

Each implementation unit is gated by the checks for its pushed commit. A local code review is not evidence of Apple compilation or simulator behavior.

| Workflow | Scope | Evidence |
| --- | --- | --- |
| Security CI | Tracked-file hygiene, ignore policy, empty credential template, Git history secret scan | Four policy regression tests and Gitleaks |
| Backend CI | Python 3.11, locked dependencies, Ruff, strict mypy, tests, runtime dependency audit | Pytest against isolated settings and in-process ASGI transport; outbound network connections blocked |
| Core CI | Pure Swift package, Xcode 16.4 on macOS 15 | Swift tests with compiler warnings treated as errors |

The iOS simulator workflow is the next foundation unit. XCTest/XCUITest, asserted UI flows, screenshots, and `.xcresult` artifacts will be added with the app shell. No simulator evidence is claimed yet.

Backend tests never load the developer's `backend/.env`. Unix/loopback sockets are permitted only for the async runtime; external connections are rejected and the guard is tested. No OpenAI account, API key, or credit consumption is required by normal CI. The health endpoint establishes service liveness, not model availability.

Pure Swift checks can be reproduced with `swift test -Xswiftc -warnings-as-errors` from `ContextLensCore/` where Swift 6 is installed. Windows development does not require installing Apple tools: CI records its actual toolchain and performs the authoritative Apple checks remotely.
