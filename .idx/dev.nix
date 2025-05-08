# .idx/dev.nix
# Merged and Go-focused Nix configuration for Project IDX environment.
# To learn more about how to use Nix to configure your environment
# see: https://developers.google.com/idx/guides/customize-idx-env

{ pkgs, ... }: {
  # Which nixpkgs channel to use. (https://status.nixos.org/)
  channel = "stable-24.11"; # Or choose a specific Nixpkgs commit/tag

  # Use https://search.nixos.org/packages to find packages for Go development
  packages = [
    # --- Core Go Development ---
    pkgs.go # The Go compiler and runtime
    pkgs.gopls # Go Language Server (for editor features)
    pkgs.delve # Go Debugger (Essential for step debugging)
    # pkgs.golangci-lint # Fast Go linters runner / aggregator 
    pkgs.goimports-reviser # Tool to format and revise Go imports
    pkgs.gotools # Collection of Go analysis tools (guru, gorename, etc.)
    # pkgs.gomodifytags    # Optional: Tool for managing struct tags

    # --- Protocol Buffers & gRPC/Connect ---
    # Common dependencies for Go microservices/APIs (keep if using protos)
    # pkgs.protobuf # Protocol Buffers compiler (protoc)
    # pkgs.protoc-gen-go # Protoc plugin for Go code generation
    # pkgs.protoc-gen-go-grpc # Protoc plugin for Go gRPC code generation
    # pkgs.protoc-gen-connect-go # Protoc plugin for Go Connect RPC (uncomment if needed)

    # --- Version Control ---
    pkgs.git # Essential version control system

    # --- Utilities ---
    pkgs.patch # Standard patching utility
    pkgs.jq # Command-line JSON processor
    pkgs.tree # Directory structure viewer
    # pkgs.k6              # Optional: Load testing tool (if needed)
    pkgs.google-cloud-sdk # Optional but often useful: gcloud CLI, gsutil, etc.
  ];

  # Sets environment variables in the workspace
  env = {
    # Example: Set GOPRIVATE for private Go modules
  };

  # Enable Docker daemon service if you need to build/run containers
  services.docker.enable = true;

  idx = {
    # Search for extensions on https://open-vsx.org/ and use "publisher.id"
    extensions = [
      # --- Go Language Support ---
      "golang.go" # Official Go extension (debugging, testing, linting/formatting)

      # --- Version Control ---
      "GitHub.vscode-pull-request-github" # GitHub Pull Request and Issues integration

      # --- Other Useful Extensions ---
      "ms-azuretools.vscode-docker" # Docker integration
    ];

    workspace = {
      # Runs when a workspace is first created with this `dev.nix` file
      onCreate = {
        # Example: Install go-specific tools not in nixpkgs, if needed
        # go-install-tools = "go install golang.org/x/tools/cmd/gorename@latest";
      };
      # Runs every time a workspace is started
      onStart = {
        # Example: Check tool versions
        # check-go-version = "go version";
        # check-lint-version = "golangci-lint --version";
      };
    };

    # Enable previews and customize configuration if you're running web services
    previews = {
      enable = false;
    };
  };
}
