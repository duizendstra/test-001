# idx-template.nix
{ pkgs,
  googleCloudProject,
  apiServiceName ? "go-hello-world-api",
  logLevel ? "INFO",
  port ? "8080",
  ...
}: {
  packages = [
    pkgs.bash
  ];
  bootstrap = ''
    set -ex # Print commands and exit on error

    # --- DEBUG SECTION (can be removed once stable) ---
    echo "--- TEMPLATE DEBUG START ---"
    echo "Value of out: [$out]"
    echo "Value of WS_NAME (Workspace Name): [$WS_NAME]"
    echo "--- TEMPLATE DEBUG END ---"
    # --- END DEBUG SECTION ---

    # Defensive check: if $out is empty, exit with an error message
    if [ -z "$out" ]; then
      echo "CRITICAL ERROR: The \$out variable is empty or not set. Cannot proceed."
      exit 1
    fi

    echo "🚀 Starting Go Cloud Run API template bootstrapping..."
    echo "Copying project files from \${./.} to [$out]..." # Note: ${./.} is Nix interpolation
    mkdir -p "$out"

    shopt -s dotglob
    # CORRECTED COMMAND SUBSTITUTION: Use $(...) directly
    for item in $(ls -A "${./.}"); do # Using Nix interpolation for the source path
      if [[ "$item" != ".git" && "$item" != "idx-template.json" && "$item" != "idx-template.nix" && "$item" != "README-TEMPLATE.md" ]]; then
        # Ensure the source path is correctly interpolated by Nix
        cp -R "${./.}/$item" "$out/"
      fi
    done
    shopt -u dotglob

    chmod -R +w "$out"
    echo "Project files copied."

    echo "Creating .env file with user-provided parameters in $out/.env..."
    # Nix interpolation for variables passed to the template function
    cat <<ENV_EOF > "$out/.env"
GOOGLE_CLOUD_PROJECT=\${googleCloudProject}
API_SERVICE_NAME=\${apiServiceName}
LOG_LEVEL=\${logLevel}
PORT=\${port}
ENV_EOF
    echo ".env file created."

    if [ -f "$out/.idx/dev.nix" ]; then
      echo ".idx/dev.nix found in the new workspace."
    else
      echo "⚠️ WARNING: .idx/dev.nix was not found in the copied files."
    fi

    echo "🎉 Go Cloud Run API template bootstrapping complete!"
    echo "Workspace ID: \$WS_NAME" # Bash variable, not Nix
  '';
}