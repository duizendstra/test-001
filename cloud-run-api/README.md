# Go Hello World API Template (Cloud Run)

## Overview

This repository contains a Go application designed to serve as a "Hello World" API, suitable for deployment on Cloud Run or similar containerized environments. It showcases a basic project structure, configuration loading, structured logging, HTTP routing with middleware, and testing patterns for a Go-based API.

This project is transformed from an earlier PubSub-to-BigQuery worker to demonstrate a simpler API use case while retaining architectural best practices.

## Features

*   **HTTP Endpoints:**
    *   `GET /hello`: Returns a JSON response with a "Hello, World!" message, service name, and timestamp.
    *   `POST /echo`: Expects a JSON payload `{"text_to_echo": "your message"}` and returns a JSON response echoing the message along with a reply from the service and a timestamp.
    *   `GET /healthz`: A simple health check endpoint returning "ok".
    *   `GET /`: A root endpoint with a welcome message.
*   **Structured Logging:** Uses `log/slog` with a custom handler (`internal/cloudlogging`) for GCP-compatible JSON logs, including trace correlation from the `X-Cloud-Trace-Context` header. Log level is configurable via `LOG_LEVEL` env var.
*   **Configuration:** Loads settings (`ProjectID`, `Port`, `LogLevel`, `ServiceName`) via environment variables using the `internal/config` package.
*   **Middleware:** Includes middleware for Cloud Trace context propagation.
*   **Testability:** Demonstrates unit tests for handlers and server routing using `testify`.
*   **Integration Testing:** Includes basic integration tests that start the server and hit the API endpoints.
*   **Containerized:** Includes a `Dockerfile` for building a minimal, secure distroless container image suitable for deployment. Includes `.dockerignore`.
*   **Development Environment:** Configured for Firebase Studio using `.idx/dev.nix` to provide necessary Go tools and extensions.
*   **Workflow Automation:** (Assumes `Taskfile.yaml` if used) Common development tasks like formatting, linting, building, testing, and running can be managed with `go-task`.

## Prerequisites

1.  **Go:** Version **1.24** or higher (check `go.mod` for the specific version).
2.  **(Optional) Task:** The `go-task` binary if you use a `Taskfile.yaml` for automation.
3.  **Docker:** Required for building and running the container image locally.
4.  **GCP Project:** (Required for full Cloud Logging trace correlation) Access to a GCP project. The `GOOGLE_CLOUD_PROJECT` environment variable must be set.
5.  **Authentication (for local GCP logging):** If running locally and wanting logs to correlate in GCP Console:
    ```bash
    gcloud auth application-default login
    ```

## Configuration

The application uses the following environment variables (see `.env.example`):

*   `GOOGLE_CLOUD_PROJECT`: (Required) Your GCP Project ID. Used for Cloud Logging trace correlation.
*   `PORT`: (Optional) The port the HTTP server listens on. Defaults to `8080`. Cloud Run automatically provides this.
*   `LOG_LEVEL`: (Optional) Sets the minimum logging level. Options: `DEBUG`, `INFO`, `NOTICE`, `WARN`/`WARNING`, `ERROR`, `CRITICAL`, `ALERT`, `EMERGENCY`. Defaults to `INFO`. Case-insensitive.
*   `API_SERVICE_NAME`: (Optional) Service name identifier used in logs and the `/hello` response. Defaults to `go-hello-world-api`.

## Input/Output Payloads

### `GET /hello`
*   **Request:** No payload.
*   **Response (200 OK):**
    ```json
    {
      "message": "Hello, World from go-hello-world-api!",
      "timestamp": "2023-10-27T10:00:00.123456789Z"
    }
    ```

### `POST /echo`
*   **Request Body:**
    ```json
    {
      "text_to_echo": "Your message here"
    }
    ```
*   **Response (200 OK):**
    ```json
    {
      "received_text": "Your message here",
      "reply": "Service 'go-hello-world-api' received your message: 'Your message here'",
      "timestamp": "2023-10-27T10:01:00.123456789Z"
    }
    ```
*   **Response (400 Bad Request):** If `text_to_echo` is missing or empty, or if JSON is malformed.

## Development

## Usage / Workflow (Standard Go Commands)


*   **Build:** Compile the Go application binary.

    ```bash

    go build -o ./bin/app ./cmd/main.go

    ```

*   **Run Locally:** Build and run the application locally. Requires GOOGLE_CLOUD_PROJECT env var.

    ```bash

    # Set required env var if not already exported

    export GOOGLE_CLOUD_PROJECT="your-gcp-project-id"

    # Create a .env file at the project root based on .env.example if needed, or export other vars

    go run ./cmd/main.go

    ```

*   **Run Tests:** Execute Go unit and integration tests.

    ```bash

    go test ./...

    ```

1.  **Environment:** Open the project in Firebase Studio (recommended) or ensure Go, Docker, etc., are installed.
2.  **Dependencies:** `go mod tidy`
3.  **Code Quality:**
    *   Format: `go fmt ./...` or `task format:go`
    *   Lint: `go vet ./...` or `task vet:go` (Consider adding `golangci-lint`)


    task run
    ```
*   **Run Tests:** `task test`
*   **Docker Build:** `task docker:build`
*   **Docker Run:** `task docker:run`

## Example Usage (Curl)

Assuming the service is running locally on port `8080`:

**1. GET /hello:**
```bash
curl -i http://localhost:8080/hello
```

**2. POST /echo:**
```bash
curl -X POST http://localhost:8080/echo \
-H "Content-Type: application/json" \
-i \
-d '{
  "text_to_echo": "Greetings from curl!"
}'
```

**3. GET /healthz:**
```bash
curl -i http://localhost:8080/healthz
```

**4. GET /:**
```bash
curl -i http://localhost:8080/
```

## Deployment (Example: Cloud Run)

1.  **Build & Push Image:**
    Follow standard procedures to build the Docker image (e.g., `docker build -t your-image-name .`) and push it to a registry like Google Artifact Registry.
    Example `Taskfile.yaml` commands (if used) would abstract this.
    ```bash
    # Example using gcloud and Artifact Registry
    export PROJECT_ID="your-gcp-project-id"
    export REGION="your-gcp-region"
    export REPO_NAME="your-artifact-registry-repo"
    export IMAGE_NAME="go-hello-world-api" # Or your chosen name
    export IMAGE_TAG="latest"

    gcloud auth configure-docker ${REGION}-docker.pkg.dev
    docker build -t ${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO_NAME}/${IMAGE_NAME}:${IMAGE_TAG} .
    docker push ${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO_NAME}/${IMAGE_NAME}:${IMAGE_TAG}
    ```

2.  **Deploy to Cloud Run:**
    ```bash
    gcloud run deploy ${IMAGE_NAME} \
      --image=${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO_NAME}/${IMAGE_NAME}:${IMAGE_TAG} \
      --platform=managed \
      --region=${REGION} \
      --allow-unauthenticated \ # OR --no-allow-unauthenticated and configure IAM invoker
      --service-account=your-runtime-sa@${PROJECT_ID}.iam.gserviceaccount.com \
      --set-env-vars=GOOGLE_CLOUD_PROJECT=${PROJECT_ID},LOG_LEVEL=INFO \
      # --set-env-vars=API_SERVICE_NAME=my-prod-hello-world \ # Optional override
      --port=8080 # Port exposed in Dockerfile
    ```

3.  **IAM Permissions:**
    The runtime service account (`your-runtime-sa@...`) needs:
    *   `roles/logging.logWriter` (for Cloud Logging, if GOOGLE_CLOUD_PROJECT is set)
    *   (If `--no-allow-unauthenticated`) Invokers need `roles/run.invoker`.

## Error Handling

*   **HTTP Method Not Allowed (405):** Returned if an incorrect HTTP method is used for an endpoint (e.g., POST to `/hello`).
*   **Bad Request (400):**
    *   Malformed JSON payload for `/echo`.
    *   Missing or empty `text_to_echo` field in `/echo` request.
*   **Not Found (404):** For undefined paths.

## TODO / Future Work

*   Add more example endpoints showcasing different patterns.
*   Implement graceful shutdown in `cmd/main.go`.
*   Enhance integration tests with more scenarios.
*   Integrate a comprehensive linter like `golangci-lint`.
*   Add instructions for setting up `Taskfile.yaml` if it's to be included.
