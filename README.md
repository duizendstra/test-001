# Go Starter Templates for Firebase Studio

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
<!-- Add other badges as relevant, e.g., build status, PRs welcome -->

This repository provides a collection of Go application templates designed to accelerate development using [Google's Firebase Studio](https://idx.dev/). Each template offers a well-structured starting point for different types of Go projects, complete with Nix environments for reproducible setups in IDX.

## Vision

To provide a comprehensive set of high-quality, production-ready Go starter templates that integrate seamlessly with Firebase Studio, enabling developers to quickly bootstrap new Go applications with best practices in mind.

## Available Templates

Currently, the following templates are available:

1.  **Cloud Run API Server (Hello World)**
    *   **Description:** A simple "Hello World" style HTTP API server built in Go, ready for deployment on Google Cloud Run or other containerized platforms. It features structured logging, configuration management, basic CRUD-like examples (GET/POST), and a ready-to-use Dockerfile.
    *   **Location:** [`./cloud-run-api/`](./cloud-run-api/)
    *   **Quick Start:** See the [Cloud Run API README](./cloud-run-api/README.md) for detailed instructions.

*(More templates will be added over time! See the [Roadmap](ROADMAP.md).)*

## How to Use with Firebase Studio

These templates are designed to be used with Firebase Studio's "Create a new workspace from a template" feature.

1.  In Firebase Studio, choose to create a new workspace.
2.  Select the option to use a custom template (or "Import a repository").
3.  Provide the URL to this GitHub repository: `https://github.com/[YOUR GITHUB USERNAME]/[YOUR REPO NAME].git`
4.  IDX should detect the `idx-template.json` and `idx-template.nix` files and guide you through selecting one of the available templates defined in `idx-template.json`.

The root `idx-template.nix` handles the bootstrapping process, copying the selected template's files (e.g., everything from the `cloud-run-api` directory) into your new IDX workspace. The Nix environment specified within the chosen template's `.idx/dev.nix` file (e.g., `cloud-run-api/.idx/dev.nix`) will then be used to configure your workspace.

## Contributing

Contributions are highly welcome! Whether it's proposing a new template, improving an existing one, or enhancing the documentation, your help is appreciated.

Please read our [Contributing Guidelines](CONTRIBUTING.md) for more details on how to get started.

## Code of Conduct

Act professionally and respectfully. Be kind, considerate, and welcoming. Harassment or exclusionary behavior will not be tolerated.

## Roadmap

Curious about what's next? Check out our [Project Roadmap](ROADMAP.md) to see planned templates and features.

## License

This project and its templates are licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
