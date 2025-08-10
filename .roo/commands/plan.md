---
description: "Create a detailed plan for $ARGUMENTS"
---

Create a detailed implementation plan for $ARGUMENTS following the idioms and
*exact format* used in docs/plan.md to generate a new Phase (or Phases, if
appropriate), then let me review the work. Just give me the markdown format
text, do not edit the docs/plan.md file. Then, wait for my review.

Example of the formatting we need to use:

### Phase 74: Hermetic Telemetry Subsystem Refactor

* **Goal:** To eliminate test flakiness and improve maintainability by
refactoring the telemetry subsystem to use trait-based dependency injection and
mocking, ensuring all tests are hermetically sealed from network and global
state dependencies.
* **Architecture:** This implementation follows the "Full Mocking with
`mockall` Trait" approach (Approach 1). A new `MetricsRecorder` trait will be
defined in `sift-core` and used for dependency injection throughout the
application. This will allow production code to use a real Prometheus-based
recorder while tests use a fully-isolated mock recorder.
* **Specification:** `docs/spec-metrics-refactor3.md`
* **Status:** Not Started
* **Implementation Chunks:**

* **[ ] Chunk 74.1: Define Core Metrics Trait in `sift-core` (TDD)**
    * **File:** `sift-core/Cargo.toml`
    * **Action:** Add `mockall` as a public dependency.
    * **File:** `sift-core/src/telemetry.rs` (new file)
    * **Action:** Define `#[automock] pub trait MetricsRecorder: Send +
    Sync`.
    * **Action:** Add methods to the trait for all required metric
    operations (e.g., `increment_counter`, `set_gauge`,
    `record_histogram`).
    * **Test:** Add a basic compile-time test to ensure the trait and its
    mock are correctly defined and accessible.

* **[ ] Chunk 74.2: Implement Production `RealMetricsRecorder` in
        `sift`**
    * **File:** `sift/src/telemetry/metrics.rs`
    * **Action:** Define `pub struct RealMetricsRecorder` that
    encapsulates the `PrometheusHandle`.
    * **Action:** Implement `impl MetricsRecorder for
    RealMetricsRecorder`. The trait methods will call the corresponding
    `metrics::*` macros.
    * **Action:** Adapt the existing `spawn_server` function to work with
    the `RealMetricsRecorder`.

* **[ ] Chunk 74.6: Documentation and Cleanup**
    * **File:** `docs/spec-metrics-refactor3.md`
    * **Action:** Update the specification to reflect the final
    implementation details and mark it as complete.
    * **File:** `docs/plan.md`
    * **Action:** Mark this phase as complete upon merging.
    * **File:** `docs/journal.md`
    * **Action:** Add an entry detailing the successful refactoring and
    the resolution of the test instability.
