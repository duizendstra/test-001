# Go Hello World API Template (Cloud Run)

This Go application template provides a starting point for a "Hello World" API, suitable for deployment on Google Cloud Run or similar containerized environments. It features a basic project structure, configuration loading from environment variables, structured JSON logging with `log/slog` (via `dui-go`), HTTP routing with middleware, and example tests.

This project uses `your-module-name` as its initial Go module path. **You must change this to your own desired module path.**

The development environment within Firebase Studio comes pre-configured with the `contextvibes` CLI, available at `./bin/contextvibes`. This CLI can help streamline common development tasks.

## Quick Start & Setup

1.  **Initialize Your Go Module:**
    *   Decide on your Go module path (e.g., `github.com/your-username/my-cool-api`, or `my-internal-project/service-x`).
    *   In the `go.mod` file, change `module your-module-name` to your chosen module path.
    *   Using your IDE's search and replace, or a tool like `sd` or `rg`, replace all occurrences of `your-module-name/internal` with `your-chosen-module-path/internal` across all `.go` files in this project.
        *Example using `sd` (if installed): `sd 'your-module-name/internal' 'your-chosen-module-path/internal' $(git ls-files '*.go')`*
    *   Run `go mod tidy` to update dependencies.

2.  **Configuration:**
    *   Copy `.env.example` to `.env`.
    *   Update `.env` with your settings, especially `GOOGLE_CLOUD_PROJECT`.
    *   The application loads configuration from environment variables (see `internal/config/config.go`).

3.  **Install Dependencies (if not already handled by `contextvibes` or initial setup):**
    ```bash
    go mod download
    go mod tidy 
    # Or, if contextvibes handles this:
    # ./bin/contextvibes deps
    ```
    *(Adjust the above based on `contextvibes` capabilities)*

## Features

*   **HTTP Endpoints:** (As before)
*   **Structured Logging:** (As before)
*   **Configuration:** (As before)
*   **Middleware:** (As before)
*   **Testing:** (As before)
*   **Containerized:** (As before)
*   **Development Environment:** Configured for Firebase Studio using `.idx/dev.nix`, which provides Go tools, `golangci-lint`, the `contextvibes` CLI, and other utilities.

## Prerequisites

(As before)

## Configuration Variables

(As before)

## Input/Output Payloads

(As before)

## Development Workflow (using `contextvibes` CLI and Go tools)

The `contextvibes` CLI is installed at `./bin/contextvibes` in your Firebase Studio workspace.

*   **Format Code:**
    ```bash
    # Using Go tools:
    go fmt ./...
    # Or, if contextvibes provides a formatting command:
    # ./bin/contextvibes fmt
    ```
*   **Lint Code:**
    The Firebase Studio environment includes `golangci-lint`.
    ```bash
    # Using Go tools:
    go vet ./...
    # For more comprehensive linting with golangci-lint:
    golangci-lint run ./... 
    # Consider adding a .golangci.yml for custom rules

    # Or, if contextvibes provides a linting command (perhaps wrapping the above):
    # ./bin/contextvibes lint
    # ./bin/contextvibes quality
    ```
*   **Run Tests:**
    ```bash
    # Using Go tools:
    go test ./...
    # Or, if contextvibes provides a test command:
    # ./bin/contextvibes test
    ```
*   **Build Binary:**
    ```bash
    # Using Go tools:
    go build -o ./bin/app ./cmd/main.go
    # Or, if contextvibes provides a build command:
    # ./bin/contextvibes build -o ./bin/app 
    ```
*   **Run Locally:**
    Ensure your `.env` file is configured or export necessary environment variables (especially `GOOGLE_CLOUD_PROJECT`).
    ```bash
    # Using Go tools:
    # export GOOGLE_CLOUD_PROJECT="your-gcp-project-id" # Example
    go run ./cmd/main.go

    # Or, if contextvibes provides a run command (it might handle .env loading):
    # ./bin/contextvibes run
    ```
*   **Build Docker Image:**
    ```bash
    docker build -t your-api-image-name .
    # Or, if contextvibes provides a Docker build command:
    # ./bin/contextvibes docker build -t your-api-image-name
    ```
*   **Run Docker Container Locally:**
    ```bash
    docker run -p 8080:8080 -e GOOGLE_CLOUD_PROJECT="your-gcp-project-id" --env-file .env your-api-image-name
    # (Adjust port mapping and ensure .env variables are suitable or use individual -e flags.)
    # Or, if contextvibes provides a Docker run command:
    # ./bin/contextvibes docker run -p 8080:8080 --env-file .env your-api-image-name
    ```

*(**Note to you, Jasper:** You'll need to replace the commented-out `./bin/contextvibes ...` commands with the actual commands your CLI provides for these actions, or remove them if the CLI doesn't cover that specific step, defaulting to the standard Go/Docker commands.)*

## Example Usage (Curl)

(Existing content is good)

## Deployment (Example: Cloud Run)

(Existing content is good)

## Error Handling

(Existing content is good)

## TODO / Future Work

*   Implement graceful shutdown in `cmd/main.go` for the HTTP server.
*   Add more example endpoints showcasing different patterns (see root `ROADMAP.md`).
*   Enhance integration tests with more scenarios.
*   Ensure `contextvibes` CLI commands are well-documented and align with the workflow steps mentioned here.