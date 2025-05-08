# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [0.2.0] - 2025-05-07

### Changed
*   **Project Transformation**: Transformed the project from a PubSub-to-BigQuery worker into a "Hello World" API template.
    *   Removed all BigQuery-specific logic, dependencies, models, and schemas.
    *   Simplified configuration to essential variables (`GOOGLE_CLOUD_PROJECT`, `PORT`, `LOG_LEVEL`, `API_SERVICE_NAME`).
    *   Introduced new HTTP endpoints:
        *   `GET /hello`: Returns a "Hello, World!" JSON response.
        *   `POST /echo`: Echoes a JSON payload.
        *   `GET /healthz`: Standard health check.
        *   `GET /`: Root welcome message.
    *   Updated `internal/models` with simple request/response structs for the new endpoints.
    *   Rewrote `internal/api/handlers.go` and `internal/api/server.go` for the new API logic.
    *   Removed `internal/api/interfaces.go` and `internal/api/adapters.go`.
    *   Updated unit and integration tests to reflect the new "Hello World" functionality.
    *   The core architecture (config loading, structured logging with `slog`, HTTP server setup, middleware for trace context) has been preserved to serve as a template.
    *   Updated `README.md`, `.idx/airules.md` (conceptually), and this `CHANGELOG.md`.

## [0.1.0] - 2025-04-02

### Added

*   **Initial Version of Florbs Go Worker :**
    *   Initial version (PubSub-to-BigQuery worker).

---
<!--
## Link Definitions
-->
<!-- Replace with your actual repository path and tags -->
[0.2.0]: https://github.com/duizendstra/go-cloud-run-api/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/duizendstra/go-cloud-run-api/releases/tag/v0.1.0
